function [T] = S_to_T(S)
% S_to_T takes a 2-port T-parameter matrix and
% converts it to an S matrix
x11 = S(1,2)*S(2,1)-S(1,1)*S(2,2);
x12 = S(1,1);
x21 = -S(2,2);
x22 = 1;
T = 1/S(2,1)*[x11 x12; x21 x22];
