%% Author: Tasdeeq Sofi, Project: ENHNANCE H2020
% Date: 07/05/21
% Code written for analyzing the tests carried out with C6o to repeat the tests carried over the specime for UPM
% Capacitance, Impedance, admittance  and other values measuremnsts are carried out for DuraAct sensors secondary bonded to PEEK panels
% Instructions: Select the folder containing the capacitance, impedance and the guide wave measurements in seprate folders "e.g., 01_TestData located at UPM_22-03-21_CP-IP-GW"

%% Prepare workspace and Define parameters if any
clear;
close all;
clc;
warning off;

%% Load working directory and Intialize
% Input the folder to work with
main_dir=uigetdir('C:\Users\tsofi\OneDrive\01_ENHAnCE\07_ExperimentalData'); 
folders = dir(main_dir);
pathstr = folders(1).folder;


%% Load text files, process them, plot and store the results
% legend_Var = zeros();% automate legend

for i = 3:length(folders)% because of '.' and '..'
   
    if (folders(i).isdir) % Check if it is a folder/directorty
        if ( ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..'))% because of '.' and '..'
            % Load all working folders
            folder_name = folders(i).name;
            folderpath = fullfile(pathstr,folder_name);
            files = dir(folderpath);
            
            for i1 = 3:length(files) % because of '.' and '..'
                file_name = files(i1).name;
                filename = fullfile(folderpath, file_name);
                [folderpath,name,ext] = fileparts(filename);
                
                [Fr, Avg_Ad ,Avg_Zr] = Avg_val(filename);% Function Avg_val calculates the average of Ad and Zr each measuremmet
                
                % Store all data with their names in the specfic folders
                str = strsplit(filename,filesep);
                foldername=str{1,end-1};
                filename = str{1,end};
                filename=filename(1:(end-4));
                strAd = strcat(foldername,'_',filename,'_','AvgAd');
                strZr = strcat(foldername,'_',filename,'_','AvgZr');
                
                p = mfilename('fullpath');
                p = fileparts([p,mfilename]);
                
                sav_folder1 =strcat(foldername,'AvgAd-Plots');
                sav_folder2 =strcat(foldername,'AvgZr-Plots');
                
                mkdir((sav_folder1))
                cd (strcat(p,'\',sav_folder1))
                save(sprintf(strAd),'Avg_Ad')
                
                cd (p);
                mkdir((sav_folder2))
                cd (strcat(p,'\',sav_folder2))
                save(sprintf(strZr),'Avg_Zr')
                cd (p);
                
                figure ((2*i)-5);
                plot (Fr,Avg_Ad, 'LineWidth',1)
                hold on
                xlabel ('Frequency [Hz]','FontSize', 20)
                ylabel ('Admiattance [S]','FontSize', 20)
                title (erase(sav_folder1,"_"))
                legend ('Baseline','Level1', 'Level2', 'Level3', 'Location','southeast');
                
                figure ((2*i)-4);
                plot (Fr,Avg_Zr,'LineWidth',1)
                hold on
                xlabel ('Frequency [Hz]','FontSize', 20)
                ylabel ('Impedance [Ohm]','FontSize', 20)
                title (erase(sav_folder2,"_"))
                legend ('Baseline','Level1', 'Level2', 'Level3', 'Location','southeast');
                
            end
        end
    end

   
end
