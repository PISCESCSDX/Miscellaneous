function map = redblue_pastell_periodic(m)
%==========================================================================
%function map = redblue_pastell_periodic(m)
% Oct-11-2013, Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
%EXAMPLE: contourf(peaks(128),64);
%  colormap redblue_pastell_periodic; shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
i=0;

i=i+1; c(i,:) = rgb('Magenta');
i=i+1; c(i,:) = rgb('DodgerBlue');
i=i+1; c(i,:) = rgb('Turquoise');
i=i+1; c(i,:) = rgb('White');
i=i+1; c(i,:) = rgb('SandyBrown');
i=i+1; c(i,:) = rgb('OrangeRed');
i=i+1; c(i,:) = rgb('Magenta');

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi');

end