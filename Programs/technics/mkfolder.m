function []= mkfolder(dirname)
%function []= mkfolder(dirname)
% mkfolder creates a folder with dirname if it does not exist already.
% IN: dirname: string containing absolute path to new dir
% EX: mkfolder('/home/cbra/matlab/phase-detect')

[newdir, parent] = path_last_element(dirname);
dir_struct= dir(parent);

if size(dir_struct, 1) == 0
  error('Parent directory does not exist.');
end

dir_struct= dir(dirname);

if size(dir_struct, 1) == 0
  mkdir(dirname)
end
    
end