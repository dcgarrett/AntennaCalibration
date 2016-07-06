%% Compare before and after:
fcent = 2.6e9;

% Before:
% fileName_bef = 'Sasha_before_hand_24p86mm.cti';
%fileName_bef = 'Sasha_before_forearm_30p21mm.cti';
%fileName_bef = 'Claire_before_forearm_35p83mm.cti';
fileName_bef = 'Claire_before_hand_28p92mm.cti';
filePath = 'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160704_HydrationTestRunning';%'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160601_TritonX100';
measLength = getLengthFromFileName(fileName_bef);
simOrMeas = 0;
[f, epsEst_before, sigEst_before, ~, S_cal_before, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName_bef, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent);


% After:
% fileName_aft = 'Sasha_after_hand_25p50mm.cti';
%fileName_aft = 'Sasha_after_forearm_27p73mm.cti';
%fileName_aft = 'Claire_after_forearm_32p21mm.cti';
fileName_aft = 'Claire_after_hand_26p81mm.cti';
filePath = 'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160704_HydrationTestRunning';%'C:\Users\dgarrett\Google Drive\Work\Nahanni_Data\20160601_TritonX100';
measLength = getLengthFromFileName(fileName_aft);
simOrMeas = 0;
[~, epsEst_after, sigEst_after, ~, S_cal_after, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName_aft, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent);


fileName_bef = strrep(fileName_bef, '_', ' ');
fileName_aft = strrep(fileName_aft, '_', ' ');

fileName_bef = strrep(fileName_bef, 'Sasha','Subject 1');
fileName_aft = strrep(fileName_aft, 'Sasha','Subject 1');

fileName_bef = strrep(fileName_bef, 'Claire','Subject 2');
fileName_aft = strrep(fileName_aft, 'Claire','Subject 2');


figure;
hold on;
plot(f, epsEst_before)
plot(f, epsEst_after,'r')
xlabel('Frequency (Hz)')
ylabel('Permittivity')
xlim([3e9 8e9])
legend(fileName_bef,fileName_aft)
box on;
grid on;

figure;
hold on;
plot(f, sigEst_before)
plot(f, sigEst_after,'r')
xlabel('Frequency (Hz)')
ylabel('Conductivity')
xlim([3e9 8e9])
legend(fileName_bef,fileName_aft)
box on;
grid on;

figure;
hold on;
plot(f, mag2db(abs(squeeze(S_cal_before(2,1,:)))))
plot(f, mag2db(abs(squeeze(S_cal_after(2,1,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('S21 mag')
xlim([3e9 8e9])
legend(fileName_bef,fileName_aft)
box on;
grid on;