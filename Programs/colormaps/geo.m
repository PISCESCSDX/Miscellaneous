function map = geo(m)
%==========================================================================
%function map = geo(m)
% May 30 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% GEO is a colormap as it is used for geographic maps. The center lies 
% between green end turqoise.
% GEO, by itself, has the same length as the current figure's colormap, if
% no input length is provided.
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap geo(128); shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
c(1,:) = [1.0 0.0 1.0]; % violet
c(2,:) = [0.0 0.0 0.5]; % dark blue
c(3,:) = [0.0 0.0 1.0]; % blue
c(4,:) = [0.0 1.0 1.0]; % turqoise
c(5,:) = [0.0 1.0 0.0]; % green
c(6,:) = [1.0 1.0 0.0]; % yellow
c(7,:) = [1.0 0.0 0.0]; % red
c(8,:) = [0.6 0.1 0.1]; % darkred

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi'); 

end