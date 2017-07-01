function [hp] = subplotfspectrogram(tt, fvec, W, xlb, ylb, tint)
%==========================================================================
%function [hp] = subplotfspectrogram(tt, fvec, W, xlb, ylb, tint)
%--------------------------------------------------------------------------
% SUBPLOTFSPECTROGRAM makes a plot in a current figure of a f-spectrogram.
%--------------------------------------------------------------------------
%INPUT
%  tt: time vector (s)
%  fvec: frequency vector (Hz)
%  W:  2D data time-vs-frequency
%  xlb: 1: xlabel on; 0: off
%  ylb: 1: ylabel on; 0: off
%  tint: time interval (ms)
%OUTPUT
% Time evolution plot of the spectrum
%--------------------------------------------------------------------------
% EX: subplotfspectrogram(tt, fvec, W)
%==========================================================================

fonts = 12;

if nargin<6; tint=-1; end;
if nargin<5; ylb = 'frequency (kHz)'; end;
if nargin<4; xlb = 'time (ms)'; end;
if nargin<3; error('Input arguments are missing!'); end;


% t-fspec plot
    colormap jet
    
% create the time intervall
  tt = tt * 1e3;
  if tint>0 && tt(end)>=tint
      tend = max(find(tt<tint))+1;
  else
      tend = length(tt);
  end;

% pcolor plot
  hp = pcolor(tt(1:tend), fvec/1e3, W(:, 1:tend));
  shading interp

% labels
if ~strcmp(xlb,'-3')
  mkplotnice(xlb, ylb, fonts, '-25', '-30');
end
 our_colorbar('A (arb.u.)', fonts, 12, 0.015, 0.02);
end