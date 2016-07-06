function [F, S] = autoImportCTI(filename)
%This function opens a cti file from the network analyzer and 
%gathers the S parameters and frequencies.
%The cti file must contain all of s11, s21, s12, s22 in (r,i) 
%
fid = fopen(filename, 'rt');
line = fgetl(fid);
while isempty(strfind(lower(line), lower('VAR FREQ MAG')))
    line = fgetl(fid); 
end
letterInd = isletter(line) + isspace(line);
line(find(letterInd)) = [];
numPts = str2double(line);
    
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
s11 = complex(A(1,:), A(2,:));
%Skip three lines for the end of last line, END and begin
for I = 1:3
    fgetl(fid);
end
%
%
%now is the start of s21
A = fscanf(fid, '%e %*1s %e', [2 numPts]);
s21 = complex(A(1,:), A(2,:));
%Skip three lines for the end of last line VAR_LIST_END and begin
for I = 1:3
    fgetl(fid);
end
%
%
%now is the start of s12
A = fscanf(fid, '%e %*1s %e', [2 numPts]);
s12 = complex(A(1,:), A(2,:));
%Skip three lines for the end of last line VAR_LIST_END and begin
for I = 1:3
    fgetl(fid);
end
%
%
%now is the start of s22
A = fscanf(fid, '%e %*1s %e', [2 numPts]);
s22 = complex(A(1,:), A(2,:));
fclose(fid);
%
%
for I=1:numPts
    S(1,1,I) = s11(I);
    S(1,2,I) = s12(I);
    S(2,1,I) = s21(I);
    S(2,2,I) = s22(I);
end
