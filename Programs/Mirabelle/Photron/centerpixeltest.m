function centerpixeltest(di, fn, cp, r, np, dt)
%==========================================================================
%function centerpixeltest(di, fn, cp, r, np, dt)
%--------------------------------------------------------------------------
% CENTERPIXELTEST is a m-file for testing whether the coordinates 'cp'
% are in the center of rotating structures.
% 1. It opens the pictures taken from files 'fn'.
% 2. it plays the movie with a circle plotted around the point cp.
%--------------------------------------------------------------------------
% IN: di: string of directory
%     fn: string for camera files, e.g. 'sym4*.tif'
%     cp: centerpixel, e.g. [95 90]
%      r: radius (in pixel) where the pixel probe array should be plotted
%     np: number of "pixel probes"
%     dt: time delay between frames (s)
%--------------------------------------------------------------------------
% EXAMPLE
% di='a/'; fn='a*.tif'; cp=[40 40]; r=10; np=64; dt=0.1;
% centerpixeltest(di, fn, cp, r, np, dt)
%==========================================================================

if nargin<6; dt = 0.1; end
if nargin<4; np = 64; end
if nargin<3; r  = 30; end

a = dir([di fn]);
load shift.mat
shift = vid.shift;

figeps(10,10,1,10,10);
  
for i=1:1:length(a)
  n = double(imread([di a(i).name])) - shift;
  n = n/shift;
  % extract artificial probe array
  [~, ~, piccou] = camextractcou(n, r, np, cp);
  clf
  pcolor(piccou); shading flat
  axis equal
  pause(dt)
end

end