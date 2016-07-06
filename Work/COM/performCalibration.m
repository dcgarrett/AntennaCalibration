function [S_cal] = performCalibration(S_meas, O, P)

% performCalibration
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca
%   Applies GRL calibration to measured data of a MUT using previously
%   determined O and P correction matrices. This is done using T-parameters
%   due to their cascading property
% 
%   Method overview:
%       1. Convert S_meas, O, P into T-parameters
%       2. Remove the effect of O and P on S_meas using matrix division of
%           T-parameters
%       3. Convert back to S-parameters

%   INPUTS:
%       - S_meas: Measured 2x2 complex S-parameters of the material tested
%       - O: Previously determined 2x2 complex correction matrix for port 1
%       - P: Previously determined 2x2 complex correction matrix for port 2
%   OUTPUTS: 
%       - S-cal: Calibrated 2x2 complex S-parameters of the material tested
%                   Ideally correspond only to the response of the material

%% 1. Convert all S-parameters to T-parameters:

S_cal(2,2,length(S_meas)) = zeros; % Empty matrix for calibrated S

% Ensure 12 and 21 elements of O and P are nonzero:
smallNumber = 1E-8;
O_zero_ind = find(abs(O) < smallNumber);
O(O_zero_ind) = smallNumber;
P_zero_ind = find(abs(P) < smallNumber);
P(P_zero_ind) = smallNumber;

% Convert to T-params
for i = 1:length(S_meas)
    T_meas(:,:,i) = S_to_T(S_meas(:,:,i));
    O_T(:,:,i) = S_to_T(O(:,:,i));
    P_T(:,:,i) = S_to_T(P(:,:,i));
end

%% 2. Perform calibration using T-parameters:

for i = 1:length(S_meas)
    T_cal(:,:,i) = inv(squeeze(O_T(:,:,i))) * squeeze(T_meas(:,:,i)) * inv(squeeze(P_T(:,:,i)));
end

%% 3. Convert T-parameters back to S-parameters:

for i = 1:length(S_meas)
    S_cal(:,:,i) = T_to_S(T_cal(:,:,i));
end

end