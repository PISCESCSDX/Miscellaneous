function camprepfiles_all
%function camprepfiles_all
% CAMPREPFILES prepares names of tif-files. This is for a better
% arrangement.

% SAVE START DIRECTORY
  bd = pwd;
% FIND ALL subfolders where tif-files are in
  dirlist = findfolders('*.tif');

% execute camprepfiles in each folder
sc = clock_int; disp(clock_int)
if ~isempty(dirlist)
  for k=1:length(dirlist)
    cd(cell2mat(dirlist(k)));
    disp('camprepfiles of directory:')
    disp(cell2mat(dirlist(k)))
    camprepfiles;
  end
end

% GO BACK TO START DIRECTORY
  cd(bd);

% show calculation time
ec = clock_int; 
disp(['begin: ' sc]);
disp(['end:   ' ec]);
disp(['diff:  ' clockdiff(sc, ec)]);

end