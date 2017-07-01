function map = sunsetnight_periodic(m)
%==========================================================================
%function map = sunset_periodic(m)
% Aug-13-2013, Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% SUNSET_PERIODIC is a colormap.
% SUNSET_PERIODIC, by itself, has the same length as the current figure's 
% colormap, if no input length is provided.
%--------------------------------------------------------------------------
%EXAMPLE:
% contourf(peaks(128),64); shading interp
% colormap sunset_periodic(128);
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
i=0;
i=i+1; c(i,:) = [0.0000 0.0000 0.0000]; % rgb('White');
i=i+1; c(i,:) = [0.4961 1.0000 0.8281]; % rgb('Aquamarine');
i=i+1; c(i,:) = [0.2734 0.5078 0.7031]; % rgb('SteelBlue');
i=i+1; c(i,:) = [0.2930 0.0000 0.5078]; % rgb('Indigo');
i=i+1; c(i,:) = [1.0000 1.0000 1.0000]; % rgb('Black');
i=i+1; c(i,:) = [0.6445 0.1641 0.1641]; % rgb('Brown');
i=i+1; c(i,:) = [1.0000 0.2695 0.0000]; % rgb('OrangeRed');
i=i+1; c(i,:) = [1.0000 0.8398 0.0000]; % rgb('Gold');
i=i+1; c(i,:) = [0.0000 0.0000 0.0000]; % rgb('White');

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi'); 

end