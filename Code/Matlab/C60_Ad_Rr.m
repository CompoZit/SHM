%% Author: Tasdeeq Sofi, Project: ENHNANCE H2020
%{ 
- Date: 07/05/21
- Code written for analyzing the test data carried out with C60 impedance analyzer
- Measurememts: Capacitance, Impedance, admittance  and other values for DuraAct sensors secondary bonded to PEEK panels
- Instructions: Select the folder containing the measurements (01_TestFolder) from C60 analysis e.g., 01_TestFolder located at
  C:\Users\tsofi\OneDrive\01_ENHAnCE\07_ExperimentalData\01_Tests\02_C60_Sim_Defects,similarly for every test folder 
- History of the code can be found at Github (Tasdeeq/SHM/Code/Matlab)
- Function definitions have been defined inside the script, this can work in Matlab versions higher than 2016b, 
  if you are using versions lower than 2016b please define the functions separately
%}

%% Prepare workspace and Define parameters if any
clr;

%% Load working directory and Intialize
% Input the folder to work with:
main_dir=uigetdir('C:\Users\tsofi\OneDrive\01_ENHAnCE\07_ExperimentalData'); 
folders = dir(main_dir);
pathstr = folders(1).folder;

% Checks the number of folders to process
nb_folders=0;
f =zeros();
for i=1:length (folders)
    if (folders(i).isdir && ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..'))
        folder_name = folders(i).name;
        folderpath = fullfile(pathstr,folder_name);
        files = dir(folderpath);
        f(i) = length (files);
        nb_folders=nb_folders+1;
    end
end

%% Load text files, process them, plot and store the results
[C_Avg_Ad, C_Avg_Rr,C_strAd,C_strRr, C_m,C_max_pks, C_Fr_pks] = deal(cell(nb_folders, (max(f)-2)));

for i1 = 3:length(folders)% Because first two entries are '.' and '..'
   
    if (folders(i1).isdir) % Check if it is a folder/directorty
        if ( ~strcmp(folders(i1).name,'.') && ~strcmp(folders(i1).name,'..'))
            % Load all working folders
            folder_name = folders(i1).name;
            folderpath = fullfile(pathstr,folder_name);
            files = dir(folderpath);
            
            for i2 = 3:length(files) % Because first two entries are '.' and '..'
                file_name = files(i2).name;
                filename = fullfile(folderpath, file_name);
                [folderpath,name,ext] = fileparts(filename);
                
                [Testdata, data, Fr, Avg_Ad ,Avg_Rr] = Avg_val(filename);% Function Avg_val loads & obtains the average of Ad & Rr for each measuremmet
                C_Avg_Ad {(i1-2),(i2-2)}=Avg_Ad;
                C_Avg_Rr {(i1-2),(i2-2)}=Avg_Rr;
                [R,m,Pev]=Leastsq_Regression(Fr,Avg_Ad);% R = Correlation coefficient, m =slope
                
                % Normalize
%                 Avg_Ad = (Avg_Ad-min(Avg_Ad))/(max(Avg_Ad)-min(Avg_Ad));
%                 Avg_Rr = (Avg_Rr-min(Avg_Rr))/(max(Avg_Rr)-min(Avg_Rr));              
                
                % Store all data with their names in the specfic folders
                str = strsplit(filename,filesep);
                foldername=str{1,end-1};
                filename = str{1,end};
                filename=filename(1:(end-4));
                strAd = strcat(foldername,'_',filename,'_','AvgAd');
                strRr = strcat(foldername,'_',filename,'_','AvgRr');
                
                C_strAd {(i1-2),(i2-2)}=strAd;
                C_strRr {(i1-2),(i2-2)}=strRr;
                C_m {(i1-2),(i2-2)}=m;
                idx1 = Fr>(2e5) & Fr<(4.5e5); 
                pks = findpeaks(Avg_Rr(idx1)); % Find the peaks between a specefic Frequency range (200K-450K)
                C_max_pks {(i1-2),(i2-2)}= max(pks);
                max_pks = ismember(Avg_Rr,max(pks));
                idx2 = find(max_pks );
                C_Fr_pks {(i1-2),(i2-2)} = Fr(idx2);
                
                p = mfilename('fullpath');
                p = fileparts([p,mfilename]);
                
                sav_folder1 =strcat(foldername,'AvgAd-Plots');
                sav_folder2 =strcat(foldername,'AvgRr-Plots');
                
                mkdir((sav_folder1))
                cd (strcat(p,'\',sav_folder1))
                save(sprintf(strAd),'Avg_Ad') % Directly give path here in save function?
                
                cd (p);
                mkdir((sav_folder2))
                cd (strcat(p,'\',sav_folder2))
                save(sprintf(strRr),'Avg_Rr')
                cd (p);
                
                figure ((2*i1-5))                
%                 figure ((i1-2))
%                 subplot(2,1,1);
                txt = (erase(filename,"_"));
                loglog(Fr,Avg_Ad,'DisplayName',txt,'LineWidth',1)
                [~] = Plot_prop(sav_folder1,Fr,'Admittance [S]');
                
                figure ((2*i1-4))
%                 subplot(2,1,2);
                semilogy(Fr,Avg_Rr,'DisplayName',txt,'LineWidth',1)
                [~] = Plot_prop(sav_folder2,Fr,'Resistance [Ohm]');
                
                % Linear fit of data to the plots, store m (Slopes) values and compare the curves based on their m(Slopes)
                if strcmp (folder_name, 'BaseLine_Data')==1
                    figure((2*nb_folders)+1);
                    plot(Fr,Pev,'DisplayName',txt,'LineWidth',1);
                    [~] = Plot_prop(sav_folder1,Fr,'Admittance [Ohm]');
                end

                
            end
        end
    end

   
end

%% Deviation and difference between different plots and signals 
% Deviation


%% Function definitions
function [Testdata, data, Fr, Avg_Ad ,Avg_Rr] = Avg_val(filename)

% Summary of this function goes here:
%{
- This function calculates the Capacitance,average impedance and admittance for each measurement 
- Input = Text file to be processed
- Output = Average values of the frequnecy, admittance and the impedance vector
%}

%% Open and read file 
fid = fopen(filename,'r');
data = textscan(fid, '%s %s %s %s %s %s %s %s','delimiter',',');
fclose(fid);

% Find the number of data points in a single measurement
data1= data{1,1}; % contains the test  and the frequency data
Testdata = data1(2:7);
datapts = char(data1(4,1));
ind = find(contains(data1,datapts));
d = ind(2)-ind(1); % Common difference
datapts = str2double(datapts(end-3:end));% Obtain the number of data points   
k= round(length(data1)/(datapts)); % Initial 8 line contain the test data, automate this 8 as well by finding the loaction of the header lines
datapts = datapts+8;

%% Laod all the test data
% Capcitance
Fr = data1(9:datapts);% Frequency data
Fr = str2double(Fr); 
Ad = data{1,3}; % Admittance data
Rr = data{1,5}; % Resistance data

%% Read each maeasurement and find the mean values of the loops
C_Ad = cell(1,k);
C_Rr = cell(1,k);

% Loop for each repeated measurements load the values using a loop   
    for j=1:k % number of total data sets
        Ad_new = Ad((9+(j-1)*d):(j*datapts-(j-1)*3));% Arthmetic progression a_n = a_1 +(n-1)*d
        Ad_new = str2double(Ad_new);
        C_Ad{j} =Ad_new;
        
        Rr_new = Rr((9+(j-1)*d):(j*datapts-(j-1)*3));
        Rr_new = str2double(Rr_new);
        C_Rr{j} = Rr_new; 
    end
    
Avg_Ad = mean(cat(3,C_Ad{:}),3);
Avg_Rr = mean(cat(3,C_Rr{:}),3);

end

function [xlim1] = Plot_prop(sav_folder,Fr,Ylabel) 

%{
- To plot the admittance, the resistance and other graphs with specific properties
%}

yticks = get(gca,'YTick');
set(gca,'YTickLabel',yticks);
xticks = get(gca,'XTick');
set(gca,'XTickLabel',xticks);
xlabel ('Frequency [Hz]','FontSize', 20)
ylabel (Ylabel,'FontSize', 20)
xlim1=Fr(end,1);
xlim ([xlim1 Fr(1,1)])
title (erase(sav_folder,'_'))
legend show
legend('Location','Best')
hold on

end


