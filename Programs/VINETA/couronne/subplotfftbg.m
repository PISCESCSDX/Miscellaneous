function [] = subplotfftbg(freq, freq2, ampl, ampl2, xlb, ylim, logx, fonts, xlim)
%function [] = subplotfftbg(freq, freq2, ampl, ampl2, xlb, ylim, logx, fonts)
% FORMER FUNCTION subplotfftduo.
%
% m-files needed:
% input:    freq    freq axis /kHz
%           freq2   freq axis /kHz
%           ampl    amplitude (decadic)
%           ampl2   amplitude which will be shown in the background
%           xlb     1:xlabel; 0: no xlabel
%           ylim    [... ...]
%           logx    1:x-axis log
%           fonts   default 12
% output:   plot of the fft-spectrum
% EXAMPLE:  subplotfft(freq, ampl, xlb);

if nargin<9; xlim = [freq(1) freq(end)]/1e3; end;
if nargin<8; fonts = 12; end;
if nargin<7; logx = 1; end;
if nargin<6; ylim = [min(ampl) max(ampl)]; end;
if nargin<5; xlb=1; end;
if nargin<4; error('Input arguments are missing!'); end;

% calculate good limits
% (1) round min down to 10-limit; max up to 10-limit
    slim(1) = nextmainnum(ylim(1), 10, 'down');
    slim(2) = nextmainnum(ylim(2), 10, 'up');

%	frequency axis in kHz
    freq = freq/1e3; freq2 = freq2/1e3;
%   plot fft-spectrum
  bg=area(freq2, ampl2);  hold on;
if logx==1
 set(gca, 'xscale', 'log');
 set(gca, 'xtick', [1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100]);
 set(gca, 'xticklabel', ...
  {'1','2','','','5','','','','','10','20','','','50','','','','','100'});
end
set(gca, 'ytick', [-90 -60 -30 0 30])
set(bg,    'BaseValue', slim(1));
set(bg(1), 'FaceColor', [0.8 0.8 0.8]);
set(bg(1), 'EdgeColor', [0.8 0.8 0.8]);
ph=area(freq, ampl);  hold off;
  set(ph,    'BaseValue', slim(1) );
  set(ph, 'FaceColor', 'w');
    
set(gca, 'xlim', xlim)
set(gca, 'ylim', slim);

switch xlb
  case 0
    mkplotnice('-1', 'S [dB]', fonts, -35);
  case 1
    mkplotnice('f [kHz]', 'S [dB]', fonts, -35);
end


end