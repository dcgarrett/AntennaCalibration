function [ S_noisy] = GRL_addNoise(S, snr)

% GRL_addNoise
%   adds Gaussian random noise to a signal to emulate noise in a VNA
% http://anlage.umd.edu/Microwave%20Measurements%20for%20Personal%20Web%20Site/5980-2778EN.pdf
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca



%% Define noise

%noise = wgn(1, length(S), noise_power);

%% Add to the original signal

% Do we add in the frequency domain or time domain?
%   shouldn't really matter...

%S_noisy = S + noise;

S_noisy(1,1,:) = awgn(squeeze(S(1,1,:)), snr,'measured');
S_noisy(1,2,:) = awgn(squeeze(S(1,2,:)), snr,'measured');
S_noisy(2,1,:) = awgn(squeeze(S(2,1,:)), snr,'measured');
S_noisy(2,2,:) = awgn(squeeze(S(2,2,:)), snr,'measured');

end