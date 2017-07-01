function c = rose(m)
%ROSE Shades of white to red map
%   ROSE(M) returns an M-by-3 matrix containing a "rose" colormap.
%   ROSE, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%       colormap(rose)
%
%   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.
% EXAMPLE: contourf(peaks(128),64); colormap rose(128); shading flat

if nargin < 1, m = size(get(gcf,'colormap'),1); end

r = (0:m-1)'/max(m-1,1); 
c = [ones(m,1) 1-r 1-r];

end