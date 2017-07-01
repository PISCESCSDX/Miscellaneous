function [tt A] = readosc(filename)
%==========================================================================
%function [tt A] = readosc(filename)
%--------------------------------------------------------------------------
% Read data file filename created by the oscilloscope LeCroy Type: ... .
%--------------------------------------------------------------------------
% IN: filename: string of the oscilloscope filename, e.g. "osc.CSV"
%OUT: tt: time vector of the measurement
%     A: matrix with 4 vectors of the oscilloscope measurement.
%--------------------------------------------------------------------------
% Ex: [tt A] = readosc('FTRN1515.CSV');
%==========================================================================

% read DELTA(second)
token = 'Delta(second),'; lt = length(token);
fid = fopen(filename, 'rt');
while  feof(fid) == 0
  lin = fgetl(fid);
  if strfind(lin, token)
    fclose(fid);
    break
  end
end
dt = str2num(lin(lt+1:end));
  
% Given by oscilloscpe filestructure
delimiter_string = ',';
% jump over the first 29 lines (only info lines)
line = 30;
A = dlmread(filename, delimiter_string, line, 0);

la = size(A,1);
tt = (0:la-1)'*dt;

end