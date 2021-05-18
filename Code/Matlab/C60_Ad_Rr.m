%% Author: Tasdeeq Sofi, Project: ENHNANCE H2020
% Date: 07/05/21
% Code written for analyzing the tests carried out with C60 to repeat the tests carried over the specimen for UPM
% Capacitance, Impedance, admittance  and other values measuremnsts are carried out for DuraAct sensors secondary bonded to PEEK panels
% Instructions: Select the folder containing the capacitance, impedance and the guide wave measurements in seprate folders "e.g., 01_TestData located at UPM_22-03-21_CP-IP-GW"

%% Prepare workspace and Define parameters if any
clr;

%% Load working directory and Intialize
% Input the folder to work with
main_dir=uigetdir('C:\Users\tsofi\OneDrive\01_ENHAnCE\07_ExperimentalData'); 
folders = dir(main_dir);
pathstr = folders(1).folder;

% Checks the number of folders to process
nb_folders=0;
m =zeros();
for i=1:length (folders)
    if (folders(i).isdir && ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..'))
        folder_name = folders(i).name;
        folderpath = fullfile(pathstr,folder_name);
        files = dir(folderpath);
        m(i) = length (files);
        nb_folders=nb_folders+1;
    end
end

%% Load text files, process them, plot and store the results
C_Avg_Ad = cell(nb_folders, (max(m)-2));
C_Avg_Rr = cell(nb_folders, (max(m)-2));
for i1 = 3:length(folders)% because of '.' and '..'
   
    if (folders(i1).isdir) % Check if it is a folder/directorty
        if ( ~strcmp(folders(i1).name,'.') && ~strcmp(folders(i1).name,'..'))% because of '.' and '..'
            % Load all working folders
            folder_name = folders(i1).name;
            folderpath = fullfile(pathstr,folder_name);
            files = dir(folderpath);
            
            for i2 = 3:length(files) % because of '.' and '..'
                file_name = files(i2).name;
                filename = fullfile(folderpath, file_name);
                [folderpath,name,ext] = fileparts(filename);
                
                [Fr, imp ,Avg_Ad ,Avg_Rr] = Avg_val(filename);% Function Avg_val calculates the average of Ad and Zr for each measuremmet
                C_Avg_Ad {(i1-2),(i2-2)}=Avg_Ad;
                C_Avg_Rr {(i1-2),(i2-2)}=Avg_Rr;
                
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
                
                txt = (erase(filename,"_"));
                figure ((2*i1)-5);
                plot (Fr,Avg_Ad,'DisplayName',txt,'LineWidth',1)
                hold on
                xlabel ('Frequency [Hz]','FontSize', 20)
                ylabel ('Admittance [S]','FontSize', 20)
                title (erase(sav_folder1,"_"))
                legend show
                
                figure ((2*i1)-4);
                plot (Fr,Avg_Rr,'DisplayName',txt,'LineWidth',1)
                hold on
                xlabel ('Frequency [Hz]','FontSize', 20)
                ylabel ('Resistance [Ohm]','FontSize', 20)
                title (erase(sav_folder2,"_"))
                legend show

                
            end
        end
    end

   
end

