function [F, sxx, antTx, antRx] = autoImportCTI_Sxx_findAntNum(filename)
%This function opens a cti file from the network analyzer and 
%gathers the S parameters and frequencies.
%The cti file must contain s11 in (r,i) 
%
fid = fopen(filename, 'rt');
line = fgetl(fid);

while isempty(strfind(lower(line), lower('ANT_TX')))
    line = fgetl(fid); 
end

antTx = str2double(line(end-1:end));

while isempty(strfind(lower(line), lower('ANT_RX')))
    line = fgetl(fid); 
end

antRx = str2double(line(end-1:end));

while isempty(strfind(lower(line), lower('VAR Freq MAG')))
    line = fgetl(fid); 
end

spaceInd = strfind(line, ' ');
numPts = str2double(line(spaceInd(end):end));

line2 = fgetl(fid);
while isempty(strfind(lower(line2), lower('VAR_LIST_BEGIN'))) && ~strcmpi(line2, 'BEGIN')
    if strcmpi(line2, 'SEG_LIST_BEGIN')
        seg_list = fgetl(fid);
    end
    line2 = fgetl(fid);
end
%first is the list of frequencies
%A is a reused variable to grab the data
if exist('seg_list')
    space_ind = strfind(seg_list,' ');
    minF = str2double(seg_list(space_ind(1):space_ind(2)));
    maxF = str2double(seg_list(space_ind(2):space_ind(3)));
    F = linspace(minF, maxF, numPts);
else
    A = fscanf(fid, '%e', numPts);
    F = A;
    %Skip three lines for the end of last line, VAR_LIST_END and begin
    for I = 1:3
        fgetl(fid);
    end
end

%
%
%now is the start of s11
A = fscanf(fid, '%e %*1s %e', [2 numPts]);
sxx = complex(A(1,:), A(2,:));

fclose(fid);

end
