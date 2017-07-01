function map = testcolor(m)
%==========================================================================
%function map = testcolor(m)
% April 18 (2013), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% EXAMPLE: contourf(peaks(128),64); colormap testcolor(64); shading flat
%==========================================================================

% Define basic colors
i=0;

% %i=i+1; c(i,:) = rgb('Snow'); % Blue
% i=i+1; c(i,:) = rgb('Aqua'); % Blue
% i=i+1; c(i,:) = rgb('MediumBlue'); % Blue
% i=i+1; c(i,:) = rgb('MidNightBlue'); % Blue
% i=i+1; c(i,:) = rgb('Black'); % Black
% i=i+1; c(i,:) = rgb('DarkRed'); % DarkRed
% i=i+1; c(i,:) = rgb('Red'); % DarkRed
% %i=i+1; c(i,:) = rgb('Orange'); % DarkRed
% i=i+1; c(i,:) = rgb('Gold'); % Blue

i=i+1; c(i,:) = rgb('Yellow');
i=i+1; c(i,:) = rgb('GreenYellow');
i=i+1; c(i,:) = rgb('DodgerBlue');
i=i+1; c(i,:) = rgb('Turquoise');
i=i+1; c(i,:) = rgb('White');
i=i+1; c(i,:) = rgb('SandyBrown');
i=i+1; c(i,:) = rgb('OrangeRed');
i=i+1; c(i,:) = rgb('Gold');
i=i+1; c(i,:) = rgb('Yellow');

% Interpolation
x = (1:length(c))';
dx = (x(end)-x(1))/(m-1);
xi = 1:dx:length(c);
map= interp1(x',c,xi');

end