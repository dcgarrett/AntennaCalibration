function F = testFunction( xIn, REF )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

z = REF;

x = xIn(1);
y = xIn(2);

F(1) = x.^2 - y - 5 -z;
F(2) = sqrt(x.^2 + y.^2 + z.^2) - 5;


end

