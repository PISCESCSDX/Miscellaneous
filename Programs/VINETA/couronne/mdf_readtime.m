function [time_slow]= mdf_readtime(file)
% function [time_slow]= mdf_readtime(file)
% reads raw time stamp of mdf files
% format is descripted in 'Bedienungsanleitung'
% for T112; a matlab function for conversion is
% availiable: mdf_time2str
%
% input: full file path
% output: raw date as ulong (64bit)
%
if nargin<1
	error('You must specify a file.');
end	
if length(dir(file))==0
	error('file not found');
end

  fid=fopen(file);
  fseek(fid, 100, 'bof');
  time_slow=fread(fid,1,'ulong');
  fclose(fid);

end
