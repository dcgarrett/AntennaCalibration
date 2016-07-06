%% analaysis, Nahanni Triton X100

% RUN ANALYSISTRITONX100PROBE FIRST!
fcent_sim = 2.6e9;
fcent_meas = 2.6e9;
measLengthMM = 50;
measLength = measLengthMM*1e-3;

%% 100% Triton X100
fileName = strcat('Triton_100pc_',num2str(measLengthMM),'mm.cti');
filePath = 'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160601_TritonX100';
simOrMeas = 0;

[f, epsEst100pc, sigEst100pc, ~, S_cal_100pc_meas, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent_meas);
errorInd = find(f>= 3e9 & f <= 5.5e9);

% Simulated
fileName = strcat('TritonX100_100pc_',num2str(measLengthMM),'mm_14GHzBW.mat');
filePath = 'C:\Users\dgarrett\Google Drive\Work\Simulations\Data';
simOrMeas = 1;
[f_sim, epsEst100pc_sim, sigEst100pc_sim, ~, S_cal_100pc_sim, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent_sim);

[t, t_100pc_meas] = invczt_auto(f, S_cal_100pc_meas, 1, 2);
[~, t_100pc_sim] = invczt_auto(f, S_cal_100pc_sim, 1, 2);

errorEps100pc_meas = mean(abs((epsEst100pc(errorInd) - erFit100pc(errorInd).')./erFit100pc(errorInd).'));
errorEps100pc_sim = mean(abs((epsEst100pc_sim(errorInd) - erFit100pc(errorInd).')./erFit100pc(errorInd).'));

errorSig100pc_meas = mean(abs(sigEst100pc - sigFit100pc.'));
errorSig100pc_sim = mean(abs(sigEst100pc_sim - sigFit100pc.'));

figure;
hold on;
plot(t, t_100pc_meas)
plot(t, t_100pc_sim, 'r')
xlabel('Time (s)')
ylabel('Magnitude')
grid on;
box on;

figure;
hold on;
plot(f, epsEst100pc)
plot(f_sim, epsEst100pc_sim,'Color',[0 0.5 0])
plot(f, erFit100pc,'r')
xlabel('Frequency (Hz)')
title('100% Triton X-100')
ylabel('Relative permittivity')
%legend(strcat('Nahanni, error ', num2str(errorEps100pc_meas)),'Probe Debye',strcat('Nahanni Sim, error ', num2str(errorEps100pc_sim)))
legend('Antenna measurement','Antenna simulation','Reference')
xlim([3e9 8e9])
ylim([1 6])
grid on;
box on;

figure;
hold on;
plot(f, sigEst100pc)
plot(f_sim, sigEst100pc_sim,'Color',[0 0.5 0])
plot(f, sigFit100pc,'r')
xlabel('Frequency (Hz)')
title('100% Triton X-100')
ylabel('Conductivity [S/m]')
%legend('Nahanni','Probe Debye','Nahanni Sim')
legend('Antenna measurement','Antenna simulation','Reference')
xlim([3e9 8e9])
ylim([0 0.8])
grid on;
box on;

%% 40% Triton X100
fileName = strcat('Triton_40pc_',num2str(measLengthMM),'mm.cti');
filePath = 'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160601_TritonX100';
simOrMeas = 0;

[~, epsEst40pc, sigEst40pc, ~, S_cal_40pc_meas, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent_meas);
fNoiseInd = find(f < 7e9);


% Simulated
fileName = strcat('TritonX100_40pc_',num2str(measLengthMM),'mm_14GHzBW.mat');
filePath = 'C:\Users\dgarrett\Google Drive\Work\Simulations\Data';
simOrMeas = 1;
[f_sim, epsEst40pc_sim, sigEst40pc_sim, ~, S_cal_40pc_sim, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent_sim);


[t, t_40pc_meas] = invczt_auto(f, S_cal_40pc_meas, 1, 2);
[~, t_40pc_sim] = invczt_auto(f, S_cal_40pc_sim, 1, 2);

errorEps40pc_meas = mean(abs((epsEst40pc(errorInd) - erFit40pc(errorInd).')./erFit40pc(errorInd).'));
errorEps40pc_sim = mean(abs((epsEst40pc_sim(errorInd) - erFit40pc(errorInd).')./erFit40pc(errorInd).'));

errorSig40pc_meas = mean(abs(sigEst40pc - sigFit40pc.'));
errorSig40pc_sim = mean(abs(sigEst40pc_sim - sigFit40pc.'));

figure;
hold on;
plot(t, t_40pc_meas)
plot(t, t_40pc_sim, 'r')
xlabel('Time (s)')
ylabel('Magnitude')
grid on;
box on;

figure;
hold on;
plot(f(fNoiseInd), epsEst40pc(fNoiseInd))
plot(f_sim, epsEst40pc_sim,'Color',[0 0.5 0])
plot(f, erFit40pc,'r')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity')
title('40% Triton X-100')
%legend(strcat('Nahanni, error ', num2str(errorEps40pc_meas)),'Probe Debye',strcat('Nahanni Sim, error ', num2str(errorEps40pc_sim)))
legend('Antenna measurement','Antenna simulation','Reference')
xlim([3e9 8e9])
ylim([15 40])
grid on;
box on;

figure;
hold on;
plot(f(fNoiseInd), sigEst40pc(fNoiseInd))
plot(f_sim, sigEst40pc_sim,'Color',[0 0.5 0])
plot(f, sigFit40pc,'r')
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
title('40% Triton X-100')
%legend('Nahanni','Probe Debye','Nahanni Sim')
legend('Antenna measurement','Antenna simulation','Reference')
xlim([3e9 8e9])
ylim([0 8])
grid on;
box on;

%% 30% Triton X100
fileName = strcat('Triton_30pc_',num2str(measLengthMM),'mm.cti');
filePath = 'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160601_TritonX100';
simOrMeas = 0;

[~, epsEst30pc, sigEst30pc, ~, S_cal_30pc_meas, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent_meas);

% Simulated
fileName = strcat('TritonX100_30pc_',num2str(measLengthMM),'mm_14GHzBW.mat');
filePath = 'C:\Users\dgarrett\Google Drive\Work\Simulations\Data';
simOrMeas = 1;
[f_sim, epsEst30pc_sim, sigEst30pc_sim, ~, S_cal_30pc_sim, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent_sim);

[t, t_30pc_meas] = invczt_auto(f, S_cal_30pc_meas, 1, 2);
[~, t_30pc_sim] = invczt_auto(f_sim, S_cal_30pc_sim, 1, 2);

errorEps30pc_meas = mean(abs((epsEst30pc(errorInd) - erFit30pc(errorInd).')./erFit30pc(errorInd).'));
errorEps30pc_sim = mean(abs((epsEst30pc_sim(errorInd) - erFit30pc(errorInd).')./erFit30pc(errorInd).'));

errorSig30pc_meas = mean(abs(sigEst30pc - sigFit30pc.'));
errorSig30pc_sim = mean(abs(sigEst30pc_sim - sigFit30pc.'));

figure;
hold on;
plot(t, t_30pc_meas)
plot(t, t_30pc_sim, 'r')
xlabel('Time (s)')
ylabel('Magnitude')

figure;
hold on;
plot(f(fNoiseInd), epsEst30pc(fNoiseInd))
plot(f_sim, epsEst30pc_sim,'Color',[0 0.5 0])
plot(f, erFit30pc,'r')
xlabel('Frequency (Hz)')
ylabel('Relative permittivity')
title('30% Triton X-100')
%legend(strcat('Nahanni, error ', num2str(errorEps30pc_meas)),'Probe Debye',strcat('Nahanni Sim, error ', num2str(errorEps30pc_sim)))
legend('Antenna measurement','Antenna simulation','Reference')
xlim([3e9 8e9])
ylim([20 50])
grid on;
box on;

figure;
hold on;
plot(f(fNoiseInd), sigEst30pc(fNoiseInd))
plot(f_sim, sigEst30pc_sim,'Color',[0 0.5 0])
plot(f, sigFit30pc,'r')
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
title('30% Triton X-100')
%legend('Nahanni','Probe Debye','Nahanni Sim')
legend('Antenna measurement','Antenna simulation','Reference')
xlim([3e9 8e9])
grid on;
box on;

%% Optional plotting

figure;
hold on;
plot(f, mag2db(abs(squeeze(S_cal_40pc_meas(1,2,:)))));
plot(f, mag2db(abs(squeeze(S_cal_40pc_sim(1,2,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('S21 cal magnitude')
title('40pc 50 mm')
legend('Measured','Simulated')

figure;
hold on;
plot(f, phase((squeeze(S_cal_40pc_meas(1,2,:)))));
plot(f, phase((squeeze(S_cal_40pc_sim(1,2,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('S21 cal angle')
title('40pc 50 mm')
legend('Measured','Simulated')