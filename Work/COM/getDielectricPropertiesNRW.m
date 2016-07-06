function [epsEst, sigEst] = getDielectricPropertiesNRW(S_cal, f, measLength, fcent, bw, GRL_plot)

% Applies the Nicolson-Ross-Weir method to estimate dielectric properties
%   "Automatic Measurement of Complex Dielectric Constant and Permeability at Microwave Frequencies


S11 = squeeze(S_cal(1,1,:));
S12 = squeeze(S_cal(1,2,:));
S21 = squeeze(S_cal(2,1,:));
S22 = squeeze(S_cal(2,2,:));
%% 1. Estimate gamma

chi = (S11.^2 - S21.^2 + 1) ./ (2.*S11);
gamma1 = chi + sqrt(chi.^2 - 1);
gamma2 = chi - sqrt(chi.^2 - 1);

%% 2. Estimate propagation factor

P1 = (S11 + S21 - gamma1) ./ (1 - (S11 + S21).*gamma1);
P2 = (S11 + S21 - gamma2) ./ (1 - (S11 + S21).*gamma2);



%% Chalapat 2010

A = (S11.*S22) ./ (S21 .* S12);
B = (S21.*S12 - S11.*S22);

gammaSqr1 = (-A.*(1-B.^2) + (1 - B).^2) ./ (2.*A.*B) + sqrt(-4.*A.^2.*B.^2 + (A.*(1+B.^2) - (1 - B).^2).^2) ./ (2.*A.*B);
gammaSqr2 = (-A.*(1-B.^2) + (1 - B).^2) ./ (2.*A.*B) - sqrt(-4.*A.^2.*B.^2 + (A.*(1+B.^2) - (1 - B).^2).^2) ./ (2.*A.*B);

P_ch1 = S21 .* (1+gammaSqr1) ./ (1 + B.*gammaSqr1);
P_ch2 = S21 .* (1+gammaSqr2) ./ (1 + B.*gammaSqr2);


% Compare the methods

figure;
hold on;
plot(f, mag2db(abs(P1)))
plot(f, mag2db(abs(P2)),'-')
%plot(f, mag2db(abs(P_ch1)),'r')
plot(f, mag2db(abs(P_ch2)),'-r')
plot(f, mag2db(abs(S12)),'g')
plot(f, mag2db(abs(S21)),'g')
xlabel('Frequency (Hz)');
ylabel('Transmission magnitude')


%% Vincente 2011

%% Luukonen 2011
% Same gamma as step 1.
figure;
hold on;
plot(f, mag2db(abs(gamma1)))
plot(f, mag2db(abs(gamma2)),'r')

Gamma=gamma1;
Gamma(abs(gamma1)>1) = gamma2(abs(gamma1)>1);

e0 = 8.85e-12;
mu0 = (4e-7)*pi;
eta0 = sqrt(mu0./(24*e0));
eta = eta0 .* (1+Gamma)./(1-Gamma);
erEta = mu0 ./ (eta.^2 .* e0);% )sqrt(eta);

expNegGammaD = (S11 + S21 - Gamma) ./ (1-(S11 + S21) .*Gamma);

figure;
plot(f, real(erEta))
xlim([3e9 8e9])


figure;
hold on;
plot(f, mag2db(abs(gamma1)))
plot(f, mag2db(abs(gamma2)),'r')
plot(f, mag2db(abs(Gamma)),'g')
plot(f, mag2db(abs(S11)),'k')
title('Comparing Gammas')


figure;
hold on;
plot(f, mag2db(abs(expNegGammaD)))
plot(f, mag2db(abs(S21)),'r')
title('e-gammaD and S21')

figure;
hold on;
plot(f, angle(expNegGammaD))
plot(f, angle(S21),'r')
title('Angle of e-gammaD and S21')

z = sqrt( ((1+S11).^2 - S21.^2) ./ ( (1-S11).^2 - S21.^2));

expGammaD = (1-S11.^2+S21.^2)./(2.*S21) + 2.*S11./((z - (1./z)) .* S21);

figure;
hold on;
plot(f, mag2db(abs(expNegGammaD)))
plot(f, mag2db(abs(1./expGammaD)),'r')
title('neg and pos expGammaD')

phi0 = angle(expGammaD(1));
argDiv = (angle(expGammaD(2:end) ./ expGammaD(1:end-1)));
phi = [phi0; phi0 + cumsum(argDiv)];

figure;
plot(f, phi)

for m = 1:10
    phiM(m,:) = phi + 2*pi*m;
end
    
figure;
hold on;
plot(f, phiM)

w = 2.*pi.*f;
d = measLength;
c = 3e8;

for m = 1:10;
    eps(m,:) = (- (c./(w.*d) .* (log(abs(expGammaD)) + 1j.*(phi+2*pi*m))));
end



figure;
plot(f, real(eps))

end