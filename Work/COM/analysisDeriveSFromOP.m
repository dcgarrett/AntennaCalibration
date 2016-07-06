% Derive Thru and Reflect from O and P parameters

%% Measured:
S_filePath = 'C:\Users\Public\Documents\SEMCAD\CalibrationSimulations\Nahanni_GRL\Measured_GRL_Results\05Aug2015';
S_fileName = 'Canola_50mm.cti';
measLength = 50e-3;

[f, epsEst, sigEst, S_meas, S_cal, O, P, toa] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, 0, 'source','1x1');

[f, S_meas, Thru, Refl] = importForGRL(S_filePath, S_fileName, 0, '1x1');


thru_derived21 = squeeze(O(2,1,:)).*squeeze(P(2,1,:)) ./ (1 - squeeze(O(2,2,:)).*squeeze(P(1,1,:)));

figure;
hold on;
plot(f, mag2db(abs(thru_derived21)))
plot(f, mag2db(abs(squeeze(Thru(1,2,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
legend('Thru derived from O and P (meas)','Measured Thru')

% Derive time domain
[t, Thru_meas_t] = invczt_auto(f, Thru, 1,2);
[~, Thru_deri_t] = invczt_auto(f, thru_derived21,1,1);


figure;
hold on;
plot(t, Thru_deri_t)
plot(t, Thru_meas_t,'r')
xlabel('Time (s)')
ylabel('Magnitude')
legend('Thru derived from O and P (meas)','Measured Thru')

% Derive reflect:

refl_derived11 = squeeze(O(1,1,:)) - squeeze(O(2,1,:)).*squeeze(O(1,2,:)) ./ (1 + squeeze(O(2,2,:)));

figure;
hold on;
plot(f, mag2db(abs(refl_derived11)))
plot(f, mag2db(abs(squeeze(Refl(1,1,:)))),'r')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
legend('Refl S11 derived from O and P (meas)','Measured Refl S11')


%% Simulated