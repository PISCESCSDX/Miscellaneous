function [fnames] = findfolders(fstring);
%function findfolder();
% 20070221 C.Brandt: find folders (one level deeper of the current
% directory) which contains files with filestr.
% input     fstring     string which shoulf be contained in the filenames.
% output    folders     folders(k,:) .. k-th foldername
% EXAMPLE: findfolders('*.MDF');

  a=findfiles(fstring);

  fnames = {};
  for i=1:length(a)
    [fpath fname] = fnamesplit(a{i});
    if isempty(fnames)
      foldernum = 1;
      fnames{foldernum}=fpath;
    else
      if ~strcmp(fpath, fnames{foldernum})
        foldernum = foldernum +1;
        fnames{foldernum} = fpath;
      end
    end
  end

end