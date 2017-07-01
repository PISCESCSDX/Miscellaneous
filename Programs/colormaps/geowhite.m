function map = geowhite(m)
%==========================================================================
%function map = geowhite(m)
% May 30 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% GEOWHITE is a colormap somewhat similar to geo, but white is the center.
% GEOWHITE, by itself, has the same length as the current figure's 
% colormap, if no input length is provided.
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap geowhite(128); shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
c(1,:) = [1.0 0.0 1.0]; % violet
c(2,:) = [0.0 0.0 0.5]; % dark blue
c(3,:) = [0.0 0.0 1.0]; % blue
c(4,:) = [0.0 1.0 1.0]; % turqoise
c(5,:) = [1.0 1.0 1.0]; % white
c(6,:) = [0.0 1.0 0.0]; % green
c(7,:) = [1.0 1.0 0.0]; % yellow
c(8,:) = [1.0 0.0 0.0]; % red
c(9,:) = [0.6 0.1 0.1]; % darkred

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi'); 

end