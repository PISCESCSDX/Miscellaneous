function map = fireice(m)
%==========================================================================
%function map = fireice(m)
% April 18 (2013), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap fireice(64); shading flat
%==========================================================================

if nargin < 1, m = size(get(gcf,'colormap'),1); end

% Define basic colors
i=0;
i=i+1; c(i,:) = rgb('Aqua');          % [0 1 1]
i=i+1; c(i,:) = rgb('MediumBlue');    % [0 0 0.8008]
i=i+1; c(i,:) = rgb('MidNightBlue');  % [0.0977 0.0977 0.4375]
i=i+1; c(i,:) = rgb('Black');         % [0 0 0]
i=i+1; c(i,:) = rgb('DarkRed');       % [0.543 0 0]
i=i+1; c(i,:) = rgb('Red');           % [1 0 0]
i=i+1; c(i,:) = rgb('Gold');          % [1 0.8398 0]

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi');

end