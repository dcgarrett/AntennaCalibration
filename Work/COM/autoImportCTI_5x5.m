function [F, S_5x5_full] = autoImportCTI_5x5(filePath)
%% autoImportCTI_5x5
% Imports CTI files created from the 5x5 transmission system
% These are recorded in individual files for each of the S-params
% They are arranged according to transmit/receive antennas

%% 
% Go through the folder, identify files which correspond to aligned
% antennas, label them according to which antenna.

%% 1. Get folder contents
dirContents = dir(filePath);
numSig = length(dirContents) - 2;

% Create struct to contain all values
S_5x5 = struct('S',[],'f',[],'AntTx',[],'AntRx',[]);
S_5x5_full = S_5x5;

%% 2. Scan through sequentially, recording antenna number etc
for i = 1:numSig
    
    numStr = sprintf('%3.3d',i);
    fileName = strcat('Signal', numStr, '.cti');
    fullFileName = fullfile(filePath, fileName);
    [F, Sxx, antTx, antRx] = autoImportCTI_Sxx_findAntNum(fullFileName);
    S_5x5(i).S = Sxx;
    S_5x5(i).f = F;
    S_5x5(i).AntTx = antTx;
    S_5x5(i).AntRx = antRx;
    
%     figure;
%     plot(mag2db(abs(S_5x5(i).S)))
    
end

%% 3. Organize into meaningful data
% Need to know which antennas align!
% Define element numbers:
% 1. 12-6
% 2. 11-7
% 3. 10-3
% 4. 9-4
% 5. 8-5 
matching_ant = [12 6; 11 7; 10 3; 9 4; 8 5];

for i = 1:5
    tx_ant = matching_ant(i,1);
    rx_ant = matching_ant(i,2);
    for j = 1:numSig
        if S_5x5(j).AntTx == tx_ant
            if S_5x5(j).AntRx == tx_ant % S11 meas
                S(1,1,:) = S_5x5(j).S;
            end
            if S_5x5(j).AntRx == rx_ant % S21 meas
                S(2,1,:) = S_5x5(j).S;
            end
        elseif S_5x5(j).AntTx == rx_ant
            if S_5x5(j).AntRx == rx_ant % S22 meas
                S(2,2,:) = S_5x5(j).S;
            end
            if S_5x5(j).AntRx == tx_ant % S12 meas
                S(1,2,:) = S_5x5(j).S;
            end
        end
    end
    
    S_5x5_full(i).S = S;
    S_5x5_full(i).AntTx = tx_ant;
    S_5x5_full(i).AntRx = rx_ant;
    S_5x5_full(i).f = F;
end




end