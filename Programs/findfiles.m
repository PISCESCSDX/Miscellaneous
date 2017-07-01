function fnames = findfiles(fstring, directory, recurse);
% Finds all files with the specified extension in the current directory and 
% subdirectories (recursive). Returns a cell array with the fully specified 
% file names.
%
%    files = findfiles( fstring )
%       searches in the current directory and subdirectories.
%
%    files = findfiles( fstring, directory)
%       starts search in directory specified.
%
%    files = findfiles( fstring, directory, searchSubdirectories )
%       If searchSubdirectories == 0, the function will not descend 
%       subdirectories. The default is that searchSubdirectories ~= 0.
%
% Note: if this function causes your recursion limit to be exceeded, then 
% it is most probably trying to follow a symbolic link to a directory that 
% has a symbolic link back to the directory it came from.
%
% Examples:

if nargin == 1
    directory = cd;
    recurse = (1==1);
elseif nargin == 2
    oldDir = cd;
    cd(directory);
    directory = cd;
    cd(oldDir);
    recurse = (1==1);
elseif nargin >= 3
    oldDir = cd;
    cd(directory);
    directory = cd;
    cd(oldDir);
end

d = dir(directory);
files = dir([directory '/' fstring]);

fnames = {};
numMatches = 0;
for i=1:length(files)
    numMatches = numMatches + 1;
    fnames{numMatches} = fullfile(directory,files(i).name);
end
for i=1:length(d)
  if recurse & d(i).isdir & ~strcmp(d(i).name,'.') & ~strcmp(d(i).name,'..')
    fnames = [fnames findfiles(fstring,fullfile(directory,d(i).name),recurse)];
    numMatches = length(fnames);
  end
end