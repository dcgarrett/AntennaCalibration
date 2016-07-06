function [ alpha, beta ] = getAlphaBeta( f, er, sig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
w = 2.*pi.*f;
mu0 = pi*4e-7;
e0 = 8.85e-12;

alpha = w .* sqrt( (mu0.*e0.*er./2) .* ( sqrt(1 + (sig ./ (w.*er.*e0)).^2) - 1));
beta  = w .* sqrt( (mu0.*e0.*er./2) .* ( sqrt(1 + (sig ./ (w.*er.*e0)).^2) + 1));

end

