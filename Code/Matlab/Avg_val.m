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

