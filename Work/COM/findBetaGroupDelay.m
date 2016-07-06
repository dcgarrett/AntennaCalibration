function [betaTimeofFlightPeak, toa] = findBetaGroupDelay(f, S12, fcent, measLength, GRL_plot)

smoothCurve = 1;
unwrapCoeff = 2;    % default is 2


lowerF = 2.5e9;     % default is 2.5e9
upperF = 5.5e9;     % default is 5.5e9

polyOrder = 2;      % default is 2

[tg, f_tg] = getGroupDelay(f, S12, unwrapCoeff, smoothCurve, lowerF, upperF, polyOrder, GRL_plot);

if GRL_plot
    figure;
    plot(f_tg(1:end-1), tg)
    xlim([3e9 8e9])
    xlabel('Frequency (Hz)')
    ylabel('Group delay (s)')
    box on;
    grid on;
    
    c = 3e8;
    epsFromTg = (tg.*c./ measLength).^2;
    figure;
    plot(f_tg(1:end-1), epsFromTg)
    xlabel('Frequency (Hz)')
    ylabel('Permittivity from tg')
end

fcentInd = f_tg == fcent;
toa = tg(fcentInd);

betaTimeofFlightPeak = 2*pi*toa.*fcent ./ (measLength);
end