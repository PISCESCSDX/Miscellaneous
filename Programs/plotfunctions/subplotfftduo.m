function [] = subplotfftduo(x, a1, a2, xlb, ylb, xlim, ylim, fonts, logx)
%==========================================================================
%function [] = subplotfftduo(x, a1, a2, xlb, ylb, xlim, ylim, fonts, logx)
%--------------------------------------------------------------------------
% IN: x: freq (Hz)
%    a1: amplitude (decadic)
%    a2: amplitude which will be shown in the background
%   xlb: '-1' no xlabel, any string: ON
%   ylb: '-1' no ylabel, any string: ON
%  xlim: [xmin xmax]
%  ylim: [ymin ymax]
%  fonts(opt): default:12
%  logx: 1: x-axis logaritmic; 0: x-axis linear
%OUT: plot of the fft-spectrum and a second spectrum in the background
%--------------------------------------------------------------------------
% EX:  subplotfftduo(x, a1, xlb);
% LOOK also at SUBPLOTFFT
%==========================================================================

if nargin<9; logx = 1; end;
if nargin<8; fonts = 12; end;
if nargin<7; ylim = [min(a1) max(a1)]; end;
if nargin<6; xlim = [x(1) x(end)]/1e3; end;
if nargin<5; ylb=1; end;
if nargin<4; xlb=1; end;
if nargin<3; error('Input arguments are missing!'); end;

% calculate good limits
% (1) round min down to 10-limit; max up to 10-limit
    slim(1) = nextmainnum(ylim(1), 10, 'down');
    slim(2) = nextmainnum(ylim(2), 10, 'up');

%	frequency axis in kHz
    x = x/1e3;
%   plot fft-spectrum
  bg=area(x, a2);  hold on;
if logx==1
 set(gca, 'xscale', 'log');
 set(gca, 'xtick', [1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100]);
 set(gca, 'xticklabel', ...
  {'1','2','','','5','','','','','10','20','','','50','','','','','100'});
end
set(gca, 'ytick', [-150 -120 -90 -60 -30 0 30]);
set(bg,    'BaseValue', slim(1));
set(bg(1), 'FaceColor', [0.8 0.8 0.8]);
set(bg(1), 'EdgeColor', [0.8 0.8 0.8]);
ph=area(x, a1);  hold off;
  set(ph, 'BaseValue', slim(1) );
  set(ph, 'FaceColor', 'w');
    
set(gca, 'xlim', xlim)
set(gca, 'ylim', slim);

mkplotnice(xlb, ylb, fonts, -35);


end