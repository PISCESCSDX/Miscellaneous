function []= make_folder(dirname)
% make_folder creates a folder with dirname if it does not exist already
%
% input     dirname         string containing absolute path to new dir

   [newdir, parent]= path_last_element(dirname);
   dir_struct= dir(parent);
   if size(dir_struct, 1) == 0
       error('Parent directory does not exist.');
   end

   dir_struct= dir(dirname);
   if size(dir_struct, 1) == 0
       mkdir(dirname)
   end
end