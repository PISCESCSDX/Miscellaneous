function [data,time] = readbin(fname)
%==========================================================================
%function [data,time] = readbin(fname)
%--------------------------------------------------------------------------
% READBIN reads data stored in binary file of a 16 bit resolution. 
% Save binary data using SAVEBIN.
%--------------------------------------------------------------------------
%INPUT
%  fname: string of filename
%OUTPUT
%  data: double of binary saved matrix
%  time: double of time axis
%--------------------------------------------------------------------------
%EXAMPLE
%  [A,tt] = readbin('cou0151.bin');
%==========================================================================

% read in procedure
fr = fopen(fname, 'r');
% read main data from file
channels = fread(fr, 1, 'uint16');
 tlength = fread(fr, 1, 'uint32');
timestep = fread(fr, 1, 'double');
 datamin = fread(fr, 1, 'double');
datastep = fread(fr, 1, 'double');
data = zeros(tlength,channels);
% read datamatrix from file
for i=1:channels
  data(:,i) = fread(fr, tlength, 'int16');
end
fclose(fr);


% convert binary data back to double data
data = data + 2^15;
data = data*datastep;
data = data + datamin;

time = (0:tlength-1)'*timestep;

end