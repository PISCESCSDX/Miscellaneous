function [i_ln, ln_string] = find_ascii_token(filename, token)
%==========================================================================
%function [i_ln, ln_string] = find_ascii_token(filename, token)
%--------------------------------------------------------------------------
% Extracts line with 'token' in file 'filename'.
%---------------------------------------------------------------------INPUT
% filename: name of file to be examined
% token: sign to find
%--------------------------------------------------------------------OUTPUT
% i_ln: line of first occurence of string
%	ln_string: whole line containing string
%-------------------------------------------------------------------EXAMPLE
% [i_ln, freq_line] = find_ascii_token(datname, 'f[kHz] = ');
% freq = sscanf(freq_line, '%f' ) * 1000;
%==========================================================================


fid = fopen(filename, 'rt');

if fid > 0
  
  i_ln = 0;
  while feof(fid) == 0
    i_ln = i_ln + 1;
    ln_string = fgetl(fid);
    if strfind(ln_string, token)
      break
    end
  end
  
  fclose(fid);
  ln_string = ln_string(size(token,2) + 1:end);

% No file found
else
  i_ln = [];
  ln_string= [];
end


end