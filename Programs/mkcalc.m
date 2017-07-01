% Sep 9 2012, C. Brandt, San Diego
% Guide to evaluate camera data by using Fourier decomposition

% Number of index to investigate
index_investigate = 6;

I_B = [130 160 190 230 260 290 320 360 390 420 460 490 520 560 ...
       590 620 650 680 720 750 780];
a = dir('*f650*.cine');
q = dir('*f650*statistics*mat');

load(q(index_investigate).name);

% --- BEGIN: Find the best center ---
% pixel range to find center
rd = 10;
% Resolution of azimuthal angle
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
% --- END: Find the best center ---

% (1) Find the cut range of the rawdata frames
%=============================================
% ### Input: filename of movie
fn = a(6).name;
% Save info.mat with video information
info = cineInfo(fn); save info.mat info
% read first image
pic = double(cineRead(fn,1));
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
% ### Input: left-right range and up-down range
cut.ud = cp(1)-mindist:cp(1)+mindist;
cut.lr = cp(2)-mindist:cp(2)+mindist;
% plot image and check cut range
pcolor(pic(cut.ud,cut.lr)); shading flat; axis square
inp = input('Is the cutting range ok?  (y: enter, n: 0)  ');
if ~isempty(inp); return; end
close all


% (2) Preprocess video
%=====================
% ### Input: path to video files
filepath = 'G:\work_20130615\rawdata\20130531_CSDX_camera_filters\';
data.fn{1} = [filepath fn];
% parameters for preprocessing
data.statfile{1} = [filepath '18422_f650_ap1.4_statistics.mat'];
data.fr1{1} = 1;          % start frame
data.frN{1} = 5000;       % end frame
data.den{1} = 0;          % denoise on/off
data.cut{1}.ud = cut.ud;  % cut up-down
data.cut{1}.lr = cut.lr;  % cut left-right
fastmode = 1;
improcess8(data,fastmode); return

% % (4) Calculate average light intensities/fluctuation level: mksum.m
% %=====================
% mksum
% 
% % (5) Manually: go to a/ folder and use centerpixeltest.m to determine
% %     the centerpixel
% di='a/'; fn='a*.tif'; cp=[50 48]; r=20; np=64;
% centerpixeltest(di, fn, cp, r, np)
% return

% (6) Manually: run fft-decomposition: mkfftdec.m
%  6.1 Input correct video file name
%  6.2 Input center pixel cp
%  6.3 Input correct px2r value
mkfftdec
return



%==========================================================================
% Play Cine Video
%--------------------------------------------------------------------------
% Read the video info
info = cineInfo(fn);
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