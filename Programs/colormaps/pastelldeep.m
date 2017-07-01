function map = pastelldeep(m)
%==========================================================================
%function map = pastelldeep(m)
% May 30 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% PASTELLDEEP is a colormap similar to iceglow but more greyish.
% PASTELLDEEP, by itself, has the same length as the current figure's 
% colormap, if no input length is provided.
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap pastelldeep(128); shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
i=0;
i=i+1; c(i,:) = [0.35 0.1  0.5]; % dark violett
i=i+1; c(i,:) = [0.2  0.2  1.0]; % blue
i=i+1; c(i,:) = [0.2  0.4  1.0]; % blue darker
i=i+1; c(i,:) = [0.2  0.7  1.0]; % light blue
i=i+1; c(i,:) = [0.4  1.0  1.0]; % turqoise
i=i+1; c(i,:) = [0.5  1.0  0.9]; % turqoise
i=i+1; c(i,:) = [0.5  1.0  0.7]; % light green
i=i+1; c(i,:) = [1.0  1.0  1.0]; % white
i=i+1; c(i,:) = [0.9  0.7  0.9]; % rose
i=i+1; c(i,:) = [0.9  0.5  0.8]; % light violet
i=i+1; c(i,:) = [0.9  0.3  0.6]; % pink
i=i+1; c(i,:) = [1.0  0.1  0.2]; % orange darker
i=i+1; c(i,:) = [1.0  0.3  0.2]; % red
i=i+1; c(i,:) = [1.0  0.6  0.2]; % orange
i=i+1; c(i,:) = [1.0  1.0  0.0]; % yellow

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi');

end