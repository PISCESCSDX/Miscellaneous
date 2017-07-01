function [corr, tau] = ccf(y1, y2, fs)
%==========================================================================
%function [corr, tau] = ccf(y1, y2, fs)
%--------------------------------------------------------------------------
% Original from O. Grulke, IPP Greifswald
% May-21-2013, C. Brandt, UCSD, San Diego
% CCF computes the cross-correlation function between datavectors y1 and y2
% (same length).
%--------------------------------------------------------------------------
% INPUT:
% y1, y2: data vectors
%         (!!! TO GET THE RIGHT DIRECTIONS: y1 fixed and y2 movable probe)
% fs: sampling frequency
% OUTPUT:       
% tau: vector of time lags 
% corr: resulting cross-correlation function
%--------------------------------------------------------------------------
% EXAMPLE:
% N = 2^12;
% dt = 5e-6;
% t = (0:N-1)'*dt;
% fs = 1/dt;
% f1 = 3000; a1=0.5; ph1 = 0.2*pi;
% f2 = 3400; a2=0.4; ph2 = -0.6*pi;
% noise = 0.1;
% S1 = a1*sin(2*pi*f1*t + ph1) + noise*randn(N,1);
% S2 = a2*sin(2*pi*f2*t + ph2) + noise*randn(N,1);
% [corr, tau] = ccf(S1, S2, fs);
% subplot(2,1,1); hold on; plot(t,S1,'b'); plot(t,S2,'r'); title('b:S1 r:S2')
% subplot(2,1,2); plot(tau, corr, 'k-o'); title('CCF(S1,S2)')
%==========================================================================

% Check for correct input
if nargin < 3
    error('Usage: [tau, corr] = ccf(y1, y2, fs)')
end

siy1 = max(size(y1));
siy2 = max(size(y2));

if (siy1 ~= siy2)
    error('Data vectors have different length!')
end

% Make time series mean free
y1 = y1-mean(y1);
y2 = y2-mean(y2);

% Some length parameters for averaging time series and zero padding
pad = 65536;
number = siy1;

% Build data vectors
data1 = zeros(pad,1);
data2 = zeros(pad,1);

% Fill with data and zero padding
data1(1:siy1) = y1;
data2(1:siy2) = y2;

% build normalizing factors and correlation matrix
nn = floor(number/2);
findgen1 = 0:1:nn-1;
findgen2 = 0:1:nn;
norm1 = number-nn+findgen1;
norm2 = number-findgen2;

corr = zeros(2*nn+1,1);

% Compute of cross-correlation function using Wiener-Khintchine
% theorem 
fft1 = fft(data1);
fft2 = fft(data2);
%pwrspc=fft1.*conj(fft2); !!Fehler!!
pwrspc = conj(fft1).*fft2;
  ztmp = real(ifft(pwrspc));

% compared to idl missing /pad because of different fft definition
% idl   : fft=1/n*sum...
% matlab: fft=    sum...
norm = sqrt( mean(y1.*y1) * mean(y2.*y2) );

% correct normalization due to zero padding;
% put the resulting vector in the right direction

corr(1:nn) = ztmp((pad-nn+1):(pad))/norm./norm1';
corr(nn+1:(2*nn+1)) = ztmp(1:nn+1)/norm./norm2';

tau = (findgen1+1)/fs;
tau = [fliplr(-tau) 0 tau];
end