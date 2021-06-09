% Summary
%{
- This code analysis the devaition in the admittance and resistance data for different
  sensors as compared to baseline data. It devaition in the data  can be used to find if the sensors are well bonded and helaty or not.
- Obtain slopes of linear fits to the admittance data
- Find the devaition between admittance data using Frechet Distance
%}

%% Load all averaged data and find the Frechet Discretes w.r.t referenc data and slope for linear fit to admittance measurement
% Delete the empty rows from the Admittance, the Resistace and nanme string data
C_Avg_Ad(all(cellfun('isempty',C_Avg_Ad),2),:) = [];
C_Avg_Rr(all(cellfun('isempty',C_Avg_Rr),2),:) = [];
C_strAd(all(cellfun('isempty',C_strAd),2),:) = [];
C_strRr(all(cellfun('isempty',C_strRr),2),:) = [];

% Delete the empty rows from the slope data, peaks data and the corresponding frequency at the peaks data
C_m(all(cellfun('isempty',C_m),2),:) = [];
C_max_pks(all(cellfun('isempty',C_max_pks),2),:) = [];
C_Fr_pks(all(cellfun('isempty',C_Fr_pks),2),:) = [];

% Find size and number of files to process in each cell row
[s1, s2] = size(C_Avg_Ad);
mx_files = nb_files-2; % Maximum number of files to process in any folder
mx_files = mx_files(mx_files>0); % Remove the empty folders

%% Plot impact potential energies
m = [23.5 138.8]*10^-3; % in Kg
h = [550 1326 1876]*10^-3; % in m
g = 9.81; % in ms^-2
p_e = zeros(); 
for i3 = 1: length(m)
    for i4 = 1: length(h)
        p_e (i3,i4) = m(i3)*g*h(i4); % In Joule Nm
    end
end

%% Obtain and plot the different indicators/values that shows the deviation of new data w.r.t to baseline data/reference data. 
[C_Ft_Ad,C_Ft_Rr,C_max_R,C_CR] = deal(cell(1, s1)); % Ft = Frechet Descrete Distance



%% How to set a thershold beyound which the sensors are no longer working and reliable like in terms of percentage 
% Should the pristine be considered as a thershold 
% RMSD and Frechet distance in terms of percentage 
% Or signal dufference percentage
% Peak to peak percentage is clear. Here the threhold should be less than 5% change in the signal w.r.t to pristine signal



for i5 = 1:s1
    
    [Ft_Ad,Ft_Rr,RMSE,max_R,CR] = deal (zeros());
    lgd = C_strAd (i5,:);
    lgd = lgd (~cellfun('isempty',lgd));
    SpltStr = regexp(lgd{1,1},'_','split');
    lgd = erase(lgd,'_');
    lgd = erase(lgd,(strcat(SpltStr{1,1:2})));
    
    % Storing and plotting devaition of Admittance and Resistance for each data measurement w.r.t to reference (Baseline)
    for i6 = 1:mx_files(i5)
        A = C_Avg_Ad {i5,1};% Baseline/Reference measurement, make sure to keep the baseline measurement as the fisrt file in the test folder
        B = C_Avg_Ad {i5, i6};
        C = C_Avg_Rr {i5,1};
        D = C_Avg_Rr {i5, i6};
        
        Ft_Ad (i6) = FrechetDist(A,B); % Frechet Distance for Admittance plots, RMSE gives similar values
        RMSE (i6)=sqrt(mean((A-B).^2));
        Ft_Rr (i6) = FrechetDist(C,D); % Frechet Distance for Resistance plots
%         Implement cross relation and prinicipal component analysis
%         The cross relatin should be used for the same sensor to compare the sinal at two points of time and not between different sensors 
        R = crosscorr(A,B); % crosscorr Gives good value as compared to xcorr
        max_R(i6) = max(R);
        ss =((A-mean(A)).*(B-mean(B)));
        CR(i6) = (1/length(A))*sum(ss)/(std(A)*std(B));  % Using own function to obtain the cross corelation factor
    end
    
    % Cell data to store the different values
    C_Ft_Ad {i5} = Ft_Ad;
    C_Ft_Rr {i5} = Ft_Rr;
    C_max_R{i5} = max_R;
    C_CR{i5} = CR;
    
    
    %% Plot the data
    % Frechet Distance difference and root mean square difference between Admittance plots
    [~] = Bar_prop(Ft_Ad,SpltStr,lgd,'Frechet Distance Admittance data');
    [~] = Bar_prop(CR,SpltStr,lgd,'Cross corelation data');
%     [~] = Bar_prop(RMSE,SpltStr,lgd,'Root mean difference admittance data');
    
    % Frechet Distance difference between Resistance plots
%     [~] = Bar_prop(Ft_Rr,SpltStr,lgd,'Frechet Distance Resistance data'); 

   % Stroing and plotting devaition of slopes and peaks for each line w.r.t to reference
    m_array = C_m(i5,:);
    pks_array = C_max_pks(i5,:);
    Fr_pks_array = C_Fr_pks (i5,:);
%     [~] = Bar_prop(m_array,SpltStr,lgd,'Linear fit Slope');
%     [~] = Bar_prop(pks_array,SpltStr,lgd,'Peaks for Resistance data'); % Find highest peak between (200-450K): Useful during bending, Fatigue & AOE tests
%     [~] = Bar_prop(Fr_pks_array,SpltStr,lgd,'Peaks Frequency'); % Find frequency of highest peak
   
end


%% Function definitions
function [array] = Bar_prop(array,SpltStr,lgd,lgdname) 

%{
- To plot bar graphs with specific properties
%}

if iscell(array)
    array = cell2mat(array);
end
figure()
width =0.3;
bar(array,width);
legend(lgdname)
title(strcat(SpltStr{1,1:2}))
set(gca,'XTickLabels',lgd)
set(gca, 'XTick', linspace(1,length(lgd),length(lgd)), 'XTickLabels', lgd)
xtickangle(45)

end