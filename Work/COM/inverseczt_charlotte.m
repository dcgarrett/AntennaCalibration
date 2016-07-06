function [tsig t fsig complexsig] = inverseczt_charlotte(freq,s11,varargin)
% This function computes the time domain signal from a set of frequency
% samples using the inverse Chirp Z-Transform. The samples are optionally
% weighted with the spectrum of a pulse specified in the time domain.
%
% FUNCTION [tsig t fsig complexsig] = inverseczt(freq,s11,varargin)
%
% If t is not specified, it will be computed as:
%   t = 0:0.03/freq(end):0.1/(freq(2)-freq(1));
%
% Charlotte Curtis, Jan 28 2013
%
% Required variables:
%   - freq: a vector of frequency values
%   - s11: a complex vector of associated reflection coefficients
%
% Optional variables:
%   - t: a vector of time values
%   - h_pulse: handle to a function that computes a time domain pulse
%   - anything that needs to be passed to h_pulse
%
% Returned variables:
%   - tsig: the real part of the computed time domain signal
%   - t: the time vector. If a vector t is passed as an input, it is simply
%   returned unmodified. If a vector t is created, it is returned in t.
%   - fsig: the weighted frequency domain signal
%   - complexsig: the complete complex time domain signal
%
% Example usage:
% [tsig t] = inverseczt(freq,s11,@tsarpulse)
%   - computes a t vector from frequency parameters, weights the s11 data
%   with the function defined in tsarpulse.m and returns the time data
%
% tsig = inverseczt(freq,s11,t,@tsarpulse)
%   - weights the s11 data with the function defined in tsarpulse.m using
%   the specified time vector t
%
% tsig = inverseczt(freq,s11,@tsarpulse,t,62.5e-12)
%   - weights the s11 data using the time vector t and passing 62.5e-12 as 
%   the parameter tau to tsarpulse.m.

t = [];
h_pulse = [];
pulsevars = [];

% parse the optional arguments
nvarargs = size(varargin,2);

if nvarargs > 0
    t = varargin{1};
    if nvarargs > 1
        h_pulse = varargin{2};
    end
    if nvarargs > 2
        pulsevars = varargin{3:end};
    end
end

if isempty(t)
    t = 0:0.03/freq(end):0.1/(freq(2)-freq(1));
end

% make sure s11 is a column vector or matrix
if isvector(s11)
    if size(s11,2) ~= 1
        s11 = s11.';
    end
else
    disp('S11 is a matrix. Performing inverse CZT on columns.');
end

% Finally we can get the length of t
N = length(t);

% define CZT parameters
df = freq(2) - freq(1);
dt = t(2) - t(1);
fmin = min(freq);
M = length(freq);
W = exp(-1j*2*pi*dt*df);
A = exp(1j*2*pi*fmin*dt);

if isempty(h_pulse)
    fpulse = ones(size(s11));
else
    % we can't specify pulsevars as an empty cell, because then varargin inside
    % h_pulse will have be a 1x1 cell array containing an empty cell!
    if isempty(pulsevars)
        tpulse = h_pulse(t);
    else
        tpulse = h_pulse(t,pulsevars);
    end

    %% Convert TSAR pulse to frequency domain using czt
    fpulse = czt(tpulse,M,W,A);

    %% normalize the frequency domain pulse to a maximum of one
    fpulse = fpulse./(max(abs(fpulse)));
    
    % plot fpulse:
%     figure;
%     plot(abs(fpulse))
    
    % make sure it's a column vector
    if size(fpulse,2) > size(fpulse,1)
        fpulse = fpulse.';
    end
    
    % then replicate to match the columns of s11
    fpulse = repmat(fpulse, 1, size(s11,2));
end
    
%% weight the S11 data and convert back to time
fsig = fpulse.*s11;

% this time we want to reconstruct from time step 0. Also, normalize in the
% continuous sense. sqrt(2) is used for a unitary transform and to ensure
% parseval's theorem holds.
A = exp(1j*2*pi*t(1)*df);
bttczt = conj(czt(conj(fsig),N,W,A))*df*sqrt(2);

% add a phase shift
phaseshift = exp(1j*2*pi*fmin*(0:N-1)'*dt);

% then replicate to match the columns of s11
phaseshift = repmat(phaseshift, 1, size(s11,2));

complexsig = phaseshift.*bttczt;

tsig = real(complexsig);