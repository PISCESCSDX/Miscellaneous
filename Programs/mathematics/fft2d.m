function [freq, kfsp] = fft2d(data, fs, avg)
%==========================================================================
%function [freq, kfsp] = fft2d(data, fs, avg)
%--------------------------------------------------------------------------
% FFT2D computes the 2D FFT of a 2D matrix.
% Useful for spatiotemporal data.
%
% IN: data: 2dim matrix, data(positions, timerow);
%     fs: sample frequency (Hz)
%     avg: 1: remove average, 0: do not remove average
%OUT: freq: frequency axis
%     kfsp: complete kf-spectrum (in reality mode-frequency-spectrum)
%          (Nyquist-limit not removed)
%--------------------------------------------------------------------------
% EX: avg = 1; fs = 1/(tt(2)-tt(1));
%     [freq, kfsp] = fft2d(data, fs, avg)
%==========================================================================

if nargin<2; fs=1/8e-7; end;
if nargin<3; avg=0; end;


% m rows, n columns
    [m, n] = size(data);
 
% remove mean value
    if avg==1
       meandata = mean(data);
       for i=1:m
           data(i,:) = data(i,:) - meandata;
       end
    end

% important: hanning window along the time rows!
    z = hanning(n)*ones(1,m);
% apply hanning window on data
    data = data.*z';

% 2-dimensional Fourier transformation (divide by integral of window)
    data = fft2(data)./(sum(hanning(n))./n);
% normalization to sum of elements
    kfsp = data./numel(data);
% factor 2, because frequency splits into two parts in the complex
% kf-spectrum, and later on only one part will be used
    kfsp = 2.*kfsp;
% create the frequency axis
    freq = fs*(0:n-1)/n;

end