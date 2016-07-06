function [fProbe, probeEr, probeSig] = DataProbe_Array(filename)

xls_perm = xlsread(filename, 4); % Sheet 4 for permittivity

fProbe = xls_perm(:,1).*1e9;
probeEr = xls_perm(:,2);

xls_cond = xlsread(filename, 5); % Sheet 5 for conductivity
probeSig = xls_cond(:, 2);

end
