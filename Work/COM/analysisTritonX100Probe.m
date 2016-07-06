%% Compare Triton X-100 mixtures with Group 1, 2, 3
f = 10e6:10e6:10e9;

%% 100% Triton X - Group 3
filename = 'X:\Experiments\PropMeasurements\20160601_Triton_X-100_Mixtures\TritonX100\Triton X100.xlsx'; 
[fProbe, probeDebyeEr, probeDebyeSig] = debyeDataProbe_Array(filename);
[fProbe, probeEr, probeSig] = DataProbe_Array(filename);
[ e_inf, e_s, sigma_i, tau_fit, error, exitflag ] = FitDebyeModel( fProbe ,probeDebyeEr, probeDebyeSig );
[erFit100pc, sigFit100pc] = debye(f, e_s, e_inf, sigma_i, tau_fit);

[erGroup3, condGroup3] = material_database(fProbe, 'Group 3','Cole-Cole');

figure;
hold on;
plot(f, erFit100pc)
plot(fProbe, probeEr, 'g')
plot(fProbe, erGroup3,'r')
legend('100% Triton X100 Probe Debye','100% Triton X100 Probe Raw','Group 3')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity')
xlim([0 8e9])
box on;
grid on;

figure;
hold on;
plot(f, sigFit100pc)
plot(fProbe, probeSig, 'g')
plot(fProbe, condGroup3,'r')
legend('100% Triton X100 Probe Debye','100% Triton X100 Probe Raw','Group 3')
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
xlim([0 8e9])
box on;
grid on;

%% 40% Triton X, 0.5% Salt - Group 2
filename = 'X:\Experiments\PropMeasurements\20160601_Triton_X-100_Mixtures\TritonX10040%\Triton X100 40%.xlsx'; 
[fProbe, probeDebyeEr, probeDebyeSig] = debyeDataProbe_Array(filename);
[fProbe, probeEr, probeSig] = DataProbe_Array(filename);
[ e_inf, e_s, sigma_i, tau_fit, error, exitflag ] = FitDebyeModel( fProbe ,probeDebyeEr, probeDebyeSig );
[erFit40pc, sigFit40pc] = debye(f, e_s, e_inf, sigma_i, tau_fit);

[erGroup2, condGroup2] = material_database(fProbe, 'Group 2','Cole-Cole');

figure;
hold on;
plot(f, erFit40pc)
plot(fProbe, probeEr, 'g')
plot(fProbe, erGroup2,'r')
legend('40% Triton X100 Probe Debye','40% Triton X100 Probe Raw','Group 2')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity')
xlim([0 8e9])
box on;
grid on;

figure;
hold on;
plot(f, sigFit40pc)
plot(fProbe, probeSig, 'g')
plot(fProbe, condGroup2,'r')
legend('40% Triton X100 Probe Debye','40% Triton X100 Probe Raw','Group 2')
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
xlim([0 8e9])
box on;
grid on;

%% 30% Triton X, 0.5% Salt - Group 1
filename = 'X:\Experiments\PropMeasurements\20160601_Triton_X-100_Mixtures\TritonX10030%\Triton X100 30%.xlsx'; 
[fProbe, probeDebyeEr, probeDebyeSig] = debyeDataProbe_Array(filename);
[fProbe, probeEr, probeSig] = DataProbe_Array(filename);
[ e_inf, e_s, sigma_i, tau_fit, error, exitflag ] = FitDebyeModel( fProbe ,probeDebyeEr, probeDebyeSig );
[erFit30pc, sigFit30pc] = debye(f, e_s, e_inf, sigma_i, tau_fit);

[erGroup1, condGroup1] = material_database(fProbe, 'Group 1','Cole-Cole');

figure;
hold on;
plot(f, erFit30pc)
plot(fProbe, probeEr, 'g')
plot(fProbe, erGroup1,'r')
legend('30% Triton X100 Probe Debye','30% Triton X100 Probe Raw','Group 1')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity')
xlim([0 8e9])
box on;
grid on;

figure;
hold on;
plot(f, sigFit30pc)
plot(fProbe, probeSig, 'g')
plot(fProbe, condGroup1,'r')
legend('30% Triton X100 Probe Debye','30% Triton X100 Probe Raw','Group 1')
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
xlim([0 8e9])
box on;
grid on;

%% Plot debye of all three

figure;
hold on;
plot(f, erFit100pc)
plot(f, erFit40pc,'r')
plot(f, erFit30pc,'g')
legend('100% Triton X-100','40% Triton X-100','30% Triton X-100')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity []')
xlim([0 8e9])
box on;
grid on;

figure;
hold on;
plot(f, sigFit100pc)
plot(f, sigFit40pc,'r')
plot(f, sigFit30pc,'g')
legend('100% Triton X-100','40% Triton X-100','30% Triton X-100')
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
xlim([0 8e9])
box on;
grid on;
