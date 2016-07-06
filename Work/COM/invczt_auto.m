function [ t, timeSig ] = invczt_auto( f, S, Srow, Scolumn )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
if min(size(S)) == 1
    S_array = S;
else
    S_array = squeeze(S(Srow,Scolumn,:));
end

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


[timeSig, t, ~, ~] = inverseczt_charlotte(f, S_array, t_tsar, TSAR_handle);
end

