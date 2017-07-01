function [fre ft] = fftcomplex(t, s, w, z)
%==========================================================================
%function [fre ft] = fftcomplex(t, s, w, z)
%--------------------------------------------------------------------------
% Nov-29-2009, C. Brandt, Nancy
% FFTCOMPLEX calculates the complex Fourier Transform of the signal 's' 
% with the time vector 't'.
%--------------------------------------------------------------------------
%INPUT
%  t: time vector (column)
%  s: signal vector (cloumn)
%  w: 0: no window, 1: use hanning window (default)
%  z: (z>=0), zeropad: amount of zeros padded in units of length(t)
%    0: no zeros (default), 1: 1*length(t) zeros, and so on
%OUTPUT
%  fre: frequency vector
%  ft: complex values of the disrete Fourier transform
%--------------------------------------------------------------------------
%EXAMPLE
% [fre ft] = fftcomplex(t, s);
%==========================================================================

if nargin < 4; z=0; end
if nargin < 3; w=1; end
if nargin < 2; disp('Input is missing!'); return; end


% time trace data
	dt = t(2)-t(1);
	lt = length(t);
% new length with added zeros (if 0 this is the original length)
	lnew = round( (z+1).*lt );

% create hanning window for the signal s (column)
  if w==1
    win = hanning(lt);
  else
    win = ones(lt, 1);
  end

% apply window on s
  s = s.*win;

% append zeros to s
  s = [s; zeros(round(z*lt), 1)];

% calculate the fft - and divide by the integral of the window    
  ft = fft(s) ./ sum(win);
% calculate real amplitude
  ft = 2.*ft; % 2 because 2 components of +f und -f (conj. compl.)
% added 8.8.2012, m=0 is present only once!
  ft(1) = ft(1)/2;

 % For real x and y, the length of Pxy is (nfft/2+1) if nfft is even 
 % or (nfft+1)/2 if nfft is odd. For complex x or y, 
 % the length of Pxy is nfft.
  
% create frequency axis
  Tper = lnew*dt;
  df   = 1/Tper;
  fre  = (0:lnew-1)'*df;

% remove half of the frequency spectrum (beyond the Nyquist-limit)
if iseven(length(fre))
  ind = 1:(length(fre)/2)+1;
else
  ind = 1:(length(fre)+1)/2;
end
  
  fre = fre(ind);
  ft = ft(ind);
  
end