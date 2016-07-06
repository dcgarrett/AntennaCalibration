

fcent = 5e9;


%Measured
fileName = 'DistWater_40mm.cti';
filePath = 'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\05Aug2015';
measLength = 40e-3;
simOrMeas = 0;
[f_sim, epsEst, sigEst, ~, S_cal, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',1,'DP_plot',1,'fcent',fcent);


%% Simulated
fcent = 2.6e9; 
fileName = 'er30sig1_50mm.mat';
filePath = 'C:\Users\dgarrett\Google Drive\Work\Simulations\Data';
measLength = 50e-3;
simOrMeas = 1;
[f_sim, epsEst, sigEst, ~, S_cal, O_sim, P_sim, ~, aEst, bEst] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',1,'DP_plot',1,'fcent',fcent);

%%
figure;
plot(f_sim, aEst)
xlabel('Frequency (Hz)')
ylabel('Attenuation constant [Np/m]')
xlim([3e9 8e9])
grid on;
box on;

figure;
plot(f_sim, angle(squeeze(S_cal(2,1,:))))
xlabel('Frequency (Hz)')
ylabel('Transmission phase [rad]')
xlim([3e9 8e9])
grid on;
box on;


beta1 = -unwrap(angle(squeeze(S_cal(2,1,:)))) ./ measLength;

[erTrue, sigTrue] = material_database(f, 'er30dispersive','Debye');
[alphaTrue, betaTrue] = getAlphaBeta(f, erTrue, sigTrue);

figure;
hold on;
plot(f, beta1)
plot(f, betaTrue)
xlabel('Frequency (Hz)')
ylabel('Phase constant [rad/m]')
legend('Uncorrected phase constant','True phase constant')
xlim([3e9 8e9])
grid on;
box on;

figure;
hold on;
plot(f, bEst)
plot(f, betaTrue)
xlabel('Frequency (Hz)')
ylabel('Phase constant [rad/m]')
legend('Corrected phase constant','True phase constant')
xlim([3e9 8e9])
grid on;
box on;


figure;
hold on;
plot(f, epsEst)
plot(f, erTrue,'r')
legend('Estimated','True')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity')
xlim([3e9 8e9])
grid on;
box on;

figure;
hold on;
plot(f, sigEst)
plot(f, sigTrue,'r')
legend('Estimated','True')
xlabel('Frequency (Hz)')
ylabel('Conductivity')
xlim([3e9 8e9])
grid on;
box on;