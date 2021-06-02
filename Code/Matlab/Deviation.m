%% Summary
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

% Find size and number of files to process in each cell row
[s1, s2]=size(C_Avg_Ad);
n =  f-2; % Maximum number of files to process in any folder
n = n(n>0); % Remove the empty folders

% Delete the empty rows from the slope data, peaks data and the corresponding frequency at the peaks
C_m(all(cellfun('isempty',C_m),2),:) = [];
C_max_pks(all(cellfun('isempty',C_max_pks),2),:) = [];
C_Fr_pks(all(cellfun('isempty',C_Fr_pks),2),:) = [];

% Obtain and plot the Ft = Frechet Distance for each admittance and resitance measurement w.r.t to baseline data/reference data. 
[C_Ft_Ad,C_Ft_Rr] = deal(cell(1, s1)); % Ft = Frechet Descrete Distance

for i3 = 1:s1
    
    [Ft_Ad,Ft_Rr] = deal (zeros());
    lgd = C_strAd (i3,:);
    lgd = lgd (~cellfun('isempty',lgd));
    SpltStr = regexp(lgd{1,1},'_','split');
    lgd = erase(lgd,'_');
    lgd = erase(lgd,(strcat(SpltStr{1,1:2})));
    
    % Storing and plotting devaition of Admittance and Resistance for each data measurement w.r.t to reference (Baseline)
    for i4 = 1:n(i3)
        A = C_Avg_Ad {i3,1};% Baseline/Reference measurement, make sure to keep the baseline measurement as the fisrt file in the test folder
        B = C_Avg_Ad {i3, i4};
        C = C_Avg_Rr {i3,1};
        D = C_Avg_Rr {i3, i4};
        Ft_Ad (i4) = FrechetDist(A,B); % Frechet Distance for Admittance plots
        Ft_Rr (i4) = FrechetDist(C,D); % Frechet Distance for Resistance plots
        R = corrcoef(A,B);
        cr = xcorr(A,B); % Implement cross relation and prinicipal component analysis
        figure(1)
        plot(cr)
        hold on
%         pause(2)
    end
    
    C_Ft_Ad {i3} = Ft_Ad;
    C_Ft_Rr {i3} = Ft_Rr;
    
    % Frechet Distance difference between Admittance plots
    [~] = Bar_prop(Ft_Ad,SpltStr,lgd,'Frechet Distance Admittance data');
    
    % Frechet Distance difference between Resistance plots
%     [~] = Bar_prop(Ft_Rr,SpltStr,lgd,'Frechet Distance Resistance data'); 

   % Stroing and plotting devaition of slopes and peaks for each line w.r.t to reference
    m_array = C_m(i3,:);
    pks_array = C_max_pks(i3,:);
    Fr_pks_array = C_Fr_pks (i3,:);
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