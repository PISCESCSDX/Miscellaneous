function [] = savebin(fname, data, time)
%==========================================================================
%function [] = savebin(fname, data, time)
%--------------------------------------------------------------------------
% SAVEBIN saves data in a binary file of a 16 bit resolution.
% Data is stored in a 2D matrix, matrix dimensions possible up to 16bit
% each direction.
% Read binary data using READBIN.
%--------------------------------------------------------------------------
%INPUT
%  fname: string of filename
%  data: double of binary saved matrix
%  time: double of time axis
%OUTPUT
%--------------------------------------------------------------------------
%EXAMPLE
%  savebin(fname, data, time);
%==========================================================================

% extract most important data
[tlength channels] = size(data);
timestep = time(2)-time(1);
datamin  = min(min(data));
datamax  = max(max(data));

% devide the min-max interval into 16 bit (2^16-1 because the zero is 
% included and int16 is reaching from -32768 to +32767)
datastep = (datamax-datamin)/(2^16-1);

% prepare data for small storage size
data = data-datamin;
data = round(data/datastep);
data = data - 2^15;

if min(min(data))==-2^15 && max(max(data))==+2^15-1
else
  disp('out of limit error in saved matrix');
end

% write procedure
fr = fopen(fname, 'w');
% write main data
  fwrite(fr, channels, 'uint16');
  fwrite(fr,  tlength, 'uint32');
  fwrite(fr, timestep, 'double');
  fwrite(fr,  datamin, 'double');
  fwrite(fr, datastep, 'double');
% write datamatrix
for i=1:channels
  fwrite(fr, data(:, i), 'int16');        
end
fclose(fr);

end