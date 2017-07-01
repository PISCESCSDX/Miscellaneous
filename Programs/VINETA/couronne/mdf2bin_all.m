function mdf2bin_all(defch, fliponoff, cou_list)
%20080224-Sa-04:00 Brandt
%function mdf2bin_all(defch, fliponoff, cou_list)

if nargin<3; cou_list=[]; end

% SAVE START DIRECTORY
  bd=pwd;
% FIND ALL subfolders where mdf-clusters can be ... (needed are BA*-BH*)
  dirlist = findfolders('cou*.MDF');

% calculate all mdf-clusters
sc = clock_int;
if length(dirlist)>0
    for k=1:length(dirlist)
        cd(cell2mat(dirlist(k)));
        disp(['mdfbin of directory: '  cell2mat(dirlist(k))]);
        mdf2bin(defch, fliponoff, cou_list);
        cd('..');
    end;
end;

% GO BACK TO START DIRECTORY
  cd(bd);

% show calculation time
ec = clock_int; 
disp(['begin: ' sc]);
disp(['end:   ' ec]);
disp(['diff:  ' clockdiff(sc, ec)]);