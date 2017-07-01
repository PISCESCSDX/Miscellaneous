function [date_str]= mdftime(filename)
%function [date_str]= mdftime(filename)
% Extracts the timestring for an mdf-file.
% IN: mdf-filename

stamp = mdf_readtime(filename);
[date_str]= mdf_time2str(stamp);

end