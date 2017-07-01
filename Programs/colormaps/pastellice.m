function map = pastellice(m)
%==========================================================================
%function map = pastellice(m)
% May 30 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% PASTELLICE is a colormap similar to iceglow but more greyish.
% PASTELLICE, by itself, has the same length as the current figure's 
% colormap, if no input length is provided.
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap pastellICE(128); shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
i=0;
i=i+1; c(i,:) = [0.0 0.0 0.3]; % dark blue
i=i+1; c(i,:) = [0.2 0.2 1.0]; % blue
i=i+1; c(i,:) = [0.4 1.0 1.0]; % turqoise
i=i+1; c(i,:) = [1.0 1.0 1.0]; % white
i=i+1; c(i,:) = [1.0 0.4 1.0]; % violet
i=i+1; c(i,:) = [1.0 0.2 0.2]; % red
i=i+1; c(i,:) = [1.0 1.0 0.0]; % yellow

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi'); 

end