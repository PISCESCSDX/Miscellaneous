function h = hoti(m)
%HOT    Black-red-yellow-white color map
%   HOTFLIPPED(M) returns an M-by-3 matrix containing a "hotflipped" 
%   colormap. HOTFLIPPED, by itself, is the same length as the current 
%   figure's colormap. If no figure exists, MATLAB creates one.
%
%   ERRORS: Can result in problems while using with PRINT_ADV.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(hotflipped)
%
%   See also HSV, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT. .. and the flipped ones.

if nargin < 1, m = size(get(gcf,'colormap'),1); end

cut = round(m/4);
m = m+cut;
n = fix(3/8*m);

r = [(1:n)'/n; ones(m-n,1)];
g = [zeros(n,1); (1:n)'/n; ones(m-2*n,1)];
b = [zeros(2*n,1); (1:m-2*n)'/(m-2*n)];

h = [r g b]; h = flipud(h); a=h(1:m-cut,:); clear h;
h = a;
