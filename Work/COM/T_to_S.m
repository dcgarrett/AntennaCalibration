function [S] = T_to_S(T)
% T_to_S takes a 2-port s-parameter matrix and
% converts it to a T matrix
x11 = T(1,2);
x12 = T(1,1)*T(2,2)-T(1,2)*T(2,1);
x21 = 1;
x22 = -T(2,1);
S = 1/T(2,2)*[x11 x12; x21 x22];
