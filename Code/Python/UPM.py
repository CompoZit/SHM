# Data analysis of UPM tests
"""
Created on May 6 2019
@author: Tasdeeq Sofi
Data analysis written for the tests carried at UPM
"""
#Import different modules
import numpy as np
import pandas
#import scipy as sp
import scipy.io 
import matplotlib.pyplot as plt
import os # Directory maniplulater module 
import tkinter# ????
import tkinter.filedialog

#Preapre workspace      


#Load working directory
main_dir = tkinter.filedialog.askdirectory()
files = os.listdir(main_dir)
folders=[] # Initailize
nb_folders = 0 # find the number of folders
for f in files:
    filepath = os.path.join(main_dir, f)
    if os.path.isdir(filepath):
     nb_folders = nb_folders +1
     folders.append(f)

# Define parameters and Initialize
#legend_Var = zeros();
lgd1 = ['Free', 'S1', 'S2', 'S3', 'S4-Hammer', 'S4', 'S5-Hammer','S5']# check, python maybe loading the files in a different order
lgd2= ['Blutack','Hammer','Pristine']

# Load and plot all working files
for i in range (len(folders)):
    folder_name = folders[i]
    folderpath = os.path.join(main_dir,folder_name )
    work_files = os.listdir(folderpath)
    
    for i1 in range(len(work_files)):
        [filename, file_ext] = os.path.splitext(work_files[i1])
        filepath = os.path.join(folderpath,work_files[i1])
        if file_ext == '.csv':
            data = pandas.read_csv(filepath)
            Fr = data.iloc[:,0] # Frequency 
            data2 = data.iloc[:,1] # Capacitance and Impdance modulus
            data3 = data.iloc[:,2] # Resistance and angle of impedance vector          
        
        if folder_name == '01_Capacitance':
            fig1 = plt.figure(1)
#            fig, axs= plt.subplots(4,2)
#            fig.subplots_adjust(hspace = .5, wspace=.001)
#            axs[i1].plot(Fr, data2)
            Cp = data2
            plt.plot(Fr, Cp)
            plt.xlabel ('Frequency [Hz]')
            plt.ylabel ('Capacitance [Farad]')
            plt.legend (lgd1)
        
        if folder_name == '02_Impedance':
            phi=((np.math.pi)/180)*data3 #Convert into radians
            ZR = data2*np.cos(phi) # Real Impedance
            ZI = data2*np.sin(phi)# Imaginary Impedance
            AI = abs(1./ZI) # Imaginary Admittance
            fig2 = plt.figure(2)
            plt.plot(Fr, ZR)
            plt.xlabel ('Frequency [Hz]')
            plt.ylabel ('Impedance [Ohm]')
            plt.legend (lgd1)
            fig3 = plt.figure(3)
            plt.plot(Fr, AI)
            plt.xlabel ('Frequency [Hz]')
            plt.ylabel ('Admittance [Seimens]')
            plt.legend (lgd1)
            
        if folder_name == '03_GuidedWave':
            mat = scipy.io.loadmat(filepath)
            Ac_signal = mat['A']
            Rv_signal = mat['B']
            fig4 = plt.figure(4)
            plt.plot(Ac_signal)
            plt.xlabel ('Time [S]')
            plt.ylabel ('Amplitude [v]')
            plt.legend (lgd2)
            fig5 = plt.figure(5)
            plt.plot(Rv_signal)
            plt.xlabel ('Time [S]')
            plt.ylabel ('Amplitude [v]')
            plt.legend (lgd2)
            
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    

        