%% Author: Tasdeeq Sofi, Project: ENHNANCE H2020
% Date: 23/03/21
% Code written for analyzing the tests carried out at UPM
% Capacitance, Impedance and Guided wave Measurements were carried out for DuraAct sensors secondary bonded to PEEK panels

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

% Checks the number of folders to process
nb_folders=0;
for j=1:length (folders)
    if (folders(j).isdir && ~strcmp(folders(j).name,'.') && ~strcmp(folders(j).name,'..'))
        nb_folders=nb_folders+1;
    end
end

% Initalize
time = zeros();
% legend_Var = zeros();

%% Load csv files uisng for loop, obatin frequncy analysis graphs
for i = 1:length(folders) 
   
   if (folders(i).isdir) % Check if it is a folder
       if ( ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..'))% because of '.' and '..'
           % Load all working folders
           fodler_name = folders(i).name;
           folderpath = fullfile(pathstr,fodler_name);
           files = dir(folderpath);
           % Load and plot all csv files
           for i1 = 3:length(files) % because of '.' and '..'
               file_name = files(i1).name;
               filename = fullfile(folderpath, file_name); 
               [folderpath,name,ext] = fileparts(filename);
               if strcmp (ext, '.csv')==1
                  data = readtable(filename);
                  % Obtain frquency, Capacitance and Impedance       
                   Fr = data.(1); % Frequency 
                   data2 = data.(2); % Capacitance and Impdance modulus
                   data3 = data.(3); % Resistance and angle of impedance vector

                   if strcmp (fodler_name, '01_Capacitance')==1    
                       % plot       
                       figure(1)
                       subplot(4,2,(i1-2));
                       Cp = data2;
                       plot (Fr,Cp,'LineWidth',1.5)
                       xlabel ('Frequency [Hz]','FontSize', 14)
                       ylabel ('Capacitance [F]','FontSize', 14)
                       title (file_name(1:(end-8))) 
                       figure(2)
                       plot (Fr,Cp,'LineWidth',1.5)
                       hold on
                       xlabel ('Frequency [Hz]','FontSize', 14)
                       ylabel ('Capacitance [F]','FontSize', 14)
                       legend ('Free', 'S1', 'S2', 'S3', 'S4-Hammer', 'S4', 'S5-Hammer','S5', 'Location','southeast'); 
                   elseif strcmp (fodler_name, '02_Impedance')==1
                       % Obtain frquency, Impedance modulus and phase-angle
                       phi=(pi/180).*data3;% Convert into radians
                       ZR = data2.*cos(phi);%  Real Impedance
                       ZI = data2.*sin(phi);%  Imaginary Impedance
                       AI = abs(1./ZI);%  Imaginary Admittance
                       % plot
                       figure(3)
                       subplot(4,2,(i1-2));
                       plot (Fr,AI,'LineWidth',1.5)
                       xlabel ('Frequency [Hz]','FontSize', 14)
                       ylabel ('Imaginary Admittance [S]','FontSize', 14)
                       title (file_name(1:(end-8)))                   
                       figure(4)
                       plot (Fr,AI,'LineWidth',1.5)
                       hold on
                       xlabel ('Frequency [Hz]','FontSize', 14)
                       ylabel ('Imaginary Admittance [S]','FontSize', 14)
                       legend ('Free', 'S1', 'S2', 'S3', 'S4-Hammer', 'S4', 'S5-Hammer','S5', 'Location','northwest');  
                       figure(5)
                       plot (Fr,ZR,'LineWidth',1.5)
                       hold on
                       xlabel ('Frequency [Hz]','FontSize', 14)
                       ylabel ('Real impedance [Ohm]','FontSize', 14)                       
            %            c = file_name(1:(end-4));
            %            legend_Var(i,1)=c;
            %            legend (legend_Var(1,1),legend_Var(2),legend_Var(3),legend_Var(4),legend_Var(5),legend_Var(6),legend_Var(7),legend_Var(8));
                       legend ('Free', 'S1', 'S2', 'S3', 'S4-Hammer', 'S4', 'S5-Hammer','S5', 'Location','northeast');         
                   end
               elseif  strcmp (fodler_name, '03_GuidedWave')==1          
                   data = load(filename); % '.mat' files
                   A = data.A;
                   B = data.B;
                   for i2 =1:length(A)% obtain time vector
                        time(1,1) = data.Tstart;
                        time((i2+1),1) = data.Tinterval + time(i2,1);
                   end
                   time = time(1:length(A));
                   figure(6);
%                    subplot(2,2,(i1-2));
                   plot (time,A,'LineWidth',1)
                   hold on
                   legend ('Blutack','Hammer','Pristine');                 
                   figure(7);
                   plot (time,B,'LineWidth',1)
                   hold on
                   legend ('Blutack','Hammer','Pristine');
                   title (file_name)
               else
%                    disp ('No working files found in the folder')
               end


           end
       end
   end

   
end