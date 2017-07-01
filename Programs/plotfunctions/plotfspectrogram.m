function [] = plotfspectrogram(tt, fvec, W)
%==========================================================================
%function [] = plotfspectrogram(tt, fvec, W)
%--------------------------------------------------------------------------
% PLOTFSPECTROGRAM 2d-plot of temporal Wavelet or Fourier analysis.
%--------------------------------------------------------------------------
%INPUT
%  tt: time vector (s)
%  fvec: frequency vector (Hz)
%  W:  2D data array of tt-vs-fvec
%OUTPUT:
%  2D-plot of frequency spectrogram
%--------------------------------------------------------------------------
% EXAMPLE:  plotfspectrogram(tt, fvec, W);
%   plotfspec(wfs.tt,wfs.fvec, wfs.W);
%==========================================================================

if nargin<3
    error('Input arguments are missing!');
end


figeps(12,7,1); clf
axes('Position', [0.12 0.2 0.73 0.75]);

subplotfspec(tt, fvec, W);
    
end