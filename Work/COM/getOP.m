function [O, P] = getOP(ThruD, ReflD, O11, P22,f)

% getOP
%   by David Garrett, May 2016
%   dgarrett@ucalgary.ca
%   Uses the deembedded Thru and Reflect calibration procedures in order to
%   determine the remaining O and P parameters.

%   Overview of the method:
%       1. Solve for O22
%       2. 
%       3. 
%       4.
%       5.

% INPUTS:
%       - ThruD: The 2x2 complex S-params of the Thru calibration
%       measurement after undergoing deemmbedding from O11/P22 using the
%       function deembedO11P22
%       - ReflD: The 2x2 complex S-params of the Reflect calibration
%       measurement after undergoing deemmbedding from O11/P22 using the
%       function deembedO11P22
%       - O11: Previously determined using function getGateO11P22. Included
%       here only to complete the O and P matrices
%       - O11: Previously determined using function getGateO11P22. Included
%       here only to complete the O and P matrices

% OUTPUTS:
%       - O: 2x2 complex correction matrix for the antenna at port 1
%       - P: 2x2 complex correction matrix for the antenna at port 2 

%% 0. Prepare matrices for easier processing

% Create O and P matrices to be solved for
O = zeros(2,2,length(O11));
P = zeros(2,2,length(P22));

% Assign gate cal to O and P:
O(1,1,:) = O11;
P(2,2,:) = P22;

%Create variables for reflect and line reflections for easy access
% (note we don't need transmission coefficients for the Refl measurements)
% Reflect
Rm11 = squeeze(ReflD(1,1,:)).';
Rm22 = squeeze(ReflD(2,2,:)).';

% Thru
Tm11 = squeeze(ThruD(1,1,:)).';
Tm22 = squeeze(ThruD(2,2,:)).';
Tm12 = squeeze(ThruD(1,2,:)).';
Tm21 = squeeze(ThruD(2,1,:)).';

% Parameters for the Thru measurement: Ideally would be perfect
% transmission (note these variables are left in in case the user would
% prefer to replace the Thru measurement with a Line, where the ideal
% transmission would involve some amplitude phase change according to the propagation
% constant gamma
L12 = 1;
L21 = 1;

%% 1. Find O22
% Quadratic formula in form ax^2 + bx + c = 0
% First find the coefficients a,b,c:
a = Rm22 .* (L12 .* L21).^2 .* (Rm11 - Tm11);
b = Rm11 .* Rm22 .* (L21 .* L12).^2 - Tm11 .* Rm22 .* L21.*L12 + Tm22 .* Rm11 .* L21.*L12;
c = Tm22 .* Rm11 .* L12 .* L21;

% Find the two possible solutions for each frequency according to the quadratic equation:
O22 = zeros(length(O11),2);
for i = 1:length(O11)
    O22(i,1) = (-1 * b(i) + sqrt(b(i)^2 - 4*a(i)*c(i))) / (2*a(i)); % First solution
    O22(i,2) = (-1 * b(i) - sqrt(b(i)^2 - 4*a(i)*c(i))) / (2*a(i)); % Second solution
end

% 3.2 Choose which solution from the quadratic to use:
% since abs(O22) < 1:
% First sort the two solutions into the higher and lower abs values
for i=1:length(O11)
    if (abs(O22(i,1)) > abs(O22(i,2)))
        hiO22(i) = O22(i,1);
        loO22(i) = O22(i,2);
    else
        hiO22(i) = O22(i,2);
        loO22(i) = O22(i,1);
    end
end

% figure;
% hold on;
% plot(f, mag2db(abs(hiO22)),'--')
% plot(f, mag2db(abs(loO22)),'r')
% xlabel('Frequency (Hz)')
% ylabel('Magnitude (dB)')
% legend('Discarded solution','Used solution')
% xlim([3e9 8e9])
% box on;

% O22 can't == 1, or there are problems down the line with T-params
% Even if this means choosing a value greater than one for some frequencies
for i=1:length(O11)
    flea = 1e-8;
    if abs(abs(loO22(i)) - 1) < flea % Make sure the chosen solution is not equal to 1
        loO22(i) = hiO22(i);
    end
end

O(2,2,:) = loO22;

%% 2. Solve for the remaining parameters easily

% Solve for P11:
P(1,1,:) = -1 .* Tm11 ./ (squeeze(O(2,2,:)).' .* (Rm11.*L12.*L21 - Tm11.*L12.*L21) + Rm11.*L12.*L21);

% Solve for O21O12 and P21P12
O21O12 = -1 .* Rm11 .* (1 + squeeze(O(2,2,:))).';
P21P12 = -1 .* Rm22 .* (1 + squeeze(P(1,1,:))).';

O(1,2,:) = sqrt(O21O12);
O(2,1,:) = sqrt(O21O12);

P(1,2,:) = sqrt(P21P12);
P(2,1,:) = sqrt(P21P12);

end


