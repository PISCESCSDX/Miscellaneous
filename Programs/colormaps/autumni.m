function c = autumnflipped(m)
%AUTUMNFLIPPED Shades of yellow to red color map
%   AUTUMNFLIPPED(M) returns an M-by-3 matrix containing a "autumn" colormap.
%   AUTUMNFLIPPED, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%       colormap(autumnflipped)
%
%   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
r = (0:m-1)'/max(m-1,1);
c = [ones(m,1) r zeros(m,1)];
c = flipud(c);
