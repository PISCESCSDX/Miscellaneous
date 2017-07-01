function rows = frows(filename)
%==========================================================================
%function rows = frows(filename)
%--------------------------------------------------------------------------
% FROWS finds the number of rows in a file.
% Oct-08-2013, Christian Brandt, San Diego
%--------------------------------------------------------------------------
% IN: filename: string of the filename, e.g. '01.Master.Sample'
%OUT: rows: number of rows in a filetrace of wavelength
%--------------------------------------------------------------------------
% Ex: rows = frows(filename);
%==========================================================================


% Scan for number of lines
fid = fopen(filename);
rows = 0;
while ~feof(fid)
  fgetl(fid);
  rows = rows+1;
end
fclose(fid);


end