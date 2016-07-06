function [ erinf, delta_er, sigstat, tau ] = getDebyeFromProbeXLSX( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fileCont = xlsread(filename);

erinf = fileCont(1);
delta_er = fileCont(1,3);
sigstat = fileCont(2);
tau = fileCont(2,3);

end

