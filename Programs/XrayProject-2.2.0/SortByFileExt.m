function [Itodo,fImage,i3] = ...
    SortByFileExt(pImage,fImage,fImSorted,Itodo,i3)
%  Sort list by file extension.  When finished, 
%  result is in fImage.

iNext = find(Itodo,1);
iNext = iNext(1);

[~, ~, ext] = fileparts([pImage,fImSorted{iNext}]);
% sort by ext
TT = strfind(fImSorted,ext);

for i1=1:size(fImSorted)
    if(Itodo(i1)==1)
        if ~(isequal(TT(i1),{[]}))
            i3=i3+1;
            fImage(i3)=fImSorted(i1);
            Itodo(i1)=0;
        end
    end
end
