function [follist] = findfollist(flist);
%function [follist] = findfollist(flist);
% Find all folders in the names of flist. Saves this in follist{..}.
% needs:  fnamesplit

ctr = 1;
for i=1:length(flist)
  [fpath fname] = fnamesplit(flist{i});
  if i>1
    if ~strcmp(fpath, follist{ctr-1})
      follist{ctr} = fpath;
      ctr = ctr + 1;
    end;
  else
    follist{ctr} = fpath;
    ctr = ctr + 1;
  end;
end;

if length(flist)==0
  follist = {};
end;

end