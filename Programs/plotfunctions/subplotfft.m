function [ha, hp] = subplotfft(x, y, xlb, ylb, xlim, ylim, fonts)
%==========================================================================
%function [ha, hp] = subplotfft(x, y, xlb, ylb, xlim, ylim, fonts)
%--------------------------------------------------------------------------
% IN: x: freq axis Hz
%     y: amplitude (decadic)
%   xlb: '-1': OFF, any string: ON
%   ylb: '-1': OFF, any string: ON
%  xlim: [xmin xmax]
%  ylim: [ymin ymax]
%  fonts(opt): default:12
%OUT: plot of the fft-spectrum
%--------------------------------------------------------------------------
% EXAMPLE: subplotfft(x, y, xlb);
% LOOK also at 
%==========================================================================

% Calculate frequencz in kHz
x = x/1e3;

if nargin<7; fonts=12; end;
if nargin<6 || isempty(ylim); ylim = [min(y) max(y)]; end;
if nargin<5 || isempty(xlim); xlim=[min(x) max(x)]; end;
if nargin<4 || isempty(xlb); ylb='S [dB]'; end
if nargin<3 || isempty(xlb); xlb='f [kHz]'; end

% Plot fft-spectrum
  hp = semilogx(x, y, 'k');
  ha = gca;

  set(gca, 'xtick', [1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100]);
  set(gca, 'xticklabel', ...
   {'1','2','','','5','','','','','10','20','','','50','','','','','100'});

  set(gca, 'ytick', [-150 -120 -90 -60 -30 0 30]);

% Set limits
  set(gca, 'xlim', xlim);
  set(gca, 'ylim', ylim);

  mkplotnice(xlb, ylb, fonts, '-25', '-30');

end