function [Fr, Avg_Ad ,Avg_Zr] = Avg_val(filename)
% Summary of this function goes here:
%   Author:Tasdeeq Sofi
%   Detailed explanation goes here
%   Input = Text file to be processed
%   Output = Average values of the frequnecy, admittance and the impedance vector


%% Open and read file 
fid = fopen(filename);
data = textscan(fid, '%s %s %s %s %s %s %s %s','delimiter',',');
% C = textscan(fid,'%f%f%f%f%f%f%f%f',1,'Delimiter',',','Headerlines',9);
fclose(fid);

% Find the number of data points in a single measurement
data1= data{1,1}; % contains the test  and the frequency data
datapts = data1(4,1);
datapts = cell2mat (datapts);
datapts= datapts(16:end); % Obtain the number of data points 
datapts= str2double(datapts)+8; % Initial 8 line contain the test data, automate this 8 as well by finding the loaction of the header lines
k= round(length(data1)/300);

% laod all the test data
Fr = data1(9:datapts);% Frequency data
Fr = str2double(Fr); 
Ad = data{1,3}; % Admittance data
Zr = data{1,5}; % Impedance data

%% Read each maeasurement and find the mean values of the loops
C_Ad = cell(1,k);
C_Zr = cell(1,k);

% Loop for each repeated measurements load the values using a loop   
    for j=1:k % number of total data sets
        Ad_new = Ad((305*j-296):(j*datapts-(j-1)*3)); % Automate 305*j-296
        Ad_new = str2double(Ad_new);
        C_Ad{j} =Ad_new;
        
        Zr_new = Zr((305*j-296):(j*datapts-(j-1)*3));
        Zr_new = str2double(Zr_new);
        C_Zr{j} = Zr_new; 
    end
    

Avg_Ad = mean(cat(3,C_Ad{:}),3);
Avg_Zr = mean(cat(3,C_Zr{:}),3);


end

