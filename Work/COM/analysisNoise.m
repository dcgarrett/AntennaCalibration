%% GRL Error source 2: Noise

clear all;

% Performs GRL Calibration with varying levels of noise to track changes in
% O and P

S_fileName = '50mm_Group1_NoWaveguide.cit';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\GRL_Analysis';
measLength = 50e-3;
simOrMeas = 1;

[f, epsEst_noNoise, sigEst_noNoise, ~, ~, O_noNoise, P_noNoise] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0);

ind3to8GHz = find(f > 3e9 & f < 8e9);

snr = 1:5:100;
for i = 1:length(snr)
    [~, epsEst_Noise(i,:), sigEst_Noise(i,:), ~, ~, O_Noise(i,:,:,:), P_Noise(i,:,:,:)] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'addNoise', 1, 'snr', snr(i));
    epsError(i,:) = (epsEst_Noise(i,ind3to8GHz) - epsEst_noNoise(ind3to8GHz)) / epsEst_noNoise(ind3to8GHz);
    avgEpsError(i) = mean(epsError(i,:));
    sigError(i,:) = (sigEst_Noise(i,ind3to8GHz) - sigEst_noNoise(ind3to8GHz)) / sigEst_noNoise(ind3to8GHz);
end
   
figure;
hold on;
plot(snr, avgEpsError.*100)
xlabel('Simulated SNR (dB)')
ylabel('Permittivity estimation error (%)')
ylim([-100 100])
grid on;
box on;

figEps = figure;
col = hsv(length(snr));
hold on;
plot(f, epsEst_Noise)
plot(f, epsEst_noNoise, 'rx')
grid on;
hold off;
colormap(col);
c = colorbar;
c.Label.String = 'SNR (dB)';
xlabel('Frequency (Hz)')
ylabel('Estimated eps')
title('Assessing the effect of noise')

figure;
hold on;
col2 = hsv(length(snr(1:2:end)));
plot(f, epsEst_Noise(1:2:end,:))
grid on;
box on;
colormap(col2);
legend(strcat('SNR  ', strsplit(num2str(snr(1:2:end))), ' dB'))
xlabel('Frequency (Hz)')
ylabel('Estimated eps')
title('Assessing the effect of noise')
xlim([3e9 8e9])
ylim([0 60])


% figure;
% hold on;
% plot(f, mag2db(abs(squeeze(O_noNoise(1,1,:)))))
% plot(f, mag2db(abs(squeeze(O_Noise(1,1,:)))),'r')
% xlabel('Frequency (Hz)')
% ylabel('O11 (dB)')
% grid on;
% box on;
% legend('No noise','Noise')
% 
% figure;
% hold on;
% plot(f, mag2db(abs(squeeze(O_noNoise(1,1,:)))))
% plot(f, mag2db(abs(squeeze(O_Noise(1,1,:)))),'r')
% xlabel('Frequency (Hz)')
% ylabel('O11 (dB)')
% grid on;
% box on;
% legend('No noise','Noise')
% 
% figure;
% hold on;
% plot(f, mag2db(abs(squeeze(O_noNoise(1,2,:)))))
% plot(f, mag2db(abs(squeeze(O_Noise(1,2,:)))),'r')
% xlabel('Frequency (Hz)')
% ylabel('O12 (dB)')
% grid on;
% box on;
% legend('No noise','Noise')
% 
% figure;
% hold on;
% plot(f, mag2db(abs(squeeze(O_noNoise(2,1,:)))))
% plot(f, mag2db(abs(squeeze(O_Noise(2,1,:)))),'r')
% xlabel('Frequency (Hz)')
% ylabel('O21 (dB)')
% grid on;
% box on;
% legend('No noise','Noise')
% 
% figure;
% hold on;
% plot(f, mag2db(abs(squeeze(O_noNoise(2,2,:)))))
% plot(f, mag2db(abs(squeeze(O_Noise(2,2,:)))),'r')
% xlabel('Frequency (Hz)')
% ylabel('O22 (dB)')
% grid on;
% box on;
% legend('No noise','Noise')


%% Try with measured data

S_fileName = 'DistWater_50mm.cti';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\Measured_GRL_Results\05Aug2015';
measLength = 50e-3;
simOrMeas = 0;

[f, epsEst_noNoise, sigEst_noNoise, S_meas, S_cal, O_noNoise, P_noNoise] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5);
