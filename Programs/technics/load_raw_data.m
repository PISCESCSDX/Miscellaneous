function [TS] = load_raw_data(fn, startstr, endstr, delstr)
%==========================================================================
%function [TS] = load_raw_data(fn, startstr, delstr)
%--------------------------------------------------------------------------
% Loads from a number file all columns and rows of numbers under the line 
% beginning with startstr.
%--------------------------------------------------------------------------
% input:    fn             string with filename
%           startstr (opt)   string indicate the start of the data
%           endstr: if empty [] read until end
%           delstr    '\t' TAB; ' ' SPACE
% output:   a                   n column vector
% EXAMPLE:	data = load_raw_data(result.dat, '%%', '\t');
% FOR PROBE-BOX: load_raw_data(a(i).name, '%--', ' ');
% For Spectrum PISCES-A:
%             A = load_raw_data('01a.txt', '>>>>>Begin', '>>>>>End', '\t');
%==========================================================================

if nargin < 4;  return;   end


fid = fopen(fn);
% Decide whether file found
if fid > 0
  fclose(fid);

  % Find startline and endline
  startline = find_ascii_token(fn, startstr);
  
  if isempty(endstr)
    TS = dlmread(fn, delstr, startline, 0);
    
  else
    endline = find_ascii_token(fn, endstr);
    
    % Determine number of columns
    fid = fopen(fn, 'rt');
    for i=1:startline+1
      ln_string= fgetl(fid);
    end
    fclose(fid);
    
    C = textscan(ln_string, '%f');
    C2= cell2mat(C);
    numcol = length(C2);
    
    % Read all from startline to endline and from column 0 to end column
    R1 = startline;
    R2 = endline-2;
    C1 = 0;
    C2 = numcol-1;
    range = [R1 C1 R2 C2];

    TS = dlmread(fn, delstr, range);    
  end
  

else    % file not found
  TS = [];
end
  
end
