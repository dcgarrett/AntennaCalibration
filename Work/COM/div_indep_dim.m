function [ c ] = div_indep_dim( a, b )
% mult_indep_dim
%   Multiplies two arrays element-wise where one might need to be transposed
%   Avoids annoying errors of matrix dimensions not agreeing
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca

% INPUTS
%   - a and b: the two arrays to be multiplied element-wise

% OUTPUTS
%   - c: the resulting product

dimA = size(a);
dimB = size(b);

if dimA == dimB
    c = a ./ b;
elseif dimA == fliplr(dimB)
    c = a.' ./ b;
else
    errordlg('Error: Array lengths are not the same')
end


end

