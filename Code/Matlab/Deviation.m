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

[C_Fr_dt,C_Hd_dt] = deal(cell(1, s1)); % Hd_dt = Frechet Discrete,  Fr_dt = Hausdroff distance

for i3 = 1:s1
    
    [Fr_dt, Hd_dt,aa] = deal (zeros());
    
    for i4 = 1:n(i3)
        A = C_Avg_Ad {i3,1};% 1 is the baseline measurement
        B = C_Avg_Ad {i3, i4};
        Fr_dt (i4) = DiscreteFrechetDist(A,B);
        Hd_dt (i4) = Hausdorff(A, B);
        %         aa (i4) = C_strAd {i3, i4};
    end
    
    C_Fr_dt {i3} = Fr_dt;
    C_Hd_dt {i3} = Hd_dt;
    
    %     cc {i3} = aa; % or use directly form cell array
    hold off
    figure()
    bar(Fr_dt)
    figure()
    bar(Hd_dt)
    
end

% Create an aarray of indication like S1S2 and relate it to the distances

