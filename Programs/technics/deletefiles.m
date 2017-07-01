function deletefiles(fnames);
%function deletefiles(fnames);
% Deletes all files contained in the cell array of strings in fnames.

  for i=1:length(fnames)
      delete(fnames{i});
  end;

end