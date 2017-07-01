function mdfzip_all();
%function mdfzip_all();
% Puts 8 MDF-files together to one AND deletes all 8 separate
% MDF-files! Of the whole subfolder system.
% If an ERROR in an subfolder with the mdf-clusters exists, it will be
% reported and nothing will be deleted (this function will be stopped
% then).
%M-FILES: findfiles.m, findfolders.m, mdfzip.m
% IN: -
%OUT: -
% EX: mdfzip_all;
%20080221-Do-19:47 Brandt (working version)

% test all folders wether there is an mdf-file-save error
% looks in these folders (but not '..' and '.') which ones contains *.MDF
% out:  mdfdir(1, :) .. numbers of folders in a
%       mdfdir(2, :) .. amount of mdf-clusters (1mdfcluster=8mdf-files)

% SAVE START DIRECTORY
  bd=pwd;
% FIND ALL subfolders where mdf-clusters can be ... (needed are BA*-BH*)
  dirlist = findfolders('BH*.MDF');

% calculate all mdf-clusters
sc = clock_int;
if size(dirlist, 1)>0
    for k=1:length(dirlist)
        cd(cell2mat(dirlist(k)));
        disp(['mdfzip of directory: '  cell2mat(dirlist(k))]);
        mdfzip;
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