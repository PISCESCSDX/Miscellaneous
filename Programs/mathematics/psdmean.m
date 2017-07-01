function [mPxx freq] = psdmean(sig, fs, nwin, novl, nfft, a, norm, fmax)
%function [mPxx freq] = psdmean(sig, fs, nwin, novl, nfft, a, norm)
% Calculate the Power Spectral Density via pwelch. 
% IN: sig(vec): signal vector
%     fs(num): sample frequency
%     nwin(int): window length, exponent of 2
%     novl(num): E ]0,1[ overlap of windows
%     nfft(int): fft length, exponent of 2
%     a(opt): vector with 4 elements, weight for mean process.
%             [10 1 1 1] low noise, broad peaks
%             [1 1 1 10] higher noise, thin peaks
%     norm: normalize amplitudes to maximum (1/0:y/n)
%     fmax /Hz
%OUT: freq(vec): frequency vector
%     spec(vec): amplitude
% EX: [mPxx mPxxf] = psdmean(sig, fs, 16, 0.5, 16, [10 2 3 4]);
%     plot(mPxxf(f_ind), 10*log10(mPxx(f_ind)), 'k-');

if nargin<8; fmax=100e3; end;
if nargin<7; norm=0; end;
if nargin<6; a=[1 1 1 1]; end;
if nargin<5; error('5 input arguments needed!'); end;

% points for fft
  nfft = 2^(nfft);

% MEAN PROCEDURE - calculate 4 spectras
win = 2^(nwin-3);
ovl = round(win*novl);
  [Pxx1, freq] = pwelch(sig, win, ovl, nfft, fs);

win = 2^(nwin-2);
ovl = round(win*novl);
  [Pxx2, freq] = pwelch(sig, win, ovl, nfft, fs);
  
win = 2^(nwin-1);
ovl = round(win*novl);  
  [Pxx3, freq] = pwelch(sig, win, ovl, nfft, fs);
  
win = 2^nwin;
ovl = round(win*novl);  
  [Pxx4, freq] = pwelch(sig, win, ovl, nfft, fs);

  
  mPxx=(a(1)*Pxx1+a(2)*Pxx2+a(3)*Pxx3+a(4)*Pxx4)/sum(a);
  
  if norm==1
    mPxx=mPxx./max(mPxx);
  end;
  
  f_ind = freq<fmax;
  freq = freq(f_ind);
  mPxx = mPxx(f_ind);
end


%   [ps,f]=psd(data,nfft,sf,hanning(nfft),0);
%   %[ps,f]=pwelch(data,nfft,nfft/2,nfft,sf); %not yet testet!
%   %ps=ps/max(ps);
%   ps=20*log10(ps);