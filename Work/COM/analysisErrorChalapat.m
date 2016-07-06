%% Analyze error in the procedure similarly to that in Chalapat 2010
%       First looking at only inducing error into the MUT measurement

%% 1. Load the calibrated data

% Simulated
fcent = 2.6e9;
%fileName = 'er30sig0_50mm.mat'; 
fileName = 'TritonX100_40pc_50mm_14GHzBW.mat';
%fileName = 'Thru.mat';
filePath = 'C:\Users\dgarrett\Google Drive\Work\Simulations\Data';
measLength = 50e-3;
simOrMeas = 1;
[f_sim, epsEst, sigEst, ~, S_cal, O_sim, P_sim, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',1,'fcent',fcent);


%% 2. Numerically differentiate several parameters in order to determine their effect on eps and sig

% First try with just the MUT S-params:
% Treat independently of frequency:

%% MUT measLength
measLength_array = (measLength - 5e-3): 0.1e-3:(measLength + 5e-3);

for i = 1:length(measLength_array)
    [~, epsEst_measLength(i,:), sigEst_measLength(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength_array(i), simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent);
end

figure;
hold on;
plot(measLength_array, epsEst_measLength(:,500))
xlabel('Meas Length')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(measLength_array, sigEst_measLength(:,500))
xlabel('Meas Length')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dL = (epsEst_measLength(2:end,:) - epsEst_measLength(1:end-1, :)) ./ (measLength_array(2) - measLength_array(1));
for i = 1:length(f)-1
    avg_dEps_dL(i) = mean(dEps_dL(:,i));
end

deltaL = 0.1e-3;

figure;
hold on;
plot(f(2:end),avg_dEps_dL .* deltaL)
xlabel('Frequency')
ylabel(['(dEps/dL) * ', num2str(deltaL*1000),' mm'])
xlim([3e9 8e9])
box on;

dSig_dL = (sigEst_measLength(2:end,:) - sigEst_measLength(1:end-1, :)) ./ (measLength_array(2) - measLength_array(1));
for i = 1:length(f)-1
    avg_dSig_dL(i) = mean(dSig_dL(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dL .* deltaL)
xlabel('Frequency')
ylabel(['(dSig/dL) * ', num2str(deltaL*1000),' mm'])
xlim([3e9 8e9])
box on;

%% MUT S21 abs
S21_abs_array = -0.010:0.002:0.010;

for i = 1:length(S21_abs_array)
    [~, epsEst_S21mag(i,:), sigEst_S21mag(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorMUTS21abs',S21_abs_array(i));
end

figure;
hold on;
plot(S21_abs_array, epsEst_S21mag(:,500))
xlabel('S21 mag deviation')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(S21_abs_array, sigEst_S21mag(:,500))
xlabel('S21 mag deviation')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dS21mag = (epsEst_S21mag(2:end,:) - epsEst_S21mag(1:end-1, :)) ./ (S21_abs_array(2) - S21_abs_array(1));
for i = 1:length(f)-1
    avg_dEps_dS21mag(i) = mean(dEps_dS21mag(:,i));
end

deltaS21mag = 0.002;

figure;
hold on;
plot(f(2:end),avg_dEps_dS21mag .* deltaS21mag)
xlabel('Frequency')
ylabel(['(dEps/dS21mag) * ', num2str(deltaS21mag)])
xlim([3e9 8e9])
box on;

dSig_dS21mag = (sigEst_S21mag(2:end,:) - sigEst_S21mag(1:end-1, :)) ./ (S21_abs_array(2) - S21_abs_array(1));
for i = 1:length(f)-1
    avg_dSig_dS21mag(i) = mean(dSig_dS21mag(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dS21mag .* deltaS21mag)
xlabel('Frequency')
ylabel(['(dSig/dS21mag) * ', num2str(deltaS21mag)])
xlim([3e9 8e9])
box on;

%% MUT S21 arg
S21_arg_array = -3:0.1:3; % in degrees
S21_arg_array = S21_arg_array .* pi ./ 180; % Now in radians
for i = 1:length(S21_arg_array)
    [~, epsEst_S21arg(i,:), sigEst_S21arg(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorMUTS21arg',S21_arg_array(i));
end

figure;
hold on;
plot(S21_arg_array .* 180 ./ pi, epsEst_S21arg(:,500))
xlabel('S21 arg deviation (deg)')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(S21_arg_array .* 180 ./ pi, sigEst_S21arg(:,500))
xlabel('S21 arg deviation (deg)')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dS21arg = (epsEst_S21arg(2:end,:) - epsEst_S21arg(1:end-1, :)) ./ (S21_arg_array(2) - S21_arg_array(1));
for i = 1:length(f)-1
    avg_dEps_dS21arg(i) = mean(dEps_dS21arg(:,i));
end

deltaS21argDeg = 1;
deltaS21arg = deltaS21argDeg * pi / 180;

figure;
hold on;
plot(f(2:end),avg_dEps_dS21arg .* deltaS21arg)
xlabel('Frequency')
ylabel(['(dEps/dS21arg) * ', num2str(deltaS21argDeg),' degree'])
xlim([3e9 8e9])
box on;


dSig_dS21arg = (sigEst_S21arg(2:end,:) - sigEst_S21arg(1:end-1, :)) ./ (S21_arg_array(2) - S21_arg_array(1));
for i = 1:length(f)-1
    avg_dSig_dS21arg(i) = mean(dSig_dS21arg(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dS21arg .* deltaS21arg)
xlabel('Frequency')
ylabel(['(dSig/dS21arg) * ', num2str(deltaS21argDeg),' degree'])
xlim([3e9 8e9])
box on;

%% MUT S11 abs
S11_abs_array = -0.010:0.002:0.010;

for i = 1:length(S11_abs_array)
    [~, epsEst_S11mag(i,:), sigEst_S11mag(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorMUTS11abs',S11_abs_array(i));
end

figure;
hold on;
plot(S11_abs_array, epsEst_S11mag(:,500))
xlabel('S11 mag deviation')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(S11_abs_array, sigEst_S11mag(:,500))
xlabel('S11 mag deviation')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dS11mag = (epsEst_S11mag(2:end,:) - epsEst_S11mag(1:end-1, :)) ./ (S11_abs_array(2) - S11_abs_array(1));
for i = 1:length(f)-1
    avg_dEps_dS11mag(i) = mean(dEps_dS11mag(:,i));
end

deltaS11mag = 0.002;

figure;
hold on;
plot(f(2:end),avg_dEps_dS11mag .* deltaS11mag)
xlabel('Frequency')
ylabel(['(dEps/dS11mag) * ', num2str(deltaS11mag)])
xlim([3e9 8e9])
box on;

dSig_dS11mag = (sigEst_S11mag(2:end,:) - sigEst_S11mag(1:end-1, :)) ./ (S11_abs_array(2) - S11_abs_array(1));
for i = 1:length(f)-1
    avg_dSig_dS11mag(i) = mean(dSig_dS11mag(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dS11mag .* deltaS11mag)
xlabel('Frequency')
ylabel(['(dSig/dS11mag) * ', num2str(deltaS11mag)])
xlim([3e9 8e9])
box on;

%% MUT S11 arg
S11_arg_array = -3:0.1:3; % in degrees
S11_arg_array = S11_arg_array .* pi ./ 180; % Now in radians
for i = 1:length(S11_arg_array)
    [~, epsEst_S11arg(i,:), sigEst_S11arg(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorMUTS11arg',S11_arg_array(i));
end

figure;
hold on;
plot(S11_arg_array .* 180 ./ pi, epsEst_S11arg(:,500))
xlabel('S11 arg deviation (deg)')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(S11_arg_array .* 180 ./ pi, sigEst_S11arg(:,500))
xlabel('S11 arg deviation (deg)')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dS11arg = (epsEst_S11arg(2:end,:) - epsEst_S11arg(1:end-1, :)) ./ (S11_arg_array(2) - S11_arg_array(1));
for i = 1:length(f)-1
    avg_dEps_dS11arg(i) = mean(dEps_dS11arg(:,i));
end

deltaS11argDeg = 3;
deltaS11arg = deltaS11argDeg * pi / 180;

figure;
hold on;
plot(f(2:end),avg_dEps_dS11arg .* deltaS11arg)
xlabel('Frequency')
ylabel(['(dEps/dS11arg) * ', num2str(deltaS11argDeg),' degree'])
xlim([3e9 8e9])
box on;


dSig_dS11arg = (sigEst_S11arg(2:end,:) - sigEst_S11arg(1:end-1, :)) ./ (S11_arg_array(2) - S11_arg_array(1));
for i = 1:length(f)-1
    avg_dSig_dS11arg(i) = mean(dSig_dS11arg(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dS11arg .* deltaS11arg)
xlabel('Frequency')
ylabel(['(dSig/dS11arg) * ', num2str(deltaS11argDeg),' degree'])
xlim([3e9 8e9])
box on;

%% 3. Add errors to the calibration procedures

%% Thru S21 abs
T21_abs_array = -0.010:0.002:0.010;

for i = 1:length(T21_abs_array)
    [~, epsEst_T21mag(i,:), sigEst_T21mag(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorThruS21abs',T21_abs_array(i));
end

figure;
hold on;
plot(T21_abs_array, epsEst_T21mag(:,500))
xlabel('Thru 21 mag deviation')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(T21_abs_array, sigEst_T21mag(:,500))
xlabel('Thru 21 mag deviation')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dT21mag = (epsEst_T21mag(2:end,:) - epsEst_T21mag(1:end-1, :)) ./ (T21_abs_array(2) - T21_abs_array(1));
for i = 1:length(f)-1
    avg_dEps_dT21mag(i) = mean(dEps_dT21mag(:,i));
end

deltaT21mag = 0.002;

figure;
hold on;
plot(f(2:end),avg_dEps_dT21mag .* deltaT21mag)
xlabel('Frequency')
ylabel(['(dEps/dT21mag) * ', num2str(deltaT21mag)])
xlim([3e9 8e9])
box on;

dSig_dT21mag = (sigEst_T21mag(2:end,:) - sigEst_T21mag(1:end-1, :)) ./ (T21_abs_array(2) - T21_abs_array(1));
for i = 1:length(f)-1
    avg_dSig_dT21mag(i) = mean(dSig_dT21mag(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dT21mag .* deltaT21mag)
xlabel('Frequency')
ylabel(['(dSig/dT21mag) * ', num2str(deltaT21mag)])
xlim([3e9 8e9])
box on;

%% Thru S11 abs
T11_abs_array = -0.010:0.002:0.010;

for i = 1:length(T21_abs_array)
    [~, epsEst_T11mag(i,:), sigEst_T11mag(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorThruS11abs',T11_abs_array(i));
end

figure;
hold on;
plot(T11_abs_array, epsEst_T11mag(:,500))
xlabel('Thru 11 mag deviation')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(T11_abs_array, sigEst_T11mag(:,500))
xlabel('Thru 11 mag deviation')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dT11mag = (epsEst_T11mag(2:end,:) - epsEst_T11mag(1:end-1, :)) ./ (T11_abs_array(2) - T11_abs_array(1));
for i = 1:length(f)-1
    avg_dEps_dT11mag(i) = mean(dEps_dT11mag(:,i));
end

deltaT11mag = 0.002;

figure;
hold on;
plot(f(2:end),avg_dEps_dT11mag .* deltaT11mag)
xlabel('Frequency')
ylabel(['(dEps/dT11mag) * ', num2str(deltaT11mag)])
xlim([3e9 8e9])
box on;


dSig_dT11mag = (sigEst_T11mag(2:end,:) - sigEst_T11mag(1:end-1, :)) ./ (T11_abs_array(2) - T11_abs_array(1));
for i = 1:length(f)-1
    avg_dSig_dT11mag(i) = mean(dSig_dT11mag(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dT11mag .* deltaT11mag)
xlabel('Frequency')
ylabel(['(dSig/dT11mag) * ', num2str(deltaT11mag)])
xlim([3e9 8e9])
box on;

%% Reflect errors

%% Refl S21 abs
R21_abs_array = -0.010:0.002:0.010;

for i = 1:length(R21_abs_array)
    [~, epsEst_R21mag(i,:), sigEst_R21mag(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorReflS21abs',R21_abs_array(i));
end

figure;
hold on;
plot(R21_abs_array, epsEst_R21mag(:,500))
xlabel('Refl 21 mag deviation')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(R21_abs_array, sigEst_R21mag(:,500))
xlabel('Refl 21 mag deviation')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dR21mag = (epsEst_R21mag(2:end,:) - epsEst_R21mag(1:end-1, :)) ./ (R21_abs_array(2) - R21_abs_array(1));
for i = 1:length(f)-1
    avg_dEps_dR21mag(i) = mean(dEps_dR21mag(:,i));
end

deltaR21mag = 0.002;

figure;
hold on;
plot(f(2:end),avg_dEps_dR21mag .* deltaR21mag)
xlabel('Frequency')
ylabel(['(dEps/dR21mag) * ', num2str(deltaR21mag)])
xlim([3e9 8e9])
box on;

dSig_dR21mag = (sigEst_R21mag(2:end,:) - sigEst_R21mag(1:end-1, :)) ./ (R21_abs_array(2) - R21_abs_array(1));
for i = 1:length(f)-1
    avg_dSig_dR21mag(i) = mean(dSig_dR21mag(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dR21mag .* deltaR21mag)
xlabel('Frequency')
ylabel(['(dSig/dR21mag) * ', num2str(deltaR21mag)])
xlim([3e9 8e9])
box on;

%% Refl S11 abs
R11_abs_array = -0.010:0.002:0.010;

for i = 1:length(R11_abs_array)
    [~, epsEst_R11mag(i,:), sigEst_R11mag(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorReflS11abs',R11_abs_array(i));
end

figure;
hold on;
plot(R11_abs_array, epsEst_R11mag(:,500))
xlabel('Refl 11 mag deviation')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(R11_abs_array, sigEst_R11mag(:,500))
xlabel('Refl 11 mag deviation')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dR11mag = (epsEst_R11mag(2:end,:) - epsEst_R11mag(1:end-1, :)) ./ (R11_abs_array(2) - R11_abs_array(1));
for i = 1:length(f)-1
    avg_dEps_dR11mag(i) = mean(dEps_dR11mag(:,i));
end

deltaR11mag = 0.002;

figure;
hold on;
plot(f(2:end),avg_dEps_dR11mag .* deltaR11mag)
xlabel('Frequency')
ylabel(['(dEps/dR11mag) * ', num2str(deltaR11mag)])
xlim([3e9 8e9])
box on;


dSig_dR11mag = (sigEst_R11mag(2:end,:) - sigEst_R11mag(1:end-1, :)) ./ (R11_abs_array(2) - R11_abs_array(1));
for i = 1:length(f)-1
    avg_dSig_dR11mag(i) = mean(dSig_dR11mag(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dR11mag .* deltaR11mag)
xlabel('Frequency')
ylabel(['(dSig/dR11mag) * ', num2str(deltaR11mag)])
xlim([3e9 8e9])
box on;

%% Thru S21 arg
T21_arg_array = -3:0.1:3; % in degrees
T21_arg_array = T21_arg_array .* pi ./ 180; % Now in radians
for i = 1:length(T21_arg_array)
    [~, epsEst_T21arg(i,:), sigEst_T21arg(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorThruS21arg',T21_arg_array(i));
end

figure;
hold on;
plot(T21_arg_array .* 180 ./ pi, epsEst_T21arg(:,500))
xlabel('Thru 21 arg deviation (deg)')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(T21_arg_array .* 180 ./ pi, sigEst_T21arg(:,500))
xlabel('Thru 21 arg deviation (deg)')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dT21arg = (epsEst_T21arg(2:end,:) - epsEst_T21arg(1:end-1, :)) ./ (T21_arg_array(2) - T21_arg_array(1));
for i = 1:length(f)-1
    avg_dEps_dT21arg(i) = mean(dEps_dT21arg(:,i));
end

deltaT21argDeg = 1;
deltaT21arg = deltaT21argDeg * pi / 180;

figure;
hold on;
plot(f(2:end),avg_dEps_dT21arg .* deltaT21arg)
xlabel('Frequency')
ylabel(['(dEps/dT21arg) * ', num2str(deltaT21argDeg),' degree'])
xlim([3e9 8e9])
box on;


dSig_dT21arg = (sigEst_T21arg(2:end,:) - sigEst_T21arg(1:end-1, :)) ./ (T21_arg_array(2) - T21_arg_array(1));
for i = 1:length(f)-1
    avg_dSig_dT21arg(i) = mean(dSig_dT21arg(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dT21arg .* deltaT21arg)
xlabel('Frequency')
ylabel(['(dSig/dT21arg) * ', num2str(deltaT21argDeg),' degree'])
xlim([3e9 8e9])
box on;

%% Thru S11 arg
T11_arg_array = -3:0.1:3; % in degrees
T11_arg_array = T11_arg_array .* pi ./ 180; % Now in radians
for i = 1:length(T11_arg_array)
    [~, epsEst_T11arg(i,:), sigEst_T11arg(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorThruS11arg',T11_arg_array(i));
end

figure;
hold on;
plot(T11_arg_array .* 180 ./ pi, epsEst_T11arg(:,500))
xlabel('Thru 11 arg deviation (deg)')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(T11_arg_array .* 180 ./ pi, sigEst_T11arg(:,500))
xlabel('Thru 11 arg deviation (deg)')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dT11arg = (epsEst_T11arg(2:end,:) - epsEst_T11arg(1:end-1, :)) ./ (T11_arg_array(2) - T11_arg_array(1));
for i = 1:length(f)-1
    avg_dEps_dT11arg(i) = mean(dEps_dT11arg(:,i));
end

deltaT11argDeg = 3;
deltaT11arg = deltaT11argDeg * pi / 180;

figure;
hold on;
plot(f(2:end),avg_dEps_dT11arg .* deltaT11arg)
xlabel('Frequency')
ylabel(['(dEps/dT11arg) * ', num2str(deltaT11argDeg),' degree'])
xlim([3e9 8e9])
box on;

dSig_dT11arg = (sigEst_T11arg(2:end,:) - sigEst_T11arg(1:end-1, :)) ./ (T11_arg_array(2) - T11_arg_array(1));
for i = 1:length(f)-1
    avg_dSig_dT11arg(i) = mean(dSig_dT11arg(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dT11arg .* deltaT11arg)
xlabel('Frequency')
ylabel(['(dSig/dT11arg) * ', num2str(deltaT11argDeg),' degree'])
xlim([3e9 8e9])
box on;


%% Refl S21 arg
R21_arg_array = -3:0.1:3; % in degrees
R21_arg_array = R21_arg_array .* pi ./ 180; % Now in radians
for i = 1:length(R21_arg_array)
    [~, epsEst_R21arg(i,:), sigEst_R21arg(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorReflS21arg',R21_arg_array(i));
end

figure;
hold on;
plot(R21_arg_array .* 180 ./ pi, epsEst_R21arg(:,500))
xlabel('Refl 21 arg deviation (deg)')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(R21_arg_array .* 180 ./ pi, sigEst_R21arg(:,500))
xlabel('Refl 21 arg deviation (deg)')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dR21arg = (epsEst_R21arg(2:end,:) - epsEst_R21arg(1:end-1, :)) ./ (R21_arg_array(2) - R21_arg_array(1));
for i = 1:length(f)-1
    avg_dEps_dR21arg(i) = mean(dEps_dR21arg(:,i));
end

deltaR21argDeg = 1;
deltaR21arg = deltaR21argDeg * pi / 180;

figure;
hold on;
plot(f(2:end),avg_dEps_dR21arg .* deltaR21arg)
xlabel('Frequency')
ylabel(['(dEps/dR21arg) * ', num2str(deltaR21argDeg),' degree'])
xlim([3e9 8e9])
box on;

dSig_dR21arg = (sigEst_R21arg(2:end,:) - sigEst_R21arg(1:end-1, :)) ./ (R21_arg_array(2) - R21_arg_array(1));
for i = 1:length(f)-1
    avg_dSig_dR21arg(i) = mean(dSig_dR21arg(:,i));
end

figure;
hold on;
plot(f(2:end),avg_dSig_dR21arg .* deltaR21arg)
xlabel('Frequency')
ylabel(['(dSig/dR21arg) * ', num2str(deltaR21argDeg),' degree'])
xlim([3e9 8e9])
box on;

%% Refl S11 arg
R11_arg_array = -3:0.1:3; % in degrees
R11_arg_array = R11_arg_array .* pi ./ 180; % Now in radians
for i = 1:length(R11_arg_array)
    [~, epsEst_R11arg(i,:), sigEst_R11arg(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,'errorReflS11arg',R11_arg_array(i));
end

figure;
hold on;
plot(R11_arg_array .* 180 ./ pi, epsEst_R11arg(:,500))
xlabel('Refl 11 arg deviation (deg)')
ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

figure;
hold on;
plot(R11_arg_array .* 180 ./ pi, sigEst_R11arg(:,500))
xlabel('Refl 11 arg deviation (deg)')
ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])
box on;

dEps_dR11arg = (epsEst_R11arg(2:end,:) - epsEst_R11arg(1:end-1, :)) ./ (R11_arg_array(2) - R11_arg_array(1));
for i = 1:length(f)-1
    avg_dEps_dR11arg(i) = mean(dEps_dR11arg(:,i));
end

dSig_dR11arg = (sigEst_R11arg(2:end,:) - sigEst_R11arg(1:end-1, :)) ./ (R11_arg_array(2) - R11_arg_array(1));
for i = 1:length(f)-1
    avg_dSig_dR11arg(i) = mean(dSig_dR11arg(:,i));
end

deltaR11argDeg = 3;
deltaR11arg = deltaR11argDeg * pi / 180;

figure;
hold on;
plot(f(2:end),avg_dEps_dR11arg .* deltaR11arg)
xlabel('Frequency')
ylabel(['(dEps/dR11arg) * ', num2str(deltaR11argDeg),' degree'])
xlim([3e9 8e9])
box on;

figure;
hold on;
plot(f(2:end),avg_dSig_dR11arg .* deltaR11arg)
xlabel('Frequency')
ylabel(['(dSig/dR11arg) * ', num2str(deltaR11argDeg),' degree'])
xlim([3e9 8e9])
box on;


%% FIND TOTAL ERROR


avg_dEps_TOTAL = sqrt( (avg_dEps_dS21mag .* deltaS21mag).^2 + (avg_dEps_dS21arg .* deltaS21arg).^2 + ...
    (avg_dEps_dS11mag .* deltaS11mag).^2 + (avg_dEps_dS11arg .* deltaS11arg).^2 + ...
    (avg_dEps_dT21mag .* deltaT21mag).^2 + (avg_dEps_dT21arg .* deltaT21arg).^2 + ...
    (avg_dEps_dT11mag .* deltaT11mag).^2 + (avg_dEps_dT11arg .* deltaT11arg).^2 + ...
    (avg_dEps_dR21mag .* deltaR21mag).^2 + (avg_dEps_dR21arg .* deltaR21arg).^2 + ...
    (avg_dEps_dR11mag .* deltaR11mag).^2 + (avg_dEps_dR11arg .* deltaR11arg).^2 + ...
    (avg_dEps_dL .* deltaL).^2);
    
figure;
plot(f(2:end), avg_dEps_TOTAL)
xlabel('Frequency (Hz)')
ylabel('Total permittivity error')
xlim([3e9 8e9])
grid on;
box on;

avg_dSig_TOTAL = sqrt( (avg_dSig_dS21mag .* deltaS21mag).^2 + (avg_dSig_dS21arg .* deltaS21arg).^2 + ...
    (avg_dSig_dS11mag .* deltaS11mag).^2 + (avg_dSig_dS11arg .* deltaS11arg).^2 + ...
    (avg_dSig_dT21mag .* deltaT21mag).^2 + (avg_dSig_dT21arg .* deltaT21arg).^2 + ...
    (avg_dSig_dT11mag .* deltaT11mag).^2 + (avg_dSig_dT11arg .* deltaT11arg).^2 + ...
    (avg_dSig_dR21mag .* deltaR21mag).^2 + (avg_dSig_dR21arg .* deltaR21arg).^2 + ...
    (avg_dSig_dR11mag .* deltaR11mag).^2 + (avg_dSig_dR11arg .* deltaR11arg).^2 + ...
    (avg_dSig_dL .* deltaL).^2);
    
figure;
plot(f(2:end), avg_dSig_TOTAL)
xlabel('Frequency (Hz)')
ylabel('Total conductivity error')
xlim([3e9 8e9])
grid on;
box on;









