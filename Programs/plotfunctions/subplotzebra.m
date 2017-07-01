function [zp cb] = subplotzebra(tt, phi, A, xlb, tint, zlim, cbar, fonts)
%function [zp cb] = subplotzebra(tt, phi, A, xlb, tint, zlim, cbar, fonts)
% m-files needed:   
% input:    tt      time trace
%           phi     angle vector
%           A       2d phi-t-data
%           xlb     1: xlabel on; 0: off
%           tint    time intervall /ms
%           zlim    color limits
%           cbar 1: colorbar on
%           fonts: default 12
% output:   spatio temporal plot
%           zp     handle zebra-plot
%           cb     handle colorbar
% EXAMPLE:  subplotzebra(tt, phi, A, xlb, tint, zebralim)

if nargin<8; fonts=12; end;
if nargin<7; cbar=1; end;
if nargin<6; zlim=1; end;
if nargin<5; tint=-1; end;
if nargin<4; xlb=1; end;
if nargin<3; error('Input arguments are missing!'); end;


% ZEBRA PLOT
    
% TIME INTERVALL
  tt = tt*1e3;
  if tint == -1
    tend = length(tt);
  else
    tend = max(find(tt<tt(1)+tint));
  end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COLOR NORMALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if zlim == -1
  maxa = max(max(A));
  A=A./maxa;
  zlim = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCOLOR PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colormap pastell; % copper -> see 3dim structures
zp = gca();
pcolor(tt(1:tend), phi, A(:, 1:tend));
shading interp;
set(gca, 'YTick', [0 1 2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COLORBAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
caxis([-zlim zlim]);

if cbar == 1                          %default: 8
  [cb yh] = our_colorbar(' n (arb.u.) ', fonts+2, 12, 0.008, 0.003);
  ca = gca; set(gcf, 'currentaxes', cb);
  ht = mktilde(yh, ' n (arb.u.)', 2);
  set(gcf, 'currentaxes', ca);
  set(cb, 'ylim', [-1 1]);
  set(cb, 'YTick', [-1 0 1]);
  %set(cb, 'YTickLabel', {'-1', '', '0', '', '1'});
else
  cb = [];
end
 
switch xlb
  case 1
    mkplotnice('time (ms)', '\theta (units of \pi)', fonts, '-25', '-20');
  case 0
    mkplotnice('-1', '\theta (units of \pi)', fonts, '-25', '-25');
end

end