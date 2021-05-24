%% Author: Tasdeeq Sofi, Project: ENHNANCE H2020
%{ 
- Date: 07/05/21
- Code written for analyzing the test data carried out with C60
- Measurememts: Capacitance, Impedance, admittance  and other values for DuraAct sensors secondary bonded to PEEK panels
- Instructions: Select the folder containing the measurements (01_TestFolder) from C60 analysis e.g., 01_TestFolder located at
  C:\Users\tsofi\OneDrive\01_ENHAnCE\07_ExperimentalData\01_Tests\02_C60_Sim_Defects,similarly for every test folder 
- History of the code can be found at Github
%}

%% Prepare workspace and Define parameters if any
clr;

%% Load working directory and Intialize
% Input the folder to work with
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
[C_Avg_Ad, C_Avg_Rr,C_strAd,C_strRr, C_m] = deal(cell(nb_folders, (max(f)-2)));

for i1 = 3:length(folders)% 3 because of '.' and '..'
   
    if (folders(i1).isdir) % Check if it is a folder/directorty
        if ( ~strcmp(folders(i1).name,'.') && ~strcmp(folders(i1).name,'..'))
            % Load all working folders
            folder_name = folders(i1).name;
            folderpath = fullfile(pathstr,folder_name);
            files = dir(folderpath);
            
            for i2 = 3:length(files) % 3 because of '.' and '..'
                file_name = files(i2).name;
                filename = fullfile(folderpath, file_name);
                [folderpath,name,ext] = fileparts(filename);
                
                [Testdata, data, Fr, Avg_Ad ,Avg_Rr] = Avg_val(filename);% Function Avg_val calculates the average of Ad and Zr for each measuremmet
                C_Avg_Ad {(i1-2),(i2-2)}=Avg_Ad;
                C_Avg_Rr {(i1-2),(i2-2)}=Avg_Rr;
                [R,m,c,Pev]=Leastsq_Regression(Fr,Avg_Ad);
                
                % Normalize
%                 Avg_Ad = (Avg_Ad-min(Avg_Ad))/(max(Avg_Ad)-min(Avg_Ad));
%                 Avg_Zr = (Avg_Zr-min(Avg_Zr))/(max(Avg_Zr)-min(Avg_Rr));              
                
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
                
%                 figure ((2*i1-5))                
                figure ((i1-2))
                subplot(2,1,1);
                txt = (erase(filename,"_"));
                Fr = smooth(Fr);
                Avg_Ad=smooth(Avg_Ad);
                loglog(Fr,Avg_Ad,'DisplayName',txt,'LineWidth',1)
                [~] = Plot_prop(sav_folder1,Fr,'Admittance [S]');
                
%                 figure ((2*i1-4))
                subplot(2,1,2);
                Fr = smooth(Fr);
                Avg_Rr=smooth(Avg_Rr);
                plot(Fr,Avg_Rr,'DisplayName',txt,'LineWidth',1)
                [~] = Plot_prop(sav_folder2,Fr,'Resistance [Ohm]');
                
                % Linear fit of data to the plots, store m (Slopes) values and compare the curves based on their m(Slopes)
                if strcmp (folder_name, 'BaseLine')==1
                    figure((2*nb_folders)+1);
                    plot(Fr,Pev,'DisplayName',txt,'LineWidth',1);
                    [~] = Plot_prop(sav_folder1,Fr,'Admittance [Ohm]');
                end

                
            end
        end
    end

   
end

%% Deviation
Deviation

