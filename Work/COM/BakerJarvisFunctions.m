function F = BakerJarvisFunctions( x, REF )
% Input functions in order to iteratively solve the Baker-Jarvis equations
% in determining complex permittivity from scattering parameters

% x consists of the estimated permittivity, propagation constant, and
% reflection coefficient
S11 = REF(1);
S21 = REF(2);
S12 = REF(3);
S22 = REF(4);

L = REF(5);

f = REF(6);

er = x(1);
%Gamma = x(2);

w = 2.*pi.*f;
c = 3e8;
hc = (c./sqrt(25))./1.8e9;
y0 = 1j.*sqrt(w.^2.*25./c^2 - (2.*pi./hc).^2); % Eccostock


y = 1j.*sqrt(w.^2.*er./c^2);
z = exp(-y.*L);
Gamma = (y0 - y) ./ (y0 + y);

F(1) = abs(S21) - abs( (z.*(1-Gamma.^2))./(1-z.^2.*Gamma.^2));
F(2) = abs(S11) - abs( (Gamma.*(1-z.^2))./(1-z.^2.*Gamma.^2));
F(3) = (S11.*S22./(S12.*S21)) - (((1 - er).^2) ./ (4.*er)) .* (sinh(y.*L)).^2;
F(4) = S21.*S12 - S11.*S22 - ( (z.^2 - Gamma.^2) ./ (1 - z.^2.*Gamma.^2));


end

