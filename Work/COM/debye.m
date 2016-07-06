function [er,cond] = debye(freq,erstat,erinf,sigstat,tau)
% FUNCTION erc = debye(freq,erstat,erinf,sigstat,tau)
% Calculates frequency complex relative permittivity using a single pole
% Debye model. Input parameters are:
%
% freq - the frequencies at which to calculate properties
% erstat - the static relative permittivity
% erinf - the relative permittivity at infinity
% sigstat - the static conductivity
% tau - the relaxation time
%

e0 = 8.854187817620e-12;
erc = erinf + (erstat - erinf)./(1 + 1j*2*pi*freq*tau)...
    + sigstat./(1j*2*pi*freq*e0);

er = real(erc);
cond = -imag(erc)*2*pi.*freq*e0;