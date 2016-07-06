function [fProbe, probeDebyeEr, probeDebyeSig] = debyeDataProbe_Array(filename)

xls_perm = xlsread(filename, 4); % Sheet 4 for permittivity

fProbe = xls_perm(:,1).*1e9;
[~, W] = size(xls_perm);
probeDebyeEr = xls_perm(:,W-1);

xls_cond = xlsread(filename, 5); % Sheet 5 for conductivity
[~, W] = size(xls_cond);
probeDebyeSig = xls_cond(:, W-1);

end
