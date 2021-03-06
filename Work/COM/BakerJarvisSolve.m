function [ eEst_BJ, sigEst_BJ, fInd ] = BakerJarvisSolve( S_cal, f, measLength )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fInd = find(f > 3e9 & f < 8e9);

for i=1:length(fInd)

    REF(1) = squeeze(S_cal(1,1,fInd(i)));
    REF(2) = squeeze(S_cal(2,1,fInd(i)));
    REF(3) = squeeze(S_cal(1,2,fInd(i)));
    REF(4) = squeeze(S_cal(2,2,fInd(i)));
    
    REF(5) = measLength;
    
    REF(6) = f(fInd(i));
    
    x0 = [30];
    
    func = @(x) BakerJarvisFunctions(x, REF);
    
    [out(i,:), fval] = fsolve(func, x0);
end

e0 = 8.85e-12;
w = 2.*pi.*f(fInd);

eEst_BJ = real(out);
sigEst_BJ = -imag(out) .* e0 .* w;

end

