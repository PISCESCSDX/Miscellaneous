function [wc, as] = cwt1d(ys, as, wtype, pf)
%==========================================================================
%function [wc, as] = cwt1d(ys, as, wtype, pf)
%--------------------------------------------------------------------------
% Take the CWT of the input signal using the representation of the
% wavelet in physical space or Fourier space
% Uses the complex Morlet wavelet or the Mexican hat.
%--------------------------------------------------------------------------
% Inputs
%   ys: input signal
%   as: dilation parameters 'a' at which to perform the transform
%   pf: 'p' or 'f' for physical or Fourier-based Morlet
%   wtype: 'cmorl' for complex Morlet ; 'mexh' for mexican hat
% Outputs
%   wc: wavelet coefficients
%   xs: positions
%   as: dilation parameters
%--------------------------------------------------------------------------
% Example: 
%   numoct = 7; % for a signal length 2^7 = 128
%   nvpo = 4;
%   scalesout = cwscales(numoct,nvpo);
%   ks = 1./scalesout; % Fourier wavenumbers (no pi)
%--------------------------------------------------------------------------
%   as = cwscale(ks,'k2a');
%   [wc,as] = cwt1d(sig,as,'cmorl','f');
%--------------------------------------------------------------------------
% See also: CWT2D, CWSCALE, CWSCALES, DRAWCWT1D
%==========================================================================
    
% Check wavelet
if ~strcmp(wtype, 'cmorl') && ~strcmp(wtype, 'mexh');
  disp(['Unknown wavelet type ', wtype]);
  return
end

% Length of signal
N = length(ys);

% Number of dilations in decomposition
nscales = length(as);

% Fourier transform of the signal
FFTys = fft(ys);
Fys = FFTys;

% Allocate Output variable
wc = zeros(nscales,N);

% perform complete decomposition

% loop over scales
for j=1:nscales;
  switch pf
    %--------------------------
    % Fourier based wavelet
    %--------------------------
    case 'f'
      % generate the wavelet at the current dilation
      if strcmp(wtype,'cmorl')
        Fmo = gen_cmorlet(N, as(j), 'f');
      else
        Fmo = gen_mexh(N, as(j), 'f');
      end
      % Multiply the Fourier transforms to take the CWT whos Fys Fmo
      Fwc = Fys(:) .* conj( Fmo(:) );
    %--------------------------
    % Physical space wavelet
    %--------------------------
    case 'p'
      % generate the wavelet at the current scale
      if strcmp(wtype,'cmorl')
        Fmo = fft(gen_cmorlet(N, as(j),'p'))/N;
      else
        Fmo = fft(gen_mexh(N, as(j),'p'))/N;
      end
      % multiply the Fourier transforms to take the CWT
      Fwc = Fys.*conj(Fmo);
    otherwise 
      disp(['Invalid option: ', pf]);
    return
  end

% Computed wavelet coefficients
WC = ifft(Fwc);
% WC = ifft(Fwc,N); % Computed wavelet coefficients
wc(j,:) = WC;

end % loop over scales


% Modified 4/26/2006 Jori
% from CWT_test_P1.m