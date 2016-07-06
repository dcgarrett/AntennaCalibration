function [f, S_meas, Thru, Refl] = importForGRL(S_filePath, S_fileName, simOrMeas, source)

% importForGRL
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca

% Imports the required CTI data for GRL Calibration. In the folder
% S_filePath, ensure there are files named Thru.cti and Reflect.cti
% corresponding to the calibration measurements.

% INPUTS:
%   - S_filePath: Path to the location of the measured data, including the
%       calibration procedures
%   - S_fileName: Name of the file for the measured S-params of the MUT
%   - simOrMeas: True for simulated, false for measured. Used for proper
%       importing of the CTI files
%   - source: From either the '1x1' or '5x5' transmission system
% OUTPUTS:
%   - f: Array of frequency values in Hz
%   - S_meas: Measured 2x2 complex S-params of the MUT
%   - Thru: Measured 2x2 complex S-params of the Thru procedure
%   - Refl: Measured 2x2 complex S-params of the Reflect procedure

%% 
smallNumber = 1e-9; % Used to replace 0s so following steps don't blow up

% File extension is different for sim and meas for some reason
if simOrMeas
    if strcmpi(S_fileName(end-3:end), '.MAT')
        ext = '.mat';
    else
        ext = '.cit';
    end
else
    ext = '.cti';
end

if strfind(S_fileName, '_disp')
    dispAdd = '_disp';
    disp('Processing with dispersive antenna filling')
else
    dispAdd = [];
end

measFileName = fullfile(S_filePath,S_fileName);
thruFileName = fullfile(S_filePath, strcat('Thru',dispAdd,ext));
reflFileName = fullfile(S_filePath, strcat('Reflect',dispAdd,ext));

thruFileName5x5 = 'X:\Experiments\Test\TransmissionMeasurements2\20160511_GRL_5x5\Thru\Signal'; % Permanent?
reflFileName5x5 = 'X:\Experiments\Test\TransmissionMeasurements2\20160511_GRL_5x5\Reflect\Signal';


if strcmpi(source, '1X1')
    if strcmpi(S_fileName(end-3:end), '.MAT')
        load(measFileName);
        S_meas = zeros(2,2,length(S11));
        S_meas(1,1,:) = S11;
        S_meas(1,2,:) = S21;
        S_meas(2,1,:) = S21;
        S_meas(2,2,:) = S11;
        load(thruFileName);
        Thru(1,1,:) = S11;
        Thru(1,2,:) = S21;
        Thru(2,1,:) = S21;
        Thru(2,2,:) = S11;
        load(reflFileName)
        Refl(1,1,:) = S11;
        Refl(1,2,:) = S21;
        Refl(2,1,:) = S21;
        Refl(2,2,:) = S11;
    else
        [f, S_meas] = autoImportCTI(measFileName);
        [~, Thru] = autoImportCTI(thruFileName);
        [~, Refl] = autoImportCTI(reflFileName);
    end
elseif strcmpi(source, '5X5')
        [f, S_meas] = autoImportCTI_5x5(S_filePath); % 5 element struct
        [~, Thru] = autoImportCTI_5x5(thruFileName5x5);
        [~, Refl] = autoImportCTI_5x5(reflFileName5x5);
end



% In simulation there is a problem importing S21 and S12 of Reflect since
% it becomes Nan, so we need to replace with 0.
if strcmpi(source, '1X1')
    nanInd = isnan(Refl);
    if any(any(any(nanInd)))
        Refl(nanInd) = 1E-9;
        disp(['All Nan in ' reflFileName 'file converted to 1E-9'])
    end
    zeroInd = find(Refl==0);
    if any(any(any(zeroInd)))
        Refl(zeroInd) = 1E-9;
        disp(['All 0s in ' reflFileName 'file converted to 1E-9'])
    end
end