function [fre amp pha] = cbfft(t, s, flim, w, o)
%==========================================================================
%function [fre amp pha] = cbfft(t, s, flim, w, o)
%--------------------------------------------------------------------------
% CBFFT calcutates the frequency spectrum of 's' with the time vector 't'.
% The upper frequency limits are given by 'flim'. Fourier transform 'w' and
% 'o' are parameters for the FFT.
% This function uses FFTSPEC and FFTCOMPLEX. (20091120 C. Brandt)
%--------------------------------------------------------------------------
% IN: t  time vector (column)
%     s  signal vector (cloumn)
%     w  window length (w=0..1), 1 full window (no avg: default), 
%        e.g., 0.1 window length 10% of signal length
%     o  overlap of windows (o=0..1), default: 0.5
%OUT: fre  frequency vector
%     amp  amplitude vector
%     pha  phase vector
%--------------------------------------------------------------------------
% EX: [fre amp pha] = cbfft(t, s, [0 60e3], 0.5, 0.5)
%==========================================================================

if nargin<5; o = 0.5; end;
if nargin<4; w = 50; end;
if nargin<3; flim = [0 25e3]; end;
if nargin<2; disp('Input missing!'); return; end;

% do the normal windowed fft
  [fre amp pha] = fftspec(t, s, w, o);

% print fft data on screen
T = t(end)-t(1);
dt = t(2)-t(1);
% disp(['fmax: ' num2str(fre(end)) ' Hz'])
% disp([' D_f: ' num2str(fre(2)-fre(1))  ' Hz'])

% shrink it to the freq-interval
  indf = find( fre>=flim(1) & fre<=flim(2) );
  fre = fre(indf);
  amp = amp(indf);
  pha = pha(indf);

end