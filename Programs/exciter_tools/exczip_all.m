function exczip_all();
%20080225-Sa-04:00 Brandt
%function exczip_all();
% 20070221 C.Brandt: zips all exciter-setting-files to one.
% needs:    findfolders.m    
%           exczip.m
% EX: exczip_all

% test all folders wether there is an mdf-file-save error
% looks in these folders (but not '..' and '.') which ones contains *.MDF
% out:  mdfdir(1, :) .. numbers of folders in a
%       mdfdir(2, :) .. amount of mdf-clusters (1mdfcluster=8mdf-files)

% SAVE START DIRECTORY
  bd=pwd;
% SEARCH all FOLDERs which contains excsettings
  dirlist = findfolders('_excsettings*');

% calculate all mdf-clusters
sc=clock_int;
if size(dirlist, 1)>0
    for k=1:length(dirlist)
        cd(cell2mat(dirlist(k)));
        disp(['exczip of directory: '  cell2mat(dirlist(k))]);
        exczip;
    end;
end;

% BACK TO START DIRECTORY
  cd(bd);

% show calculation time
ec=clock_int; 
disp(['begin: ' sc]);
disp(['end:   ' ec]);
disp(clockdiff(sc, ec));