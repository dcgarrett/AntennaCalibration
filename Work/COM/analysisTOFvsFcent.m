% Seeing the estimated toa for different fcent and bw:
%clear all

% S_fileName = '50mm_Group1_NoWaveguide.cit';
% S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\GRL_Analysis';
% measLength = 50e-3;
% simOrMeas = 1;

S_fileName = 'Glycerin_50mm.cti';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\Measured_GRL_Results\05Aug2015';
measLength = 30e-3;
simOrMeas = 0;


fcent_all = 3e9:1e9:8e9;

for i = 1:length(fcent_all)
    [f, epsEst(i,:), sigEst(i,:), ~, ~, ~, ~, toa(i)] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5,'fcent',fcent_all(i),'bw',0.5e9);
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
legend(strcat('fcent  ', strsplit(num2str(fcent_all./1e9)), ' GHz'))
xlabel('Frequency (Hz)')
ylabel('Estimated eps')
title('Assessing the effect of fcent')
xlim([3e9 8e9])

% figure;
% hold on;
% plot(fcent_all, toa)
% xlabel('Center frequency (Hz)')
% ylabel('Estimated time of flight')

vp = measLength ./ toa; % v = d/t;
b_toa = 2*pi.*fcent_all ./ vp;

% find line of best fit
maxFitInd = find(fcent_all > 5e9);
maxFitInd = maxFitInd(1);
p = polyfit(fcent_all(1:maxFitInd), b_toa(1:maxFitInd),1);
lobf = polyval(p, 0:1e8:10e9);

figure;
hold on;
plot(fcent_all, b_toa)
plot(0:1e8:10e9, lobf,'r')
xlabel('Center frequency (Hz)')
ylabel('Estimated beta from TOF')
xlim([0 10e9])
ylim([0 max(lobf)])

%% Same thing for bw now:
clear all

%S_fileName = 'Canola_50mm.cti';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\Measured_GRL_Results\05Aug2015';
measLength = 50e-3;
simOrMeas = 0;


bw_all = [0.5e9, 3e9]; %0.2e9:0.4e9:4e9;
fcent = 5e9;

for i = 1:length(bw_all)
    [f, epsEst(i,:), sigEst(i,:), ~, ~, ~, ~, toa(i)] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5,'fcent',fcent,'bw',bw_all(i));
end

figEps = figure;
col = hsv(length(bw_all));
hold on;
plot(f, epsEst)
grid on;
hold off;
colormap(col);
c = colorbar;
c.Label.String = 'BW';
legend(strcat('BW  ', strsplit(num2str(bw_all./1e9)), ' GHz'))
xlabel('Frequency (Hz)')
ylabel('Estimated eps')
title('Assessing the effect of bw')
xlim([3e9 8e9])

% figure;
% hold on;
% plot(fcent_all, toa)
% xlabel('Center frequency (Hz)')
% ylabel('Estimated time of flight')

vp = measLength ./ toa; % v = d/t;
b_toa = 2*pi.*bw_all ./ vp;

figure;
hold on;
plot(bw_all, b_toa)
xlabel('BW (Hz)')
ylabel('Estimated beta from TOF')
xlim([0 10e9])