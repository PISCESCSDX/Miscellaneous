function [num, ndg] = find_lastfile(fb, fe)
%20070124 Brandt
% function [num, ndg] = find_lastfile(fb, fe)
% Search last file with the filebody fb and the file-extension fe assuming
% the filename is "fbxxxxx.fe" with a running number xxxxx.
% m-files needed:   fct_dirfinder
% input     fb  (string)    filebody
%           fe  (string)    file extension
% output    num (number)    next running number (no file found -> num=1)
%           ndg (number)    amount of digits (no file found -> ndg=6)
% EXAMPLE: [num, ndg] = find_lastfile(fb, fe)

if nargin < 2
    disp('Error: Not enough input arguments in function "find_lastfile"!');
    return;
end;


% +++ MAIN +++
% load file list fl which contains the files with filebody fb and
% fileextension fe
fl = dir([fb '*' fe]);

if size(fl, 1) > 0
    % create char array out of fl
    fl = fl(end).name;
    % detect begin and end position of fb and fe
    p1 = strfind(fl, fb);
    p2 = strfind(fl, fe);
    % test wether indices are ok
    if (p2-2<=p1+length(fb))
        disp('Error: File format not valid for m-file!');
    end;
    % extract number string
    nst = fl(p1+length(fb):p2-2);
    % 
    ndg = length(nst);
    num = str2num(nst)+1;
    if (ndg > 0 && size(num, 1) == 0)
        disp('Error: File format not valid for m-file ""!');
        ndg = 0;
        num = 0;
        return;
    end;
else
    num = 1;
    ndg = 6;
end;

% +++ END MAIN +++
end