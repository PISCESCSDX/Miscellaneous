function [ha, hp] = subplotpdf(x, y, xlb, ylb, xlim, ylim)
%function hp = subplotpdf(x, y, xlb, ylb, xlim, ylim)
%IN: x: std of signal
%    y: PDF
%   xlb: -1: OFF, any string: ON
%   ylb: -1: OFF, any string: ON
%  xlim: [xmin xmax]
%  ylim: [ymin ymax]
%OUT: plot of PDF
% EXAMPLE: subplotpdf(x, y, xlb, ylb, xlim, ylim)

fonts = 10;

if nargin<6; ylim=[min(y) max(y)]; end;
if nargin<5 || isempty(xlim); xlim=[min(x) max(x)]; end;
if nargin<4 || isempty(ylb); ylb='PDF'; end;
if nargin<3 || isempty(xlb); xlb='\delta n [\sigma]'; end;
if nargin<2; error('Input arguments are missing!'); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PDF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  hp = semilogy(x, y, 'k', 'LineWidth', 1);
  ha = gca;
  mkplotnice(xlb, ylb, fonts);

% SET LIMITS
  set(gca, 'xlim', xlim);
  set(gca, 'ylim', ylim);
  
end