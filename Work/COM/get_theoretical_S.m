function [ S ] = get_theoretical_S( f, d, material )
% get_theoretical_S:
%   inputs -    f: frequency
%               d: antenna separation distance (m)
%               material: choice of material between the antennas, as
%                   described in the function material_database
%   outputs -   S: theoretical S-parameters of this configuration
% Assumes initial material is Eccostock, non dispersive
% Assumes plane wave!

transposeF = 0;
if transposeF
    f = f.';
end

% Constants:
eps0 = 8.85E-12;
mu0 = pi*4E-7;
w = 2 .* pi .* f;

% Propagation constant of medium 1 (Nahanni)
er1 = 24.5;
sig1 = 0.1;
propConst1 = 1j .* w .* sqrt(mu0*er1*eps0) .* sqrt(1 - 1j*(sig1./(w.*er1*eps0)));

% Impedance of medium 1 (Nahanni)
n1 = 1j .* w .* mu0 ./ propConst1;

% Get material properties of medium:
[er2, sig2] = material_database( material, f);
        

% Find propagation constant of medium 2:
propConst2 = 1j .* w .* sqrt(mu0*er2*eps0) .* sqrt(1 - 1j*(sig2./(w.*er2*eps0)));

% Find impedance of medium 2:
n2 = 1j .* w .* mu0 ./ propConst2;

% ideal S11 (using only first reflection):
R1 = (n2 - n1) ./ (n1 + n2);

% ideal S21 (S12): 
T1 = 1 + R1;

R2 = (n1 - n2) ./ (n1 + n2);
T2 = 1+ R2;

SignalIncOnRx = T1 .* (exp(-1 .* propConst2 .* d));

S21 = T1 .* (exp(-1 .* propConst2 .* d)) .* T2;

% Account for reflection at aperture of Rx antenna:
S11 = R1 + SignalIncOnRx .* R2 .* exp(-1 .* propConst2 .* d) .* T2;


% without transmission coefficient
S21 = (exp(-1 .* propConst2 .* d));



% Plot permittivity and conductivity:
% figure;
% hold on;
% plot(f, er2)
% plot(f, sig2,'r')
% legend('permittivity','conductivity')

S = zeros(2,2,length(f));
S(1,1,:) = S11;
S(1,2,:) = S21;
S(2,1,:) = S21;
S(2,2,:) = S11;

end

