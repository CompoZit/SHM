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

%%
% Open and read file 
filename = 'C:\Users\tsofi\Documents\Cypher\Export\S1.txt';
fid = fopen(filename);
data = textscan(fid, '%s %s %s %s %s %s %s %s','delimiter',',');
fclose(fid);


% Find the number of data points for each measurement
data1= data{1,1};
datapts = data1(4,1);
datapts = cell2mat (datapts);
datapts= datapts(16:end);
datapts= str2double(datapts)+8;

for i = 1:length (data1)
    Fr = data1(9:datapts);
    Fr = str2double(Fr); 
    
end


%% replace by a for loop
Fr = data1(9:datapts);
Fr = str2double(Fr);
Fr2 = data1(datapts+6:end);
Fr2 = str2double(Fr2);

data2 = data{1,3};
AI = data2(9:datapts);
AI = str2double(AI);
AI2 = data2(datapts+6:end);
AI2 = str2double(AI2);

data3 = data{1,5};
ZR = data3(9:datapts);
ZR = str2double(ZR);
ZR2 = data3(datapts+6:end);
ZR2 = str2double(ZR2);

figure(1)
plot(Fr, AI)
hold on
plot(Fr, AI2)

% hold off

figure(2)
plot(Fr, ZR)
hold on
plot(Fr, ZR2)



