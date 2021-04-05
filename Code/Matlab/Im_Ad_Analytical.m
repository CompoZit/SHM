%% Progrma description
% Author: Tasdeeq SOFI, Feb 2021
% Description: Impedance curve for a free (unbonded) and bonded sensor
% ENHAnCE project


%% Prepare workspace 
clear;
clc;  
close all; 
warning off;


%% Impedance analaysis for a free sensor, sesnor dimensions and sesnor properties
% Values taken form Daniel Schmidt's thesis and DuraAct datasheet
dlt = 20e-3; % dielectric loss tangent (No unit)
dc = 1750;% dielectric constant (relative permittivity)
ym = 48.3e9;% PZT youngs modulus (N/m2)
cp =-(180e-12) ;% Check the value, PZT coupling constant (m/V)
omega = (0:100:200e3); % Frequency Hz
len = 16e-3; % [m]length of the piezoceramic material not the whole sensor 
b = 13e-3; % m
area = len*b;
t = 0.2e-3;% m
j = sqrt(-1);
I_free = (omega.*j)*((area)/t)*(dc*(1-(j*dlt)));
I_bonded = I_free - ((omega.*j)*((area)/t)*(cp*ym));

% Imaginary part of the admittance
I_free = imag (I_free);
I_bonded  = imag (I_bonded);
I_diff = I_bonded-I_free;


%% Plot of the admittance curve for a free sesnor and a bonded sensor
figure (1)
plot (omega,I_free, 'r');
% figure (2)
hold on 
plot (omega,I_bonded, 'b');
xlabel('Frequnecy [Hz]')
ylabel('Admitatnce (Imaginary part)')
title('Free vs bonded sensor')
legend ('Free sensor','Bonded sensor')
% hold off;
% figure(2)
% plot (omega,I_diff,'b');






