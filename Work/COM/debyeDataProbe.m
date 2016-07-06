function [ er, sig ] = debyeDataProbe( f, fileName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[ erinf, delta_er, sigstat, tau ] = getDebyeFromProbeXLSX( fileName );

erstat = erinf+delta_er;

[er,sig] = debye(f,erstat,erinf,sigstat,tau.*1e-9);

end

