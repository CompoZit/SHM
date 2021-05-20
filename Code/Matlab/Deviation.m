% Summary
%{
Write summary here
%}
%% Load all averaged data and find the Frechet Discrete and Hausdroff distance between the baseline and the other curves
% Delete the empty rows
C_Avg_Ad(all(cellfun('isempty',C_Avg_Ad),2),:) = [];
C_Avg_Rr(all(cellfun('isempty',C_Avg_Rr),2),:) = [];
C_strAd(all(cellfun('isempty',C_strAd),2),:) = [];
C_strRr(all(cellfun('isempty',C_strRr),2),:) = [];

% Find size and number of files to process in each cell row
[s1, s2]=size(C_Avg_Ad);
n =  m-2; % Maximum number of files to process in any folder
n = n(n>0); % Remove the empty folders

[C_Ft_Ad,C_Ft_Rr] = deal(cell(1, s1)); % Ft = Frechet Discrete

for i3 = 1:s1
    
    [Ft_Ad,Ft_Rr, aa] = deal (zeros());
    
    for i4 = 1:n(i3)
        A = C_Avg_Ad {i3,1};% 1 is the baseline measurement
        B = C_Avg_Ad {i3, i4};
        C = C_Avg_Rr {i3,1};% 1 is the baseline measurement
        D = C_Avg_Rr {i3, i4};
        Ft_Ad (i4) = DiscreteFrechetDist(A,B);
%         Ft_Rr (i4) = DiscreteFrechetDist(C,D);
        %         aa (i4) = C_strAd {i3, i4};
    end
    
    C_Ft_Ad {i3} = Ft_Ad;
%     C_Ft_Rr {i3} = Ft_Rr;
    
    %     cc {i3} = aa; % or use directly form cell array
    hold off
    figure()
    b1= bar(Ft_Ad);
    %     set(b1, {'DisplayName'}, {}')
    %     legend()
    title('Ft-Ad')
    
%     figure()
%     b2 =bar(Ft_Rr);
%     %     set(b2, {'DisplayName'}, {'Jan','Feb','Mar'}')
%     %     legend()
%     title('Ft-Rr')
    
end

% Create an aarray of indication like S1S2 and relate it to the distances

