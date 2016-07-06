%% Test the debye extraction

f = 1e7:1e7:1e10;
filename = 'X:\Experiments\PropMeasurements\20160601_Triton_X-100_Mixtures\TritonX100\Triton X100.xlsx'; 

[er, sig] = debyeDataProbe(f, filename);


% Compare with Bryce's function:
[fProbe, probeDebyeEr, probeDebyeSig] = debyeDataProbe_Array(filename);
[ e_inf, e_s, sigma_i, tau_fit, error, exitflag ] = FitDebyeModel( fProbe ,probeDebyeEr, probeDebyeSig );

[erFit, sigFit] = debye(fProbe, e_s, e_inf, sigma_i, tau);

figure;
hold on;
plot(f, er)
plot(fProbe, probeDebyeEr,'r')
plot(fProbe, erFit,'g')
legend('From Debye params','From data','Refit');
