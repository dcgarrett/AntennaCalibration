%% Apply NRW to DP estimation

S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Constraints\Data\Liquids\PML';
S_fileName = 'Water_PML3.mat';
%S_fileName = 'Thru.cit';
[f, epsEst, sigEst, S_meas, S_cal, O, P, toa] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, 1, 'source','1x1');

S11 = squeeze(S_cal(1,1,:));
S12 = squeeze(S_cal(1,2,:));
S21 = squeeze(S_cal(2,1,:));
S22 = squeeze(S_cal(2,2,:));

figure;
hold on;
plot(f, mag2db(abs(S11)))
plot(f, mag2db(abs(S22)),'r')


figure;
hold on;
plot(f, mag2db(abs(S12)))
plot(f, mag2db(abs(S21)),'r')