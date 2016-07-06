%% analysis - OP time domain

S_fileName = '50mm_Group1_NoWaveguide.cit';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\GRL_Analysis';
measLength = 50e-3;
simOrMeas = 1;

% Get O, P matrices

[f, epsGate, sigGate, ~, ~, O_gate, P_gate] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5);
[~, epsPML, sigPML, ~, ~, O_PML, P_PML] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 1);


% Convert to time domain

[t, Og11] = invczt_auto(f, O_gate, 1, 1);
[t, Og12] = invczt_auto(f, O_gate, 1, 2);
[t, Og21] = invczt_auto(f, O_gate, 2, 1);
[t, Og22] = invczt_auto(f, O_gate, 2, 2);

[t, Op11] = invczt_auto(f, O_PML, 1, 1);
[t, Op12] = invczt_auto(f, O_PML, 1, 2);
[t, Op21] = invczt_auto(f, O_PML, 2, 1);
[t, Op22] = invczt_auto(f, O_PML, 2, 2);


% Plot
figure;
hold on;
plot(t, Og11)
plot(t, Op11,'r')
xlabel('Time (s)')
ylabel('O11')
legend('Gate','PML')

figure;
hold on;
plot(t, Og12)
plot(t, Op12,'r')
xlabel('Time (s)')
ylabel('O12')
legend('Gate','PML')

figure;
hold on;
plot(t, Og21)
plot(t, Op21,'r')
xlabel('Time (s)')
ylabel('O21')
legend('Gate','PML')

figure;
hold on;
plot(t, Og22)
plot(t, Op22,'r')
xlabel('Time (s)')
ylabel('O22')
legend('Gate','PML')

%% Compare meas vs sim:

S_fileName = 'DistWater_50mm.cti';
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\Measured_GRL_Results\05Aug2015';
measLength = 50e-3;
simOrMeas = 0;

[f, ~, ~, ~, ~, O_meas, P_meas] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, 'DP_plot', 0, 'PML_O11P22', 0, 'thresh', 0.5);

[t, Om11] = invczt_auto(f, O_meas, 1, 1);
[t, Om12] = invczt_auto(f, O_meas, 1, 2);
[t, Om21] = invczt_auto(f, O_meas, 2, 1);
[t, Om22] = invczt_auto(f, O_meas, 2, 2);

figure;
hold on;
plot(t, Og11)
plot(t, Om11,'r')
xlabel('Time (s)')
ylabel('O11')
legend('Gate','Meas')

figure;
hold on;
plot(t, Og12)
plot(t, Om12,'r')
xlabel('Time (s)')
ylabel('O12')
legend('Gate','Meas')

figure;
hold on;
plot(t, Og21)
plot(t, Om21,'r')
xlabel('Time (s)')
ylabel('O21')
legend('Gate','Meas')

figure;
hold on;
plot(t, Og22)
plot(t, Om22,'r')
xlabel('Time (s)')
ylabel('O22')
legend('Gate','Meas')

%% Try filtering only 3-8 GHz

ind3to8GHz = find(f > 3e9 & f < 8e9);

[t, Om11_f] = invczt_auto(f(ind3to8GHz), O_meas(:,:,ind3to8GHz), 1, 1);
[t, Om12_f] = invczt_auto(f(ind3to8GHz), O_meas(:,:,ind3to8GHz), 1, 2);
[t, Om21_f] = invczt_auto(f(ind3to8GHz), O_meas(:,:,ind3to8GHz), 2, 1);
[t, Om22_f] = invczt_auto(f(ind3to8GHz), O_meas(:,:,ind3to8GHz), 2, 2);


figure;
hold on;
plot(t, Om12_f)
xlabel('Time (s)')
ylabel('O12 filtered')
legend('Gate','Meas')
