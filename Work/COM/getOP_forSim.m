function [O, P] = getOP_forSim(ThruD, ReflD, O11, P22)

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

%% 1. Find O22 = P11 (in simulation only)

O(2,2,:) = (Tm21 - Rm11) ./ (Tm21 + Rm11);
P(1,1,:) = squeeze(O(2,2,:));

O(2,1,:) = sqrt(mult_indep_dim(-Rm11,(1+squeeze(O(2,2,:)))));

O(1,2,:) = squeeze(O(2,1,:));
P(1,2,:) = squeeze(O(2,1,:));
P(2,1,:) = squeeze(O(2,1,:));


end


