function map = geowhitecalifornia(m)
%==========================================================================
%function map = geowhitecalifornia(m)
% Aug 28 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% GEOWHITECALIFORNIA is a colormap somewhat similar to geo, but white is 
% the center. GEOWHITECALIFORNIA, by itself, has the same length as the 
% current figure's colormap, if no input length is provided.
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap geowhitecalifornia(128); shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
c(1,:) = [1.0 0.0 1.0]; % violet
c(2,:) = [0.0000 0.0000 0.8008]; % rgb('MediumBlue');
c(3,:) = [0.1172 0.5625 1.0000]; % rgb('DodgerBlue');
c(4,:) = [0.2500 0.8750 0.8125]; % rgb('Turquoise');
c(5,:) = [1.0000 1.0000 1.0000]; % rgb('White');
c(6,:) = [0.4844 0.9875 0.0000]; % rgb('LawnGreen');
c(7,:) = [1.0000 0.8398 0.0000]; % rgb('Gold');
c(8,:) = [1.0000 0.2695 0.0000]; % rgb('OrangeRed');
c(9,:) = [0.6 0.1 0.1]; % darkred

% i=i+1; c(i,:) = [0.0000 0.0000 0.5000]; % rgb('Navy');
% i=i+1; c(i,:) = [0.0000 0.0000 0.8008]; % rgb('MediumBlue');
% i=i+1; c(i,:) = [0.1172 0.5625 1.0000]; % rgb('DodgerBlue');
% i=i+1; c(i,:) = [0.2500 0.8750 0.8125]; % rgb('Turquoise');
% i=i+1; c(i,:) = [1.0000 1.0000 1.0000]; % rgb('White');
% i=i+1; c(i,:) = [1.0000 0.7109 0.7539]; % rgb('LightPink');
% i=i+1; c(i,:) = [1.0000 0.4102 0.7031]; % rgb('HotPink');
% i=i+1; c(i,:) = [1.0000 0.2695 0.0000]; % rgb('OrangeRed');
% i=i+1; c(i,:) = [1.0000 0.8398 0.0000]; % rgb('Gold');

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi'); 

end