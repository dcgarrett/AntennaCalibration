function fdata = normczt(time,tdata,freq)
% Converts from time to frequency domain and samples along a given
% frequency vector using the CZT. Normalization is complementary to inverse
% transform (inverseczt.m) in the continuous sense (unitary).
% 
% FUNCTION fdata = normczt(time,tdata,freq)
%
% Inputs:
%   - time: vector of time values
%   - tdata: time domain data sampled on time vector
%   - freq: vector of frequency values
%
% Outputs:
%   - fdata: frequency domain data sampled on frequency vector

df = freq(2) - freq(1);
dt = time(2) - time(1);
fmin = min(freq);
M = length(freq);
N = length(time);
W = exp(-1j*2*pi*dt*df);
A = exp(1j*2*pi*fmin*dt);

fdata = czt(tdata,M,W,A)*sqrt(2)*dt;