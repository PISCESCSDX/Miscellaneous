function [fs] = readcih(filename)
%==========================================================================
%function [fs] = readcih(filename)
% May-14-2013, C. Brandt, San Diego
%--------------------------------------------------------------------------
% READCIH reads the sample frequency from the cih-file of the fast camera.
%--------------------------------------------------------------------------
% IN: filename: string of the cih-filename, e.g. "01.cih"
%OUT: fs: sample frequency (Hz)
%--------------------------------------------------------------------------
% Ex: fs = readcih('01.cih');
%==========================================================================

% find position of the sample frequency and read it
token = 'Record Rate(fps) : '; lt = length(token);
fid = fopen(filename, 'rt');
while  feof(fid) == 0
  lin = fgetl(fid);
  if strfind(lin, token)
    fclose(fid);
    break
  end
end
fs = str2num(lin(lt+1:end));
  
end