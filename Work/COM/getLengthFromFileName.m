function [ length ] = getLengthFromFileName( fileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Somewhere in the filename the length is written as "XXpXXmm"
mmInd = strfind(fileName, 'mm');

numStr = fileName(mmInd-5:mmInd-1);

numStr = strrep(numStr, 'p','.');

length = str2double(numStr).*1e-3;
end

