% Sep-10-2013, C. Brandt, San Diego 
% Jul-10-2013, C. Brandt, ICE Nuernberg -> Hamburg
% Jul-06-2013, C. Brandt, Pantelitz
% Jul-05-2013, C. Brandt, Helsinki
% m-file for replacing mkcalc.m to pre-process video data
%
% Manual:
% 1. Check all ### INPUTs in this file and Run it
% 2. Output is a phase data matrix and a folder with fft decomposition file
%    for each frame

% Just for information: current of magnetic field
% I_B = [130 160 190 230 260 290 320 360 390 420 460 490 520 560 ...
%        590 620 650 680 720 750 780];

% ### INPUT: filenames of movie and statistic file
mov.path  = '/home/csdx/20130531_CSDX_camera_filters';
filebase = '18427_f650_ap1.4';
%filebase = '18418_nofi_ap2.0';
mov.fn    = [filebase '.cine'];

if ~isdir(filebase);
  mkdir(filebase);
end
fftdec.savebase = filebase;


% ### Input: If needed activate the statistic calculation
fct_a_moviestatistic(filebase);

mov.pathfn = [mov.path '/' mov.fn];
mov.avg.fn = [filebase '_statistics.mat'];
mov.avg.pathfn = [mov.path '/' mov.avg.fn];

% ### INPUT: pixel to millimeter conversion (one pixel is ... mm)
fftdec.pix2r = 1.333;

% Load statistic file
load(mov.avg.pathfn);


%==========================================================================
% Find the optimal center
%--------------------------------------------------------------------------
% # INPUT: pixel range to find center
rd = 10;
% # INPUT: Resolution of azimuthal angle
resphi = 128;
% load averaged image picture
matavg = movstat.avg;
% Find start value: maximum of mat
[v1, i1] = max(matavg);
[ ~, colmax] = max(v1);
rowmax = i1(colmax);
vrow = -rd:1:rd;  vcol = vrow;
int = zeros(numel(vrow),numel(vcol));
for irow = 1:length(vrow)
  for icol = 1:length(vcol)
    cptest = [rowmax+vrow(irow) colmax+vcol(icol)];
    [rvec, mavg] = Matrix2dAzimuthAvg(matavg, cptest, resphi);
    y = std(mavg,1)';
    % Integration of standard deviation is a measure of deviation:
    int(irow,icol) = int_discrete(rvec,y);
  end
end
% Find indices of local minimum of integration matrix 'int'
[v1, i1] = min(int);
[ ~, colmin] = min(v1);
rowmin = i1(colmin);
% Store new center position to variable
cp = [rowmax+vrow(rowmin) colmax+vcol(colmin)];
% Show Testplot
matavg = matavg./matmax(matavg);
matavg(cp(1),cp(2)) = 2;
pcolor(matavg); shading flat; axis square; set(gca,'clim',[0 1.2])
inp = input('Is the center ok? (yes: Enter, no: 0)');
if ~isempty(inp); return; end
%==========================================================================


%==========================================================================
% Find the cut range of the rawdata frames
%--------------------------------------------------------------------------
% # Input: filename of movie
% Save info.mat with video information
fftdec.info = cineInfo(mov.pathfn);
fftdec.moviefile = mov.pathfn;
fftdec.statfile  = mov.avg.pathfn;
% Read first image to determine image size for pre-allocation
pic = double(cineRead(mov.pathfn,1));
disp(['Size of pic: ' num2str(size(pic))])
% Get dimensions of matrix
sizever = size(pic,1);
sizehor = size(pic,2);
% --- Determine lowest distance from center position to boundary of data --
% (This is the maximum of the radial vector.)
% Distances from center position:
 distLeft = cp(2) - 1;
distRight = sizehor - cp(2);
   distUp = sizever - cp(1);
 distDown = cp(1) - 1;
% Minimal distance:
mindist = matmin([distLeft distRight distUp distDown]);
% # INPUT: left-right range and up-down range
cut.ud = cp(1)-mindist:cp(1)+mindist;
cut.lr = cp(2)-mindist:cp(2)+mindist;
% plot image and check cut range
pcolor(pic(cut.ud,cut.lr)); shading flat; axis square
inp = input('Is the cutting range ok?  (y: enter, n: 0)  ');
if ~isempty(inp); return; end
close all
%==========================================================================


%==========================================================================
% FFT decomposition of single light fluctuation images
%--------------------------------------------------------------------------
% Do not use improcess8, instead just use camerastatistics and mksum!
% Define FFT data range
fftdec.startframe = 1;
fftdec.endframe   = fftdec.info.NumFrames;
% Define center pixel
fftdec.cp = cp;
% Define cut range
fftdec.cut.ud = cut.ud;
fftdec.cut.lr = cut.lr;
% Number of azimuthal pixel probes
fftdec.resphi = resphi;
% ### Input: Details of radial decomposition
fftdec.dr = 1;
fftdec.rmin = 1;
fftdec.rmax = mindist;
% ### Input: mode vector
fftdec.m = 0:5;

% Transfer light fluctuation quantities to variable 'fftdec'
fftdec.lightfluc.std2 = movstat.lightfluc.std2;
fftdec.lightfluc.amp = movstat.lightfluc.amp;
fftdec.movieavg = movstat.avg;

% Do the FFT Decomposition
FFTDecompAzimuth(fftdec);
return
%==========================================================================


%==========================================================================
% Play Cine Video
%--------------------------------------------------------------------------
% Read the first frame
fnum = 1;
cdata = cineRead(fn,fnum);

figeps(15,8,1);
for i=1:1000
  cdata = double(cineRead(fn, i));
  clf;
  pcolor(cdata); axis equal
  set(gca, 'clim', [1 3000])
  shading flat
  pause(0.1)
end
%==========================================================================