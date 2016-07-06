function [ tg, f_tg ] = getGroupDelay( f, S21, unwrapCoeff, smoothCurve, lowerF, upperF, polyOrder, GRL_plot )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

S21Angle = angle(S21);
S21Phase = unwrap(S21Angle.*unwrapCoeff)./unwrapCoeff;

if smoothCurve
    S21PhaseNotSmooth = S21Phase;
    %S21Phase = smooth(S21Phase,'sgolay');
    %S21Phase = spline(f, S21Phase,f);
    
    polyInd = find(f > lowerF & f < upperF);
    p = polyfit(f(polyInd),S21Phase(polyInd),polyOrder);
    S21Phase = polyval(p, f(polyInd));
    
    if GRL_plot
        figure;
        hold on;
        plot(f(polyInd), S21Phase)
        plot(f, S21PhaseNotSmooth,'r')
        xlim([3e9 8e9])
        xlabel('Frequency (Hz)')
        ylabel('S21 unwrapped phase')
        legend('Polynomial fit','Unwrapped phase')
        grid on;
        box on;
    end
    
    f_tg = f(polyInd);
else
    if GRL_plot
        figure;
        hold on;
        plot(f, S21Phase)
    end
end



w = 2.*pi.*f_tg;
dw = w(2) - w(1);
tg = -diff(S21Phase)/dw;

end

