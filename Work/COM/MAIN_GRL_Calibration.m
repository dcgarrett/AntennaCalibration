function [f, epsEst, sigEst, S_meas, S_cal, O, P, toa, aEst, bEst] = MAIN_GRL_Calibration(S_filePath, S_fileName, measLength, simOrMeas, varargin)
%% GRL Calibration
%   by David Garrett, May 2016
%       dgarrett@ucalgary.ca

% Overview of the method
%     1. Gate in the time domain - obtain O11 and P22
%           Deembed this from Measured, Thru, and Reflect Data
%     2. Determine correction matrices O and P from the calibration measurements
%     3. Perform calibration 
%     4. From calibrated data, estimate dielectric properties

% INPUTS
%     - S_filePath: File path of the CTI file to be calibrated/Thru Reflect
%     - S_fileName: File name of the CTI file to be calibrated
%     - measLength: Separation distance of the measurement in m, filled with the
%                   MUT
%     - simOrMeas: 1 for simulated data, 0 for measured data (affects the 
%                    number of data points etc - change below if necessary)
%       - varargin: 'thresh'
%                   'fcent'
%                   'bw'
%                   'GRL_plot'
%                   'DP_plot'
%                   'addNoise'
%                   'snr'
%                   'PML_O11P22' - boolean, whether to use PML for O11. Only
%                       valid in simulation


% OUTPUTS
%     - f: Array of frequency values
%     - epsEst: estimated real permittivity using calibrated data
%     - sigEst: estimated conductivity using calibrated data
%     - S_cal: calibrated S-parameters of input file
%     - S_meas: uncalibrated S-parameters of input file
%     - O: Port 1 calibration matrix (in S-params)
%     - P: Port 2 calibration matrix (in S-params)


%% 0. Define user parameters, import data, parse inputs
set(0,'defaultLineLineWidth', 1)
set(0,'DefaultAxesFontSize',12)

p = inputParser;
defaultThresh = 0.5;
defaultFcent = 5e9;
defaultBW = 0.5e9;
defaultGRL_plot = 0;
defaultDP_plot = 1;
defaultAddNoise = 0;
defaultSNR = 10;
defaultPML_O11P22 = 0;
defaultXlim = [3e9 8e9];
defaultSrc = '1x1';
defaultErrorMUTS21abs = 0;
defaultErrorMUTS21arg = 0;
defaultErrorMUTS11abs = 0;
defaultErrorMUTS11arg = 0;
defaultErrorThruS21abs = 0;
defaultErrorThruS21arg = 0;
defaultErrorReflS21abs = 0;
defaultErrorReflS21arg = 0;
defaultErrorThruS11abs = 0;
defaultErrorThruS11arg = 0;
defaultErrorReflS11abs = 0;
defaultErrorReflS11arg = 0;
defaultErrorS_value = 0;
defaultErrorS_param = [];

addRequired(p,'S_filePath');
addRequired(p, 'S_fileName');
addRequired(p, 'measLength', @isnumeric);
addRequired(p, 'simOrMeas', @isnumeric);
addOptional(p, 'thresh', defaultThresh, @isnumeric) % For time gating to get O11 and P22:
addOptional(p, 'fcent', defaultFcent, @isnumeric) % center frequency for beta shifting. default is 5 GHz
addOptional(p, 'bw', defaultBW, @isnumeric) % bandwidth for beta shifting. default is 0.5 GHz
addOptional(p, 'GRL_plot', defaultGRL_plot, @isnumeric)  % plot steps along the GRL processing
addOptional(p, 'DP_plot', defaultDP_plot, @isnumeric) % plot the estimated dielectric properties
addOptional(p, 'addNoise', defaultAddNoise, @isnumeric)
addOptional(p, 'snr', defaultSNR, @isnumeric)
addOptional(p, 'PML_O11P22', defaultPML_O11P22, @isnumeric)
addOptional(p, 'xlim', defaultXlim, @isnumeric)
addOptional(p, 'source', defaultSrc)
addOptional(p, 'errorMUTS21abs', defaultErrorMUTS21abs)
addOptional(p, 'errorMUTS21arg', defaultErrorMUTS21arg)
addOptional(p, 'errorMUTS11abs', defaultErrorMUTS11abs)
addOptional(p, 'errorMUTS11arg', defaultErrorMUTS11arg)
addOptional(p, 'errorThruS21abs', defaultErrorThruS21abs)
addOptional(p, 'errorThruS21arg', defaultErrorThruS21arg)
addOptional(p, 'errorReflS21abs', defaultErrorReflS21abs)
addOptional(p, 'errorReflS21arg', defaultErrorReflS21arg)
addOptional(p, 'errorThruS11abs', defaultErrorThruS11abs)
addOptional(p, 'errorThruS11arg', defaultErrorThruS11arg)
addOptional(p, 'errorReflS11abs', defaultErrorReflS11abs)
addOptional(p, 'errorReflS11arg', defaultErrorReflS11arg)

parse(p, S_filePath, S_fileName, measLength, simOrMeas, varargin{:} );

% Import necessary files
[f, S_meas, Thru, Refl] = importForGRL(S_filePath, S_fileName, simOrMeas, p.Results.source);

% adjust for added error if desired
[S_meas, Thru, Refl] = adjust_for_added_error(S_meas, Thru, Refl, p);

% Determine if single antenna or 5x5 scan
if strcmpi(p.Results.source, '1X1')
    numS = 1;
elseif strcmpi(p.Results.source, '5X5')
    numS = 5;
end

if strcmpi(p.Results.source,'5X5')
        S_5x5 = S_meas; % Temporary variable
        Thru_5x5 = Thru;
        Refl_5x5 = Refl;
end

for m = 1:numS % Step through for each antenna combination
    
    % Create variables from the struct for S_meas etc
    if strcmpi(p.Results.source,'5X5')
        S_meas = S_5x5(m).S; % Temporary variable
        Thru = Thru_5x5(m).S; % Temporary variable
        Refl = Refl_5x5(m).S; % Temporary variable
    end
    % Option to add noise to the calibration measurements (used for method
    % analysis)    
    if p.Results.addNoise
        Thru = GRL_addNoise(Thru, p.Results.snr);
        Refl = GRL_addNoise(Refl, p.Results.snr);
        S_meas = GRL_addNoise(S_meas, p.Results.snr);
    end
    
    
    %% 1. Perform Gating in the time domain to obtain O11 and P22
    % Obtain O11 and P22:
    if simOrMeas && p.Results.PML_O11P22 % Option in simulation to get O11 P22 from PML
        PML_fileName = 'PML_S11.cit';
        [~, O11] = autoImportCTI_S11(fullfile(S_filePath, PML_fileName));
        [~, P22] = autoImportCTI_S11(fullfile(S_filePath, PML_fileName));
    else
        [O11, P22] = getGateO11P22(Thru, Refl, p.Results.thresh, f, 1, p.Results.GRL_plot);
    end
    
    % Deembed O11 and P22 from the original calibration S-params:
    [ThruD, ReflD] = deembedO11P22(Thru, Refl, O11, P22);
    
    %% 2. Determine remaining O and P from calibration measurements
    reflection_findOP = 1;
    if reflection_findOP
        [O, P] = getOP(ThruD, ReflD, O11, P22,f);
    else
        [O, P] = getOP_forSim(ThruD, ReflD, O11, P22);
    end
    
    %% 3. Perform calibration using O and P on measured S-params
    S_cal = performCalibration(S_meas, O, P);
    
    %% 4. Estimate dielectric properties from calibrated S-params
    betaTime1GroupDelay0 = 0;
    [epsEst, sigEst, toa, aEst, bEst] = getDielectricProperties(S_cal, f, measLength, p.Results.fcent, p.Results.bw, betaTime1GroupDelay0, p.Results.GRL_plot);
%     [epsEstNRW, sigEstNRW] = getDielectricPropertiesNRW(S_cal, f, measLength, p.Results.fcent, p.Results.bw, p.Results.GRL_plot);
    
    %% A. Plot permittivity and conductivity if desired
    if p.Results.DP_plot
        plotDPs(f, epsEst, sigEst, p.Results.xlim)
    end
end
    
end
