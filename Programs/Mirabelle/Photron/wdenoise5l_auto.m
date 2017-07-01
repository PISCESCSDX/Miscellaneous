function wdenoise5l_auto(data,fastmode)
%==========================================================================
%function wdenoise5l_auto(data,fastmode)
%--------------------------------------------------------------------------
% WDENOISE5L_AUTO 
%--------------------------------------------------------------------------
% IN: data structure-array
%       data.dir: cell array with directories to evaluate
%       data.fi1: cell array with number of first file
%       data.fin: cell array with number of amount of files
%       fastmode: 1: no picture drawing
% WDENOISE_AUTO: wavelet filtering of a series of images
% thr: main parameter = threshold for the noise
% the image data is shifted back to its original values
%--------------------------------------------------------------------------
% Ex: 
% data.dir{1} = 'd:\work\!now\12He\a';
% data.fi1{1} = 1;
% data.fin{1} = 396;
% wdenoise5l_auto(data, 1);
%--------------------------------------------------------------------------
% (C) 07.06.2012 17:08, C. Brandt:
%     - include reading cine files
% (C) 17.03.2011 14:38, C. Brandt:
%     - removed normalization error:
%       now: std2(averaged removed picture) = std2(denoised picture)
% (C) 05.01.2011 14:38, C. Brandt:
%     - added fastmode option
% (C) 05.01.2011 18:05, C. Brandt:
%     - changed to wavelet level 3 [lvl]
%     - removed wsmooth (slowed down but no smoothing at all)
%     - generalized interpolation resolution to 100x100 (independ. of lvl)
% (C) 04.01.2011 16:50, C. Brandt
% (C) 01.04.2008 16:00, F. Brochard
%==========================================================================

if nargin<2; fastmode=0; end

lvl = 2;
wname=['sym' num2str(lvl)];

% Save start directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startdir = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOR loop: amount of directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ldir = length(data.dir);
for idir=1:ldir

% change to evaluation directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(data.dir{idir});


% Load average removed pictures
a = dir('a*.tif');

% Check if amount of claimed files is available, if not change n
if length(a) >= data.fin{idir}
  n = data.fin{idir};
else
  n = length(a);
end


% Load the shift value
fnshift = ['shift_avg_' num2str(data.fi1{idir}) 'ToN' num2str(n) '.mat'];
load(fnshift);


if fastmode==0
  figeps(5,5,1, 2,70); set(gcf,'name','original');
  figeps(5,5,2, 2,40); set(gcf,'name','filtered');
  figeps(5,5,3, 2,10); set(gcf,'name','smoothed');
end

% start of the main loop
% inter=zeros(:,:,n);
clear inter
for i=1:n
  disp(['image # ' num2str(i)])
  % load the files
  num = i+data.fi1{idir};
  curfile = a(num).name;
  im = double(imread(curfile))-double(vid.shift);
  imstd = std2(im);
  imx = size(im,1); 
  imy = size(im,2); 
% threshold analysis
% [thr,sorh,keepapp] = ddencmp('den','wv',im);
% De-noise image using global thresholding option.
% denim = wdencmp('gbl',im,'sym4',2,thr,sorh,keepapp);
% fim = wcodemat(denim);

%==========================================================================
% 2D wavelet decomposition
%==========================================================================
% Multilevel 2D wavelet decomposition
[C,S] = wavedec2(im,lvl,wname);
% % Energy of 2D wavelet decomposition
% [Ea,Edetails] = wenergy2(C,S);

% Single-level reconstruction of 2D wavelet decomposition
[~,~,cA] = upwlev2(C,S,wname);

% wsmooth(cA);
cA = wsmooth(cA);

% % Reconstructed image at 1st order
%Y = upcoef2('a',cA,wname,2);

  [nx, ny] = size(cA);
  % new matrix should have the same size as the original picture (im)
  [xi, yi] = meshgrid(1: (nx-1)/(imx-1) :nx,1:(ny-1)/(imy-1):ny);
  inter = interp2(1:ny,1:nx,cA,yi,xi)';

  %------------------------------------------------------------------------
  % Standard Deviation Recovery
  %------------------------------------------------------------------------
  % Prepare the 2D reconstructed camera data having the same standard
  % deviation as the simply average removed pictures.
  interstd = std2(inter);
  inter = inter*imstd/interstd;
  %------------------------------------------------------------------------

if fastmode==0
% Draw the original image
  figure(1); clf; axes('position', [0.18 0.16 0.76 0.79]);
  pcolor(im); shading flat; colormap(pastelldeep(64))
  set(gca, 'clim', 800*[-1 1])
  mkplotnice('x (pix)', 'y (pix)', 12, '-20', '-35');
% draws the filtered image
  figure(2); clf; axes('position', [0.18 0.16 0.76 0.79]);
  pcolor(cA); shading flat; colormap(pastelldeep(64))
    set(gca, 'clim', 800*[-1 1])
  mkplotnice('x (pix)', 'y (pix)', 12, '-20', '-35');
% draws the smoothed filtered image  
  figure(3); clf; axes('position', [0.18 0.16 0.76 0.79]);
  pcolor(inter); shading flat; colormap(pastelldeep(64))
    set(gca, 'clim', 800*[-1 1])
  mkplotnice('x (pix)', 'y (pix)', 12, '-20', '-35');
end
  
% Save the filtered image
  num = i-1+data.fi1{idir};
  nomfin=[wname 'smooth' a(num).name];
  imwrite(uint16(inter+vid.shift),nomfin); 
end

% Change to start directory
cd(startdir);

end