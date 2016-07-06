function [O11, P22] = getGateO11P22(Thru, Refl, thresh, f, useTSAR_handle, plotOption)
%% Get Gate (O11 and P22) 
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca

% This function computes the gating coefficients O11 and P22 as part of GRL
% calibration. These are found using time-domain gating to isolate
% reflections due to the antennas during transmission.

% Overview of method:
%   1. Transform the Thru and Reflect reflection signals to time domain
%   2. Perform time domain gating to isolate the reflections which occur
%   prior to the antenna aperture (reflections due to the antenna itself)
%   3. Transorm the gated signal back to the frequency domain

% INPUTS
%     Thru:   Measured 2x2 complex S-params for Thru calibration procedure
%     Refl:   Measured 2x2 complex S-params for Reflect calibration procedure
%     f:      Array of frequency values (in Hz)
%     useTSAR_handle: Boolean option to use the TSAR function handle with the iCZT
%                       (recommended)
%     plotOption: Boolean option to plot data in time and frequency domain

% OUTPUTS
%     O11: Coefficient for reflected signals during transmission from ant 1
%     P22: Coefficient for reflected signals during transmission from ant 2

%% 0. User/other parameters:

% Gate parameters:
gaussN = 100; % to determine abruptness of gauss gate % doesn't really seem to affect much
slide = 100;%100; % number of samples to slide left by


% TSAR pulse parameters:
dt_tsar=2e-12;   %Time Step
T_tsar= 10e-9;     %Time Length
t_tsar=0:dt_tsar:T_tsar;   %Time Vector

% Pulse Parameters
tao=62.5e-12;
to=4*tao;

% Produce the pulse signal
TSAR_Pulse=(t_tsar-to).*exp(-(t_tsar-to).^2/tao^2);
TSAR_Pulse=TSAR_Pulse./max(TSAR_Pulse);

% Create TSAR function handle
TSAR_handle = @(t_tsar) (t_tsar-to).*exp(-(t_tsar-to).^2/tao^2);


%% 1. Transform to time domain:
%apply inverseczt using tsar handle
for ind = 1:2 % S11 and S22
    Srow = ind;
    Scolumn = ind;
    if useTSAR_handle
        [timeSigThru(ind,:), t, ~, ~] = inverseczt_charlotte(f, squeeze(Thru(Srow,Scolumn,:)), t_tsar, TSAR_handle);
        [timeSigRefl(ind,:), ~, ~, ~] = inverseczt_charlotte(f, squeeze(Refl(Srow,Scolumn,:)), t_tsar, TSAR_handle);
    else
        [timeSigThru(ind,:), t, ~, ~] = inverseczt_charlotte(f, squeeze(Thru(Srow,Scolumn,:)), t_tsar);
        [timeSigRefl(ind,:), ~, ~, ~] = inverseczt_charlotte(f, squeeze(Refl(Srow,Scolumn,:)), t_tsar);
    end
end

%% 2. Gate time domain signal:
for ind = 1:2
    timeSigDiff(ind,:) = timeSigThru(ind,:) - timeSigRefl(ind,:);
    
    % NEED TO USE A GAUSSIAN GATE
    sigma(ind) = thresh * max(timeSigThru(ind,:)); % was 0.01 Jan 28 2016
    gateCutoff(ind) = find(timeSigDiff(ind,:) > sigma(ind), 1 );
    temp = timeSigThru(ind, 1:gateCutoff(ind));
    temp(gateCutoff+1:length(timeSigThru(ind,:))) = zeros;
    timeSigThru_Gate(ind, :) = temp;
    
    gaussSigma = t(gaussN);
    
    gaussGate(ind, 1:gateCutoff(ind)-(gaussN/2)-slide) = 1;
    gaussGate(ind, gateCutoff(ind)-gaussN/2+1-slide:length(t)) = gaussmf(t(gateCutoff(ind)-gaussN/2+1-slide:end), [gaussSigma t(gateCutoff(ind))-gaussSigma/2-t(slide)]); %need to play with sig value for gauss
    
    timeSigThru_GaussGate(ind,:) = gaussGate(ind,:) .* timeSigThru(ind,:);
    timeSigRefl_GaussGate(ind,:) = gaussGate(ind,:) .* timeSigRefl(ind, :);
    timeSigDiff_GaussGate(ind,:) = timeSigThru_GaussGate(ind,:) - timeSigRefl_GaussGate(ind,:);
end

%% 3. Convert back to frequency domain:

dt = t(2) - t(1);
df = f(2) - f(1);
fmin = min(f);

M = length(f);
W = exp(-1j*2*pi*dt*df);
A = exp(1j*2*pi*fmin*dt);

% Get fpulse for tsar:
if useTSAR_handle
    fpulse = czt(TSAR_Pulse,M,W,A);
    fpulse = fpulse./max(abs(fpulse));
end

% O11 corresponds to S11
O11 = normczt(t, timeSigThru_GaussGate(1,:), f);
%O11 = ChirpZTrans(t, timeSigThru_GaussGate(1,:), f);
%O11 = fftshift(fft(timeSigThru_GaussGate(1,:)).*dt);
% undo effect from TSAR:
if useTSAR_handle
    O11 = O11 ./ fpulse;
end

% P22 corresponds to S22
P22 = normczt(t, timeSigThru_GaussGate(2,:), f);
% undo effect from TSAR:
if useTSAR_handle
    P22 = P22 ./ fpulse;
end

%% A. Plot if desired
plotNames = ['O11';'P22'];
if plotOption
    for ind = 1:2
        figure;
        hold on;
        grid on;
        plot(t, gaussGate(ind, :))
        plot(t, timeSigDiff(ind, :) ./ max(timeSigDiff(ind,:)),'r')
        title(['For ' plotNames(ind,:)])
        xlabel('Time (s)')
        ylabel('Time domain magnitude')
        legend('Gaussian gate', 'Normalized difference between thru and reflect')
        
        figure;
        hold on;
        grid on;
        plot(t,timeSigDiff)
        plot(t(gateCutoff), timeSigDiff(gateCutoff),'+r')
        title(['For ' plotNames(ind,:)])
        xlabel('Time (s)')
        ylabel('Magnitude of difference between time-domain signals')
        
        figure;
        grid on;
        plot(t, timeSigThru_GaussGate);
        xlabel('Time (s)')
        ylabel('Time signal magnitude of Gate')
        title(['For ' plotNames(ind,:)])
        grid on;
    end
    
    figure;
    hold on;
    grid on;
    plot(f, mag2db(abs(O11)))
    plot(f, mag2db(abs(P22)),'r')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    legend('O11','P22')
    title(['Derived ' plotNames(ind,:) ' in Frequency Domain'])
    
    figure;
    hold on;
    yyaxis left
    plot(t, timeSigThru(1,:))
    plot(t, timeSigRefl(1,:),'r')
    ylim([-3e9 3e9])
    ax = gca;
    ax.YColor = [0 0 0];
    ylabel('S11 Magnitude')
    yyaxis right
    plot(t, gaussGate(1,:), 'Color',[0 0.6 0])
    ax = gca;
    ax.YColor = [0 0.6 0];
    ylabel('Gate magnitude')
    legend('Thru','Reflect','Gate')
    xlabel('Time (s)')
    grid on;
    box on;
    hold off;
    
end

end
