function [ftree] = fnametree(f);
%function [ftree] = fnametree(f);
% Splits a pathname into a vector of all tree-folders.
%IN:  f(string): path-string
%OUT: ftree(string cell array): foldernames
%EX:  ftree=fnametree(pwd);

if ispc == 1
  ind = findstr('\', f);
else
  ind = findstr('/', f);
end

  for i=1:length(ind)
    [fpath ftree{i}] = fnamesplit(f);
    f=fpath(1:end-1);
  end;
    
end