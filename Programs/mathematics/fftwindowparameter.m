function [indwin,freq] = fftwindowparameter(ltime,winrat,olap,fs,fend)
%==========================================================================
%function [indwin,freq] = fftwindowparameter(ltime,winrat,olap,fs,fend)
%--------------------------------------------------------------------------
% May-19-2013, C. Brandt, San Diego
% FFTWINDOPARAMETER calculates parameter and indices for any windowed FFT.
%--------------------------------------------------------------------------
%IN:
% ltime: length of the time trace
% winrat: window ratio [0..1] (in ratio to ltime)
% olap: overlap between windows [0..1] (default 0.5)
% fs: sample frequency (Hz)
% (optional) fend: end frequency (Hz), if [] freq.cut = freq.total
%OUT:
% indwin: array of window indices
%         (index vector of window 3 = indwin(3,1):indwin(3,2))
% freq: structure array
%     .total frequency axis
%     .cut frequency axis cut to fend
%--------------------------------------------------------------------------
%EXAMPLE: [indwin,freq] = fftwindowparameter(5000,1/5,0.5,1e5,20e3);
%==========================================================================

% window length
winL = round(winrat*ltime);
if winrat<1
  delta = round(winL*olap);
  N = floor((ltime-winL)/delta) +1;
else
  delta = ltime;
  N = 1;
end

if (N-1)*delta+winL<ltime
  indwin = NaN(N+1,2);
end

if N*delta==ltime
  indwin = NaN(N,2);
end

if N*delta>ltime
  error('The calculated number of windows is too large!')
end

for i=1:N
  indwin(i,1) = 1 + (i-1)*delta;
  indwin(i,2) = winL + (i-1)*delta;
  % disp(num2str([i indwin(i,1) indwin(i,2)]))
end

% Define the last window if indices have not reached the end of ltime
if (N-1)*delta+winL<ltime
  i=i+1;
  indwin(i,1) = ltime-winL +1;
  indwin(i,2) = ltime;
  % disp(num2str([i indwin(i,1) indwin(i,2)]))
end

% Frequency axis
if iseven(winL)
  lf = winL/2+1;
else
  lf = (winL+1)/2;
end

% Total frequency scale
freq.total = (0:lf-1)' * fs/winL;
% Cut frequency scale
if ~isempty(fend)
  ind = freq.total<=fend;
  freq.cut = freq.total(ind);
else
  freq.cut = freq.total;
end

end