function [R,m,Pev]=Leastsq_Regression(x,y)

% Linear regression function
% Checks and fits a linear curve between two data sets

p = polyfit(x,y,1);
m = p(1); % slope of line fitted line (y = mx + c)
% c = p(2); % constant of the fitted line (y = mx + c)

% Polynomial evaluation
Pev = polyval(p,x);

% Correlation coefficients
R=corrcoef(x,y);
R=R(1,2);


end