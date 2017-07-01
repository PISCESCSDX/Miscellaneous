function g = grayi(m,minl)
% map = grayi(m,minl)
%
% GRAYI provides a linear inverse gray-scale color map. It returns an 
% M-by-3 matrix containing a gray-scale colormap. Small amplitudes 
% correspond to bright regions (in contrast to GRAY) and large amplitudes
% to dark (adjustable from gray to black) regions. See also GRAY, HSV, HOT,
% COOL, BONE, COPPER, PINK, FLAG, COLORMAP, RGBPLOT.
%
%	m	number of gray levels
%	minl	minimum intensity level of dark areas 0<minl<1
%		default is 0.2,  0 gives full black
%	map	corresponding colormap
%						ThDdW 8/95
 
if nargin < 1,	m = size(get(gcf,'colormap'),1);	end
if nargin < 2,	minl = 0.2;	end

g = linspace(1,minl,m)';

bright = 0.3;		% brightening coefficient (0<bright<1)
g = g.^(1-bright);
g = [g g g];
