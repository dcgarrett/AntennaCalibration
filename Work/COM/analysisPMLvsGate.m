%% GRL Error source 1: PML vs time gating for O11 P22

% Obtains O and P correction matrices for the two possible methods of
% obtaining O11 and P22 in simulation

%S_fileName = 'Water_PML3.mat';
% S_fileName = 'Glycerin_PML.mat';
S_fileName = 'Muscle.mat';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Constraints\Data\Liquids\PML';
measLength = 50e-3;
simOrMeas = 1;

[f, epsGate, sigGate, ~, ~, O_gate, P_gate] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5);
[~, epsPML, sigPML, ~, ~, O_PML, P_PML] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 1);

figure;
hold on;
plot(f, mag2db(abs(squeeze(O_gate(1,1,:)))))
plot(f, mag2db(abs(squeeze(O_PML(1,1,:)))),'r--')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
grid on;
box on;
legend('O11 from two meas','O11 from PML')

figure;
hold on;
plot(f, mag2db(abs(squeeze(O_gate(1,2,:)))))
plot(f, mag2db(abs(squeeze(O_PML(1,2,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('O12 (dB)')
grid on;
box on;
legend('Gate','PML')

figure;
hold on;
plot(f, mag2db(abs(squeeze(O_gate(2,1,:)))))
plot(f, mag2db(abs(squeeze(O_PML(2,1,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('O21 (dB)')
grid on;
box on;
legend('Gate','PML')

figure;
hold on;
plot(f, mag2db(abs(squeeze(O_gate(2,2,:)))))
plot(f, mag2db(abs(squeeze(O_PML(2,2,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('O22 (dB)')
grid on;
box on;
legend('Gate','PML')

figure;
hold on;
plot(f, epsGate)
plot(f, epsPML,'r')
xlabel('Frequency (Hz)')
ylabel('Eps est')
grid on;
box on;
legend('Gate','PML')

figure;
hold on;
plot(f, sigGate)
plot(f, sigPML,'r')
xlabel('Frequency (Hz)')
ylabel('Sig est')
grid on;
box on;
legend('Gate','PML')

%% Try for the test liquids presented earlier



%% Analyze error

errorPMLvsGate = (O_gate - O_PML) ./ O_PML;

figure;
plot(f, 100.*(abs(squeeze(errorPMLvsGate(1,1,:)))))
xlabel('Frequency (Hz)')
ylabel('O11 Error (%)')
xlim([3e9 8e9])

figure;
plot(f, 100.*(abs(squeeze(errorPMLvsGate(1,2,:)))))
xlabel('Frequency (Hz)')
ylabel('O12 Error (%)')
xlim([3e9 8e9])

figure;
plot(f, 100.*(abs(squeeze(errorPMLvsGate(2,2,:)))))
xlabel('Frequency (Hz)')
ylabel('O22 Error (%)')
xlim([3e9 8e9])


errorEpsPMLvsGate = (epsGate - epsPML) ./ epsPML;

figure;
plot(f, 100.*(errorEpsPMLvsGate))
xlabel('Frequency (Hz)')
ylabel('Eps Error (%)')
xlim([3e9 8e9])

errorSigPMLvsGate = (sigGate - sigPML) ./ sigPML;

figure;
plot(f, 100.*(errorSigPMLvsGate))
xlabel('Frequency (Hz)')
ylabel('Sig Error (%)')
xlim([3e9 8e9])

