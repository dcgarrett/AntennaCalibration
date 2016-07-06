% GRL Error source 3: Phase unwrapping
%   Effect of fcent and bw on property estimation
clear all;

S_fileName = '50mm_Group1_NoWaveguide.cit';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\GRL_Analysis';
measLength = 50e-3;
simOrMeas = 1;

%[f, epsEst, sigEst, ~, ~, O, P] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5);

fcent_all = 3e9:1e9:8e9;

for i = 1:length(fcent_all)
    [f, epsEst(i,:), sigEst(i,:), ~, ~, ~, ~] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5,'fcent',fcent_all(i));
end

figEps = figure;
col = hsv(length(fcent_all));
hold on;
plot(f, epsEst)
grid on;
hold off;
colormap(col);
c = colorbar;
c.Label.String = 'Center frequency';
xlabel('Frequency (Hz)')
ylabel('Estimated eps')
title('Assessing the effect of fcent')
xlim([3e9 8e9])

clear epsEst sigEst

bw_all = 0.02e9:0.02e9:1e9;

for i = 1:length(bw_all)
    [f, epsEst(i,:), sigEst(i,:), ~, ~, ~, ~] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5,'bw',bw_all(i));
end

figEps = figure;
col = hsv(length(bw_all));
hold on;
plot(f, epsEst)
grid on;
hold off;
colormap(col);
c = colorbar;
c.Label.String = 'Bandwidth for TOF';
xlabel('Frequency (Hz)')
ylabel('Estimated eps')
title('Assessing the effect of BW')
xlim([3e9 8e9])


