function [ptsT]=applyTform(T,pts);

% function [ptsT]=applyTform(T,pts)
%
% Applies the inverse transform specified in T to the [x,y] points in pts
% added dedistortion (Baier 1/16/06)

ptsT=pts;
idx=find(isnan(pts(:,1))==0);
[ptsT(idx,1),ptsT(idx,2)]=tforminv(T,pts(idx,1),pts(idx,2));