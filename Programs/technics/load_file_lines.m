function [TS] = load_file_lines(fn, ln1, ln2)
%==========================================================================
%function [TS] = load_file_lines(fn, ln1, ln2)
%--------------------------------------------------------------------------
% Loads lines from a ascii file.
%--------------------------------------------------------------------------
% input:    fn: string of filename
%           ln1: number of starting line
%           ln2: number of end line
% output:   a                   n column vector
% EXAMPLE:	data = load_raw_data(result.dat, '%%', '\t');
% FOR PROBE-BOX: load_raw_data(a(i).name, '%--', ' ');
% For Spectrum PISCES-A:
%           A = load_file_lines('alpha_ivdata0001.hea', 4)
%==========================================================================

if nargin < 3
  ln2 = ln1;
end

fid = fopen(fn);
% Decide whether file found
if fid > 0
  
  ctr = 0;
  while ctr<ln1-1
    ctr = ctr+1;
    fgetl(fid);
  end

 TS{ln2-ln1+1} = [];
  
 lctr = 0;
  while feof(fid) == 0 && (lctr+ln1<=ln2) 
    lctr = lctr+1;
    TS{lctr} = fgetl(fid);
  end
  
else    % file not found
  TS = [];
end
  
end
