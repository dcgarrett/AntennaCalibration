function F = BakerJarvisFunctions_1Eqn( x, REF )
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

B = REF(7);

w = 2.*pi.*f;
e0 = 8.54188e-12;
mu0 = pi.*4e-7;
eAnt = 24.5;
a = 11.7e-3;
p11 = 1.841;
hc = 2*pi / (p11*a);

er = x(1);

yAnt = 1j*sqrt(w^2 * eAnt * e0 * mu0); % - (2*pi/hc)^2);

c = 3e8;
y = 1j.*sqrt(w.^2.*er./c^2);

z = exp(-y.*L);
Gamma = (yAnt - y) ./ (yAnt + y);


F(1) = 0.5*( (S12 + S21) + B*(S11 + S22) ) - ( z*(1 - Gamma.^2) + B*Gamma*(1 - z^2) )./(1- z^2 * Gamma.^2);
F(2) = Gamma - (yAnt - y) ./ (yAnt + y);
F(3) = y - 1j.*sqrt(w.^2.*er./c^2);

end

