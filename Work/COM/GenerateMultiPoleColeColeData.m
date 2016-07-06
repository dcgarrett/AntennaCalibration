function [e_r, sigma] = GenerateMultiPoleColeColeData(f, e_inf, sigma_i, e_s, tau, alpha)
%GenerateMultiPoleColeColeData Generate data from multipole Cole-Cole model
%   Given parameters for a Cole-Cole model of the dielectric properties of
%   a biological tissue and a frequency vector, return the relative
%   permittivity and conductivity that fit the model for that frequency 
%   range.
%
%   Inputs:
%       1xN float   f       Vector of linear frequency points to be assessed
%       float       e_inf   Relative permittivity at high frequencies
%       float       sigma_i Static ionic conductivity
%       1xM float   e_s     Relative permittivity at low frequencies
%       1xM float   tau     Relaxation time
%       1xM float   alpha   Parameter for broadening of the dispersion
%
%   Outputs:
%       1xN float   e_r     Relative permittivity at each frequency point
%       1XN float   sigma   Conductivity at each frequency point
%
%   History:
%       2015.08.17  Bryce Besler    Created 
%
%   Notes:
%       - Based on original code at \\136.159.100.80\tsar\Software\TissueMeasurement\TISSUE MEASUREMENT TOOLBOX\GenerateCondEr.m
%       - Equations used:
%           e = e' - je'' = e' - j sigma/w
%             = e_inf + (e_s - e_inf) / (1 + (j*2*pi*f*tau)^(1-alpha)) + sigma_i / (j*2*pi*f*e_0)
%       - All calculations are done with relative permittivity

% Load constants and Generate our angular frequency vector
e_0 = 1/(36*pi)*1e-9;
w = 2*pi*f;

% Perform calculation and convert to e_r and sigma
delta_e = e_s - ones(size(e_s)) .* e_inf;
sum = zeros(size(w));
for i = 1:length(delta_e)
    sum = sum + delta_e(i) ./ (1 + (1j.*w.*tau(i)).^(1-alpha(i)));
end

epsilon     = e_inf + sigma_i ./ (1j.*w.*e_0) + sum;
[e_r, sigma] = PermittivityToEpsilonSigma(f, epsilon);

end

