function [hyl hp] = subplottt(x, y, xlb, ylb, xlim, ylim, fonts)
%function [hyl] = subplottt(x, y, xlb, ylb, xlim, ylim, fonts)
%
% IN: x: time trace /s
%     y: signal of floating potential
%   xlb: '-1': OFF, any string: ON
%   ylb: '-1': OFF, any string: ON
%  xlim: [xmin xmax]
%  ylim: [ymin ymax]
% fonts: default 12
% OUT: plot of the fft-spectrum
% EX:  subplottt(x, y, xlb, ylb, xlim, ylim)

if nargin<7; fonts=12; end;
if nargin<6; ylim=[min(y) max(y)]; end;
if nargin<5 || isempty(xlim); xlim=[min(x) max(x)]; end;
if nargin<4; ylb=''; end;
if nargin<3; xlb=''; end;
if nargin<2; error('Input arguments are missing!'); end;

% OLD:
% % calculate good limits
% % (1) round min down to 10-limit; max up to 10-limit
%     slim(1) = nextmainnum(ttlim(1), 0.1, 'down');
%     slim(2) = nextmainnum(ttlim(2), 0.1, 'up');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT TIME SERIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hp = plot(x, y, 'k');
set(gca, 'xlim', xlim);
set(gca, 'ylim', ylim);

[hxl hyl] = mkplotnice(xlb, ylb, fonts, -22);

ypos = get(hyl, 'position');
if ~strcmp(ylb, '-1')
set(hyl, 'position', [xlim(1)-0.2*(xlim(2)-xlim(1)) ypos(2:3)])
end


end