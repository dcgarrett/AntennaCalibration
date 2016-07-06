function [ThruD, ReflD] = deembedO11P22(Thru, Refl, O11, P22)
% deembedO11P22
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca
%       Uses the previously determined O11 and P22 parameters to deembed
%       their effects on the Thru and Reflect measurements. Qualitatively,
%       this means removing reflections due to the transmitting antenna.

% Overview of the method:
%       1. Convert Thru, Refl, O, and P matrices to T-parameters (where O
%       and P only affect reflection, so O12=O21=P12=P21=1, O22 = 0, P11=0 in S-params)
%       2. Remove the effect of O and P with matrix division (note
%           cascading property of T-params)
%       3. Convert deembedded results back to S-parameters

% INPUTS:
%       - Thru: Measured 2x2 complex S-params for the Thru cal measurement
%       - Refl: Measured 2x2 complex S-params for the Reflect cal meas
%       - O11: Previously determined O11 parameter 
%               (using function getGateO11P22)
%       - P22: Previously determined P22 parameter 
%               (using function getGateO11P22)
% OUTPUTS:
%       - ThruD: 2x2 complex Thru parameters, with the effect of O11 and
%                   P22 removed
%       - ReflD: 2x2 complex Reflect parameters, with the effect of O11 and
%                   P22 removed

%% 1. Create O, P matrices, convert everything to T-parameters

% Create O and P matrices:
O_S = zeros(2,2,length(O11)); % S params of port 1 error box
O_S(1,2,:) = ones;
O_S(2,1,:) = ones;
O_S(1,1,:) = O11;

P_S = zeros(2,2,length(P22)); % S params of port 2 error box (note: flipped works)
P_S(1,2,:) = ones;
P_S(2,1,:) = ones;
P_S(2,2,:) = P22;


%% Do we do this to the Meas or Thru and Reflect???
%   Going with just Thru and Reflect

% Convert everything to T-params
for i = 1:length(O11)
    %T_meas(:,:,i) = S_to_T(S_meas(:,:,i));
    O_T(:,:,i) = S_to_T(O_S(:,:,i));
    P_T(:,:,i) = S_to_T(P_S(:,:,i));
    Thru_T(:,:,i) = S_to_T(Thru(:,:,i));
    Refl_T(:,:,i) = S_to_T(Refl(:,:,i));
end

% Apply deembedding to Thru and Reflect, where e.g. Thru = O * ThruD * P;
for i = 1:length(O11)
    Thru_TD(:,:,i) = ((squeeze(O_T(:,:,i)))\eye(2)) * squeeze(Thru_T(:,:,i)) * ((squeeze(P_T(:,:,i)))\eye(2));
    Refl_TD(:,:,i) = ((squeeze(O_T(:,:,i)))\eye(2)) * squeeze(Refl_T(:,:,i)) * ((squeeze(P_T(:,:,i)))\eye(2));
    %T_GateCal(:,:,i) = ((squeeze(O_T(:,:,i)))\eye(2)) * squeeze(T_meas(:,:,i)) * ((squeeze(P_T(:,:,i)))\eye(2));
end

% Convert back to S
for i = 1:length(O11)
    %S_GateCal(:,:,i) = T_to_S(T_GateCal(:,:,i));
    ThruD(:,:,i) = T_to_S(Thru_TD(:,:,i));
    ReflD(:,:,i) = T_to_S(Refl_TD(:,:,i));
end

end

