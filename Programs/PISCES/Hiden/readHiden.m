function [x,y,z] = readHiden(filename)
%==========================================================================
%function [x,y,z] = readHiden(filename)
%--------------------------------------------------------------------------
% READHIDEN reads data from filename assuming it is from Hiden EQP.
% Oct-07-2013, Christian Brandt, San Diego
%--------------------------------------------------------------------------
% IN: filename: string of the oscilloscope filename, e.g. "osc.CSV"
%OUT: x: x trace (e.g., mass, energy, ...)
%     y: measured quantity (usually counts/s)
%--------------------------------------------------------------------------
% Ex: [x,y,z] = readHiden('01.csv');
%==========================================================================


% Given by Hiden Data structure
delimiter_string = ',';


% Determine whether a multi-dimension scan is present
% If more than one "c/s" is found.
fid = fopen(filename);
i_token = 0;
i_token2= 0;
i_x = 0;
xaxis_read = 0;
i_line = 0;

token1 = '"c/s"';
token2 = '"Scan","Cycle",';

if fid > 0
  
  while ~feof(fid)
    i_line = i_line + 1;

    % Check if token2 is present in last line
    if i_line>1 && ~isempty( strfind(line_string, token2) )
      xaxis_read = 1;
    else
      xaxis_read = 0;
    end

    % Get current line string
    line_string = fgetl(fid);

    % If token2 was present in last line read the scale value of quantity 2
    % from the current line
    if xaxis_read
      i_x = i_x+1;
      % Look for value behind last comma
      i_commas = strfind(line_string, ',');
      x(i_x) = str2double( line_string(i_commas(end)+1:end) );
    end

    % Token 1: c/s
    if strfind(line_string, token1)
      i_token = i_token+1;
      ind_token(i_token) = i_line;
    end



  end
  fclose(fid);

% No file found
else
  disp(['No file ' filename ' can be found!'])
  x = []; y = [];
  return
end


% 49-227;  232-410
if i_token > 1

  line1 = 49;
  linediff = ind_token(2)-ind_token(1);
  % ------------------------------------------------ Multi-Dimensional Scan
  for i=1:numel(ind_token)
    
    R1 = line1 + (i-1)*linediff;
    R2 = R1 + linediff - 5;
    range = [R1 0   R2 1];
    A = dlmread(filename, delimiter_string, range);
    z(:,i) = A(:,2);

  end
  
    y = A(:,1);

else

  % -------------------------------------------------- One-Dimensional Scan
  % jump over the first 48 lines (only info lines)
  line = 48;
  A = dlmread(filename, delimiter_string, line, 0);

  x = A(:,1);
  y = [];
  z = A(:,2);

end

end