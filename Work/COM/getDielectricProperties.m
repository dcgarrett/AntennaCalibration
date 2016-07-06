function [epsEst, sigEst, toa, aEst, bEst] = getDielectricProperties(S_cal, f, measLength, fcent, bw, betaTime1GroupDelay0, GRL_plot)

% getDielectricProperties
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca
%   This function estimates dielectric properties from the calibrated
%   S-parameters of an antenna transmission measurement. Calibration could
%   have been performed using GRL calibration (as it was designed for) but
%   other techniques may work also. A technique to unwrap the phase is used
%   which required a shifting of the phase constant, where parameters fcent
%   and bw are used to perform this.

% Method overview:
%   1. Determine complex propagation constant gamma = alpha + j(beta) 
%   2. Beta was found from phase unwrapping, so it is offset from its true value. 
%       Use shifting with a time of flight method to fix this
%   3. From the propagation constant determine permittivity and
%       conductivity

% INPUTS:
%       - S_cal: Calibrated 2x2 complex S-parameters of the transmission 
%           measurements of a MUT 
%       - f: Array of frequency corresponding to S-params (in Hz)
%       - measLength: separation distance of the antennas, filled with the
%           MUT
%       - fcent: Center frequency used for the time of flight shifting of
%           the phase constant (see documentation for more details)
%       - bw: Bandwidth used for the phase constant time of flight shifting
%           (see documentation for more details)
%       - GRL_plot: Passed option to plot the results

% OUTPUTS:
%       - epsEst: Estimated real relative permittivity for each frequency
%       - sigEst: Estimated electrical conductivity for each frequency

%% 0. Adjust parameters to account for reflections from the interfaces

% NOTE THE CHOSEN DIRECTION - S21 IS BEST
S11 = squeeze(S_cal(1,1,:));
S12 = squeeze(S_cal(1,2,:));
S21 = squeeze(S_cal(2,1,:));
S22 = squeeze(S_cal(2,2,:));

S21 = S12;
S11 = S22;

gainRadialSpreading = 1;

if gainRadialSpreading
    radSpFactor = 0.9;
    S21 = S21 .* db2mag(radSpFactor .* measLength./10e-3);
    disp(['Correcting for radial spreading by adding ' num2str(radSpFactor) ' dB/cm']);
end


adjustS11S12 = 1;

if adjustS11S12
    K = (S11.^2 - S21.^2 + 1) ./ (2.*S11);
    gamma1 = K + sqrt(K.^2 - 1);
    gamma2 = K - sqrt(K.^2 - 1);
    Gamma=gamma1;
    Gamma(abs(gamma1)>1) = gamma2(abs(gamma1)>1); % Gamma
    S21 = ((S11 + S21) - Gamma) ./ (1 - (S11 + S21) .* Gamma);
    %S22 = Gamma;
end



% 
% A = (S11.*S22) ./ (S21 .* S12);
% B = (S21.*S12 - S11.*S22);
% 
% gammaSqr1 = (-A.*(1-B.^2) + (1 - B).^2) ./ (2.*A.*B) + sqrt(-4.*A.^2.*B.^2 + (A.*(1+B.^2) - (1 - B).^2).^2) ./ (2.*A.*B);
% gammaSqr2 = (-A.*(1-B.^2) + (1 - B).^2) ./ (2.*A.*B) - sqrt(-4.*A.^2.*B.^2 + (A.*(1+B.^2) - (1 - B).^2).^2) ./ (2.*A.*B);
% 
% P_ch1 = S21 .* (1+gammaSqr1) ./ (1 + B.*gammaSqr1);
% P_ch2 = S21 .* (1+gammaSqr2) ./ (1 + B.*gammaSqr2);

%% 1. Determine complex propagation constant

%Sphase = phase(squeeze(S_cal(1,2,:))); % "unwrapped" phase of S12

Sangle = angle(S21); % phase of S12 (still wrapped)
Sphase = unwrap(Sangle*2)/2;

bEst = -Sphase ./ measLength;
bEstAngle = -Sangle ./ measLength;
aEst = -log(abs(S21)) ./ measLength;

%% 2. Perform time of flight analysis to properly shift the phase constant

% using peak of fcent:
if betaTime1GroupDelay0
    [betaTimeofFlightPeak, toa] = findBetaTOF(f, S21, fcent, bw, measLength, GRL_plot);
else
    [betaTimeofFlightPeak, toa] = findBetaGroupDelay(f, S21, fcent, measLength, GRL_plot);
end
bEst_preshift = bEst;

% shift estimated beta using time of flight:
shiftIndPeak = find(f > fcent, 1); % index of fcent
betaShiftAmount = betaTimeofFlightPeak - bEst(shiftIndPeak);
betaShiftAmountAngle = betaTimeofFlightPeak - bEstAngle(shiftIndPeak);
bEst = bEst + (betaTimeofFlightPeak - bEst(shiftIndPeak));

% Quantize the shift to 2*pi*m
% betaInterval = 2*pi / measLength;
% betaShiftClosest = round(betaShiftAmountAngle / betaInterval); % m causing right shift
% 
% quantShiftAmount = bEst_preshift(shiftIndPeak) - (betaShiftClosest*betaInterval + bEstAngle(shiftIndPeak));
% bEst_shiftQuant = bEst_preshift - quantShiftAmount;
% 
% if GRL_plot
%     figure;
%     hold on;
%     plot(f, bEst)
%     plot(f, bEst_shiftQuant,'r')
% end
% 
% bEst = bEst_shiftQuant;

%% 3. Estimate dielectric properties from complex propagation constant
epsEst = div_indep_dim((bEst.^2 - aEst.^2), ((2.*pi.*f).^2 .* 4E-7 .* pi .* 8.85E-12));
sigEst = div_indep_dim(2 .* aEst .* bEst, (f.*2.*pi .*4E-7 .* pi));

%% 4. Optional inquiry into changing beta TOF

otherBetaTOF = 1;
betaTOF_add_i = -100:20:100;
if otherBetaTOF
    for i=1:length(betaTOF_add_i)
        betaTOF_i = betaTimeofFlightPeak + betaTOF_add_i(i);
        shiftIndPeak_i = find(f > fcent, 1); % index of fcent
        betaShiftAmount_i = betaTOF_i - bEst_preshift(shiftIndPeak_i);
        betaShiftAmountAngle_i = betaTOF_i - bEstAngle(shiftIndPeak_i);
        bEst_i = bEst_preshift + (betaTOF_i - bEst_preshift(shiftIndPeak_i));
        
        epsEst_i(i,:) = div_indep_dim((bEst_i.^2 - aEst.^2), ((2.*pi.*f).^2 .* 4E-7 .* pi .* 8.85E-12));
        sigEst_i(i,:) = div_indep_dim(2 .* aEst .* bEst_i, (f.*2.*pi .*4E-7 .* pi));
    end
    
    materialName = 'er30dispersive';
    %materialName = 'Triton100';
    [epsTh, sigTh] = material_database(f, materialName,'Debye');
    
    %find closest estimate:
    fInd = find(f > 3e9 & f < 8e9);
    for j = 1:length(betaTOF_add_i)
        meanErrorEps(j,:) = mean(abs(epsEst_i(j,fInd) - epsTh(fInd).'));
    end
    [~, bestGuessInd] = min(((meanErrorEps)));
    
    if GRL_plot
        figure;
        subplot(2,1,1)
        hold on;
        plot(f, epsTh ,'g')
        %plot(f, epsEst_i,'r')
        plot(f, epsEst,'b')
        %plot(f, epsEst_i(bestGuessInd,:),'k')
        legend('True value','Original estimate')
        xlabel('Frequency (Hz)')
        ylabel('Estimated permittivity')
        xlim([3e9 8e9])
        
        subplot(2,1,2)
        hold on;
        plot(f, sigTh ,'g')
        %plot(f, sigEst_i,'r')
        plot(f, sigEst,'b')
        %plot(f, sigEst_i(bestGuessInd,:),'k')
        xlabel('Frequency (Hz)')
        ylabel('Estimated conductivity')
        xlim([3e9 8e9])
    end
end
