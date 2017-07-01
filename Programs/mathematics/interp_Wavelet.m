function im = interp_Wavelet(pic,lvl,window)
%==========================================================================
%function interp_Wavelet(pic,lvl,window)
% Jun-01-2013, Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% INTERP_WAVELET decomposes an image into wavelet components and
% interpolates in a lossless way. The resulting image 'im' has the same
% size, the same average and same standard deviation as the input picture
% 'pic'.
%--------------------------------------------------------------------------
%INPUT
%  pic: input 2D image (or data set)
%  lvl: level of wavelet averaging (default 2, the larger the more avg)
%  window: wavelet window name (default 'sym')
%OUTPUT
%  im: output image (or data set)
%--------------------------------------------------------------------------
%EXAMPLE
% pic = peaks(64) + randn(64,64);
% lvl = 2;
% wname = 'sym';
% im = interp_Wavelet(pic,lvl,wname);
%==========================================================================

if nargin<3; window = 'sym';  end
if nargin<2; lvl = 2;         end

wname = [window num2str(lvl)];

picavg = matmean(pic);
picx = size(pic,1);
picy = size(pic,2); 
% Multilevel 2D wavelet decomposition
[C,S] = wavedec2(pic,1,wname);
%[C,S] = wavedec2(pic,lvl,wname);
% Single-level reconstruction of 2D wavelet decomposition
[~,~,cA] = upwlev2(C,S,wname);
% wsmooth(cA);
cA = wsmooth(cA);

cA = cA/matmean(cA)*picavg;

% % $$$ START PROBE $$$
% figeps(14,8,1); clf;
% subplot(1,2,1)
% pcolor(pic  ); shading flat; axis square
% set(gca,'clim',[0 1000])
% subplot(1,2,2)
% pcolor(cA); shading flat; axis square
% set(gca,'clim',[0 1000])
% return
% % $$$ END PROBE $$$

% % Reconstructed image at 1st order
%Y = upcoef2('a',cA,wname,2);

[nx, ny] = size(cA);
% new matrix should have the same size as the original picture (im)
[xi, yi] = meshgrid(1: (nx-1)/(picx-1) :nx,1:(ny-1)/(picy-1):ny);
im = interp2(1:ny,1:nx,cA,yi,xi)';
% %------------------------------------------------------------------------
% % Standard Deviation Recovery
% %------------------------------------------------------------------------
% % Prepare the 2D reconstructed camera data having the same standard
% % deviation as the simply average removed pictures.
% interavg = matmean(inter);
% interstd = std2(inter);
% 
% % Output Data Set
% im = (inter - interavg)*picstd/interstd + picavg;

end


% pic = peaks(64) + randn(64,64);
% lvl = 2;
% wname = 'sym';
% im = interp_Wavelet(pic,lvl,wname);