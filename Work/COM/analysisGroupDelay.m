%% Analysis group delay

S_fileName = 'Canola_PML.mat';%'Water_PML.mat';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Constraints\Data\Liquids\PML';
measLength = 50e-3;
simOrMeas = 1;

[f, epsEst, sigEst, S_meas, S_cal, O, P, toa] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, 1, 'source','1x1');

tg = getGroupDelay(f, squeeze(S_cal(2,1,:)));

figure;
hold on;
plot(f(1:end-1), tg)

c = 3e8;
epsTg = (c.*tg./measLength).^2;

figure;
hold on;
plot(f(1:end-1), epsTg)