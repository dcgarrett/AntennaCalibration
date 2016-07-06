function [epsilon_r, sigma] = PermittivityToEpsilonSigma(f, epsilon)
%PermittivityToEpsilonSigma Convert complex permittivity to e_r, sigma
%   Convert the complex relative permittivity to real relative
%   permittivity and real conductivity.
%
%   Inputs:
%       1xN float       f           Linear frequency
%       1xN complex     epsilon     Complex relative permittivity
%
%   Outputs:
%       1xN float       epsilon_r   Real relative permittivity
%       1xN float       sigma       Real conducitivity
%
%   History:
%       2015.07.23  Bryce Besler    Created
%
%   Notes:
%       - None

e_0  = 1/(36*pi)*1e-9;

epsilon_r = real(epsilon);
sigma = -1 * imag(epsilon) .* 2 .* pi .* f .* e_0;
end

