function [h1, h2, h3] = subplotfft2colors(frq, A1, A2, ...
  xlb, ylb, fftlim, fonts, col_bg1, col_bg2,  col_ed1, col_ed2)
% function [h1, h2, h3] = subplotfft2colors(frq, A1, A2, ...
%   xlb, ylb, fftlim, fonts, col_bg1, col_bg2,  col_ed1, col_ed2)
% IN: frq: frq axis /kHz
%     A1: amplitude (decadic)
%     A2: amplitude which will be shown in the background
%     xlb:
%     ylb:
%     fftlim:
%     fonts: FontSize
%     col_bg1, col_bg2
%     col_ed1, col_ed2
%OUT: plot of the fft-spectrum
% EX:

if nargin<3; help subplotfftduo; return; end;
if nargin<4; xlb = 'f [kHz]'; end;
if nargin<5; ylb = 'S [dB]'; end;
if nargin<6 | isempty(fftlim); fftlim = [min(min([A1 A2])) max(max([A1 A2]))]; end;
if nargin<7; fonts=12; end;
if nargin<8; col_bg1=[]; end;
if nargin<9; col_bg2=[]; end;

% calculate good limits
% (1) round min down to 10-limit; max up to 10-limit
    slim(1) = nextmainnum(fftlim(1), 10, 'down');
    slim(2) = nextmainnum(fftlim(2), 10, 'up');

frq = frq/1e3;

h2 = area(frq, A2);
  set(h2, 'BaseValue', slim(1));
  set(h2(1),'FaceColor', col_bg2)
  set(h2(1),'EdgeColor', col_ed2)
  set(gca,'ylim',[-70 05]);
  hold on;
h1 = area(frq, A1);
  set(h1, 'BaseValue', slim(1));
  set(h1(1),'FaceColor', col_bg1);
  set(h1(1),'EdgeColor', col_ed1);
  set(gca,'ylim', slim);
  hold off;
h3 = gca;

  mkplotnice(xlb, ylb, fonts, -33);

end