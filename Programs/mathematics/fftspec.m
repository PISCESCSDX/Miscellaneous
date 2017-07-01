function [fre amp pha] = fftspec(t, s, w, o)
%==========================================================================
%function [fre amp pha] = fftspec(t, s, w, o)
%--------------------------------------------------------------------------
% FFTSPEC calculates the windowed Fourier Transform of the signal 's' 
% with the time vector 't' the window size 'w' and the overlap 'o'.
% It uses the function FFTCOMPLEX. (20091120 C. Brandt)
%--------------------------------------------------------------------------
% IN: t:   time vector (column)
%     s:   signal vector (column)
%     w:   window length (w=0..1), 1 full window (no avg: default), 
%          e.g., 0.1 window length 10% of signal length
%     o:   overlap of windows (o=0..1), default: 0.5
%OUT: fre: frequency vector
%     amp: amplitude vector
%     pha: phase vector
%--------------------------------------------------------------------------
% % EXAMPLE:
% phi = pi/2; f=2222;
% t = (0:1000)'/10000;
% % Create noisy sinosoidal signal with f=2222 Hz
% s = sin(2*pi*f*t + phi)+0.1*randn(length(t),1);
% figure(1); clf; plot(t, s)
% [fre amp pha] = fftspec(t, s, 1, 0.5);
% [ia ib] = max(amp);
% % Signal Reconstruction
% yn = zeros(length(t),length(amp));
% %yn(:,1) = (amp(1)/2)*ones(length(t),1);
% % for j=ib:ib
% for j=2:length(amp)/4
%   yn(:,j) = amp(j)*cos(2*pi*fre(j)*t + pha(j));
% end
% q = sum(yn');
% hold on; plot(t, q, 'r')
% figure(2); plot(fre, amp, 'bo-')
%==========================================================================

if nargin < 4; o=0.5; end
if nargin < 3; w=1; end
if nargin < 2; disp('Input is missing!'); return; end

fs = 1/(t(2)-t(1));
[indwin,~] = fftwindowparameter(length(t),w,o,fs,[]);
% Number of windows
N = size(indwin,1);

% Calculate windowed FFT 
%========================
mamp=0; mpha=0; ctr=0;
for i=1:N
  ind = indwin(i,1):indwin(i,2);
  i_t  = t(ind);
  isig = s(ind);
  % Calculate fft, use windowing
  [fre ft] = fftcomplex(i_t, isig);
  mamp = mamp + abs(ft);
  mpha = mpha + angle(ft);
  ctr=ctr+1;
end

amp = mamp/ctr;
pha = mpha/ctr;

end