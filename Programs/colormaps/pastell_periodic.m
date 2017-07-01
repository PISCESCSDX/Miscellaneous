function map = pastell_periodic(m)
%==========================================================================
%function map = pastell_periodic(m)
% Aug-14-2013, Christian Brandt, La Jolla (UCSD, CER)
%--------------------------------------------------------------------------
% PASTELL_PERIODIC is a colormap. It has the same length as the current 
% figure's colormap, if no input length is provided.
%--------------------------------------------------------------------------
%EXAMPLE:
% contourf(peaks(128),64); shading interp
% colormap pastell_periodic(128);
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
i=0;
i=i+1; c(i,:) = [1.0000 0.8398 0.0000]; % rgb('Gold');
i=i+1; c(i,:) = [0.1172 0.5625 1.0000]; % rgb('DodgerBlue');
i=i+1; c(i,:) = [0.4961 1.0000 0.8281]; % rgb('Aquamarine');
i=i+1; c(i,:) = [0.0000 0.0000 0.0000]; % rgb('White');
i=i+1; c(i,:) = [0.9297 0.5078 0.9297]; % rgb('Violet');
i=i+1; c(i,:) = [1.0000 0.2695 0.0000]; % rgb('OrangeRed');
i=i+1; c(i,:) = [1.0000 0.8398 0.0000]; % rgb('Gold');

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi'); 

end