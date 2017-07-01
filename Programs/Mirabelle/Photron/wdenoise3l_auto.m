function wdenoise3l_auto(info)
% IN: info structure-array
%       info.dir: cell array with directories to evaluate
%       info.fi1: cell array with number of first file
%       info.fin: cell array with number of amount of files
% WDENOISE_AUTO: wavelet filtering of a series of images
% thr: main parameter = threshold for the noise
% the image data is shifted back to its original values
% (C) F. Brochard, 04/2008, version 10/2009

lvl = 2;
wname='sym4';

% Save start directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startdir = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOR loop: amount of directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ldir = length(info.dir);
for idir=1:ldir

% change to evaluation directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(info.dir{idir});

% Load camera parameter file and the 'a*.tif' files
filecih = dir('*.cih');
filestr = filecih(1).name(1:end-4);
a = dir(['a' filestr '*.tif']);

% Check if amount of claimed files is available, if not change n
if length(a) >= info.fin{idir}
  n = info.fin{idir};
else
  n = length(a);
end

% load the shift value
shiftfile='shift.mat';
load(shiftfile);

% figures properties
set(0,'Units','pixels')
scrnsize = get(0,'ScreenSize');
f1 = figure('Color','w','Name','Original Image');
f2 = figure('Color','w','Name','Filtered Image');

% start of the main loop
% inter=zeros(:,:,n);
clear inter
for i=1:n
  disp(['image # ' num2str(i)])
  % load the files
  curfile = a(i+info.fi1{idir}).name;
  im = double(imread(curfile))-double(shift); sim = size(im);

% figures properties
  width = sim(1); % width of the figure
  height= sim(2); % height of the figure
  pos1  = [10, 0.5*scrnsize(4) + 10, width, height];
  pos2  = [pos1(1)+width+10, pos1(2) width, height];

% draws the original image
  figure(f1); set(gcf, 'Position',pos1);
  image(im),colormap(pastell)

% threshold analysis
% [thr,sorh,keepapp] = ddencmp('den','wv',im);
% De-noise image using global thresholding option.
% denim = wdencmp('gbl',im,'sym4',2,thr,sorh,keepapp);
% fim = wcodemat(denim);

  [C,S] = wavedec2(im,lvl,wname);
  [Ea,Edetails] = wenergy2(C,S);

  [NC,NS,cA] = upwlev2(C,S,wname);

%Y = upcoef2('a',cA,wname,2); %reconstructed image at 1st order
% draws the filtered image
  figure(f2);set(gcf, 'Position',pos2);
%image(Y)
  pcolor(cA),shading('interp')
  colormap(pastell)

  wsmooth(cA);     % long procedure
  lis=wsmooth(cA); % long procedure
  [nx, ny]=size(lis);
  [xi,yi]=meshgrid(1:.5:nx,1:.5:ny);
  inter(:,:,i)=interp2(1:ny,1:nx,lis,yi,xi);
end
  shift = max(max(max(inter)));
  save('shiftdenoise.mat','shift');
% save the filtered image
for i=1:n
  nomfin=[wname 'smooth' a(i-1+info.fi1{idir}).name];
  imwrite(uint16(inter(:,:,i)'+shift),nomfin); 
end


% Change to start directory
cd(startdir);

end