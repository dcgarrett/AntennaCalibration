function [ b_toa, toa ] = findBetaTOF( f, S21, fcent, bw, measLength, plotOption )
% find_beta_toa
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca
% Finds the beta of a transmission parameter for a certain centre
% frequency/bandwidth used to calculate time of arrival (toa)

% Method overview:
%   1. Apply a Gaussian filter according to fcent and bw in the frequency
%       domain
%   2. Convert filtered signal into time domain
%   3. Find the peak of the filtered signal, corresponding to the speed of
%       that frequency component
%   4. Calculate beta from the time of flight

%   INPUTS:     - f: entire frequency range
%               - S21: complex S21 (or S12) parameters
%               - fcent: centre frequency (Hz)
%               - bw: bandwidth (Hz)
%               - measLength: Separation distance during the measurement
%               - plotOption: User option to plot the results

%   OUTPUTS:    - b_toa: beta calculated for this centre frequency (rad/m)


%% 1. Apply Gaussian bandpass filter around S21 params in f-domain:

% Create the gate according to the user params
GaussFilt = gaussmf(f, [bw fcent]);
% Apply the filter in frequency domain
S21_filt = mult_indep_dim(S21, GaussFilt); % This is just element-wise multiplication but to ensure matrix dimension agreement

%% 2. Put filtered S21 into time-domain:
% Define TSAR pulse:
dt_tsar=2e-12;   %Time Step
T_tsar= 10e-9;     %Time Length
t_tsar=0:dt_tsar:T_tsar;   %Time Vector

% Pulse Parameters
tao=62.5e-12;
to=4*tao;

% Create TSAR function handle:
TSAR_handle = @(t_tsar) (t_tsar-to).*exp(-(t_tsar-to).^2/tao^2);
% SEMCAD_handle = @(t_sem)

% Gaussian pulse in time domain:

[timeSigFiltS12,  ~, ~,  ~]  = inverseczt_charlotte(f, S21_filt, t_tsar);

%% 3. Find the peak of the filtered signal

% Spline interpolation between peaks:
[pks, locs] = findpeaks(abs(timeSigFiltS12));
t_locs = t_tsar(locs);
pk_interp = spline(t_locs, pks, t_tsar);


% Find the peak of the interpolated signal
[pkspks, pkslocs] = findpeaks(pk_interp);
[~, pkstoaInd] = max(pkspks);
toaInd = pkslocs(pkstoaInd);


%% 4. Calculate beta from the time of flight
toa = t_tsar(toaInd);

vp = measLength / toa; % v = d/t;
b_toa = 2*pi*fcent / vp;

%% A. Plot is desired
if plotOption
    p = figure;
    hold on;
    grid on;
    plot(t_tsar, timeSigFiltS12)
    plot(toa,pk_interp(toaInd),'g+')
    plot(t_tsar(locs), pks, 'k')
    plot(t_tsar, pk_interp, 'r')
    xlabel('Time (s)')
    ylabel('Signal Magnitude')
    AX = legend(['Filtered t sig: fcent = ' num2str(fcent/1E9,'%.1f') ' GHz, BW = ' num2str(bw/1E9,'%.1f') ' GHz'],'Maximum','Abs of pks','Spline interp of pks');
    LEG = findobj(AX,'type','text');
    set(LEG,'FontSize',10)
    title(['fcent = ' num2str(fcent/1E9) ' GHz, BW = ' num2str(bw/1E9) ' GHz'])
    if bw > 1.5E9
        ylim([-8E8 8E8])
    else
        ylim([-5E8 5E8])
    end
    drawnow
    frame = getframe;
end
end

