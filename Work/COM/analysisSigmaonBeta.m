fcent = 4e9;
fileName = 'er30sig0_50mm.mat'; 
%fileName = 'er30dispersive_50mm.mat'; 
%fileName = 'TritonX100_30pc_50mm_14GHzBW.mat';
%fileName = 'Thru.mat';
filePath = 'C:\Users\dgarrett\Google Drive\Work\Simulations\Data';
measLength = 50e-3;
simOrMeas = 1;
[f_sim, epsEst, sigEst, ~, S_cal, O_sim, P_sim, ~, aEst, bEst] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',1,'fcent',fcent);


er(1:length(f_sim)) = 30;
sig(1:length(f_sim)) = 0;
[ alphaTrue, betaTrue ] = getAlphaBeta( f_sim, er.', sig.' );

figure;
hold on;
plot(f_sim, aEst)
plot(f_sim, alphaTrue,'r')
xlabel('Frequency')
ylabel('Alpha')
title(fileName)

figure;
hold on;
plot(f_sim, bEst)
plot(f_sim, betaTrue,'r')
xlabel('Frequency')
ylabel('Beta')
title(fileName)

figure;
hold on;
plot(f_sim(1:end-1), diff(bEst))
plot(f_sim(1:end-1), diff(betaTrue),'r')
ylabel('Differentiate B')