function [] = plotfft(fre, amp, xlb, ylb, xlim, ylim, fonts)
%==========================================================================
%function [] = plotfft(fre, amp, xlb, ylb, xlim, ylim, fonts)
%--------------------------------------------------------------------------
% PLOTFFT plots a frequency spectrum in the current figure.
%--------------------------------------------------------------------------
%INPUT
%  fre: frequency vector (Hz)
%  amp: amplitude (decadic)
%OUTPUT
%  plot of the fft-spectrum
%--------------------------------------------------------------------------
%EXAMPLE
%  plotfft(fre,amp,'frequency (kHz)','amplitude (dB)', [1 30], [0 700], 12)
%==========================================================================

if nargin<7; fonts = 14; end;
if nargin<6; ylim = []; end;
if nargin<5; xlim = []; end;
if nargin<4; ylb = ''; end;
if nargin<3; xlb = ''; end;
if nargin<2; error('Input arguments are missing!'); end;

figeps(15,8,1); clf;

% make plot
  axes('Position', [0.15 0.18 0.8 0.75]);
  subplotfft(fre, amp, xlb, ylb, xlim, ylim, fonts);

end