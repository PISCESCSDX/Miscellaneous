function [] = subplotfftcol(freq, ampl, xlb, ylim, logx, fonts, xlim)
%function [] = subplotfftcol(freq, ampl, xlb, ylim, logx, fonts)
%
% m-files needed:
% input:    freq    freq axis /kHz
%           ampl    amplitude (decadic)
%           xlb     1:xlabel; 0: no xlabel
%           ylim    [..  ..]
%           logx    1: x: log
%           fonts: default 12
% output:   plot of the fft-spectrum
% EXAMPLE:  subplotfft(freq, ampl, xlb, logx)

if nargin<7; xlim = [freq(1) freq(end)]/1e3; end;
if nargin<6; fonts = 12; end;
if nargin<5; logx = 0; end;
if nargin<4; ylim = [min(ampl) max(ampl)]; end;
if nargin<3; xlb=1; end;
if nargin<2; error('Input arguments are missing!'); end;

% calculate good limits
% (1) round min down to 10-limit; max up to 10-limit
  slim(1) = nextmainnum(ylim(1), 10, 'down');
  slim(2) = nextmainnum(ylim(2), 10, 'up');

%	frequency axis in kHz
  freq = freq/1e3;

bg = area(freq, ampl);
ax1 = gca();
if logx==1
 set(ax1, 'xscale', 'log');
 set(ax1, 'xtick', [1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100]);
 set(ax1, 'xticklabel', ...
  {'1','2','','','5','','','','','10','20','','','50','','','','','100'});
end

set(ax1, 'ytick', [-90 -60 -30 0 30])
set(bg, 'BaseValue', slim(1));
set(bg(1),'FaceColor', 1*[1 1 1]); % 0.8 gray
set(gca, 'xlim', xlim)
set(ax1, 'ylim', slim);
  
switch xlb
  case 0
    [hxl hyl] = mkplotnice('-1', 'S (dB)', fonts, -30);
  case 1
    [hxl hyl] = mkplotnice('f (kHz)', 'S (dB)', fonts, -30);
end

end