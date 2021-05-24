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

% Find size and number of files to process in each cell row
[s1, s2]=size(C_Avg_Ad);
n =  f-2; % Maximum number of files to process in any folder
n = n(n>0); % Remove the empty folders

% Obtain and plot the slopes of the linear fit curves to the admittance measurements 
C_m(all(cellfun('isempty',C_m),2),:) = [];
C_strAd(all(cellfun('isempty',C_strAd),2),:) = [];
C_strRr(all(cellfun('isempty',C_strRr),2),:) = [];


% Obtain and plot the Ft = Frechet Distance for each admittance and resitance measurement w.r.t to baseline data/reference data. 
[C_Ft_Ad,C_Ft_Rr] = deal(cell(1, s1)); % Ft = Frechet Discrete

for i3 = 1:s1
    
    [Ft_Ad,Ft_Rr] = deal (zeros());
    lgd = C_strAd (i3,:);
    lgd = lgd (~cellfun('isempty',lgd));
    SpltStr = regexp(lgd{1,1},'_','split');
    lgd = erase(lgd,'_');
    lgd = erase(lgd,(strcat(SpltStr{1,1:2})));
    
    % Uncomment for stroing and plotting devaition of slope for each line w.r.t to reference
    %{
    m_array1 = C_m(i3,:);
    m_array = cell2mat(m_array1);
    figure()
    m_array=smooth(m_array);
    plot(m_array)
    hold on
    plot(m_array,'o');
    hold on
    width =0.2;
    b1=bar(m_array,width);
    title(strcat(SpltStr{1,1:2}))
    set(gca,'XTickLabels',lgd)
    set(gca, 'XTick', linspace(1,length(lgd),length(lgd)), 'XTickLabels', lgd)
    xtickangle(45)
    %}
    
    for i4 = 1:n(i3)
        A = C_Avg_Ad {i3,1};% 1 is the baseline measurement
        B = C_Avg_Ad {i3, i4};
        C = C_Avg_Rr {i3,1};
        D = C_Avg_Rr {i3, i4};
        Ft_Ad (i4) = DiscreteFrechetDist(A,B); % Frechet Distance for Admittance plots
        Ft_Rr (i4) = DiscreteFrechetDist(C,D); % Frechet Distance for Resistance plots
    end
    
    C_Ft_Ad {i4} = Ft_Ad;
    C_Ft_Rr {i3} = Ft_Rr;
    
    % Difference between Admittance plots
    figure()
    Ft_Ad=smooth(Ft_Ad);
    plot(Ft_Ad)
    hold on
    plot(Ft_Ad,'+');
    hold on
    width =0.2;
    b2=bar(Ft_Ad,width);
    title(strcat(SpltStr{1,1:2}))
    set(gca,'XTickLabels',lgd)
    set(gca, 'XTick', linspace(1,length(lgd),length(lgd)), 'XTickLabels', lgd)
    xtickangle(45)

%     
    % Difference between Resistance plots
%     {
    figure()
    Ft_Rr=smooth(Ft_Rr);
    plot(Ft_Rr)
    hold on
    plot(Ft_Rr,'+');
    hold on
    width =0.2;
    b3=bar(Ft_Rr,width);
    title(strcat(SpltStr{1,1:2}))
    set(gca,'XTickLabels',lgd)
    set(gca, 'XTick', linspace(1,length(lgd),length(lgd)), 'XTickLabels', lgd)
    xtickangle(45)
    %}
    
end
