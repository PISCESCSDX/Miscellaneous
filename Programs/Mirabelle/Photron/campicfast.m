function [pic, stplot, Ft] = campicfast(t0, tavg, r, num, cp, teston)
%==========================================================================
%function [pic, stplot, Ft] = camfastpicture(t0, tavg, r, num, cp, teston)
%--------------------------------------------------------------------------
% CAMPICFAST calculates an image at time "t0" with removed average. The
% average is calculated in the time interval "tavg".
% Further CAMPICFAST calculates the pixel data of an azimuthal array with
% "num" values taken at a radius "r" with the center being at "cp".
%--------------------------------------------------------------------------
% IN: t0:   time point of the picture
%     tavg: [t1 t2] time intervall used for average
%     r:    radius for the azimuthal array (in pixels)
%     num:  number of virtual equally distanced pixel probes
%     cp:   central pixel position, cp = [xc, yc]
%     teston: 0: no testpicture (default), 1: on
%OUT: pic:  picture data
%     stplot: structure array: A: space-time data, tt time, phi: angle
%     Ft:   structure array: fre frequency vector; amp: amplitude vector
% EX: t0=0; tavg=[0 2e-3]; r=50; num=64; cp=[100 100];
%     [pic, stplot, Ft] = camfastpicture(t0, tavg, r, num, cp)
%==========================================================================

if nargin<6; teston=0; end
if nargin<4; num=64; end

% Load camera parameter file
filecih = dir('*.cih');
filestr = filecih(1).name(1:end-4);
%tif = dir([filestr '*.tif']);
tif = dir(['sym4*.tif']);

% Load sample frequency
fs = readcih(filecih(1).name);
dt = 1/fs;

% Calculate indices from times
i0 = round(t0/dt) + 1;
i1 = round(tavg(1)/dt)+1;
i2 = round(tavg(2)/dt)+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load image and make averaged image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preallocate variables
helppic = double(imread(tif(1).name));
szx = size(helppic,1);
szy = size(helppic,2); clear helppic
before = zeros(szx, szy, (i2-i1));
ctr = 0;
disp('loading files ...')
for i=i1:i2
  ctr = ctr+1;
  curfile = tif(i).name;
  before(:,:,ctr) = double(imread(curfile));
end

% Average image
aver = mean(before,3);
aver = double(aver);
% vielleicht nicht gebraucht: shift=max(max(aver));

pic = double(imread(tif(i0).name)) - aver;
% set boundaries to zero, avg of boundaries
avg = mean( [mean(pic(1:end,1)); mean(pic(1:end,end)); ...
       mean(pic(1,1:end)); mean(pic(end,1:end))] );
pic = pic - avg;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make space-time plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 0; stplot.A = []; stplot.tt = [];
for i=i1:i2
  ctr = ctr+1;
  curfile = tif(i).name;
  currpic = double(imread(curfile))-aver;
  [stplot.phi, Avec, coupic] = camextractcou(currpic, r, num, cp);
  stplot.A = [stplot.A Avec'];
  stplot.tt= [stplot.tt; i*dt];
end

if teston==1
  % camera picture
  figeps(10,10,2,100,100);
  axes('position', [0.17 0.15 0.80 0.80]);
  pcolor(coupic); shading flat
  mkplotnice('y (pixel)', 'x (pixel)', 12, -30);
  input('<<< press enter to continue >>>');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ctr = 0; tt = []; A = [];
for i=1:round(length(tif)/2)
  ctr = ctr+1;
  curfile = tif(i).name;
  currpic = double(imread(curfile))-aver;
  [phi, Avec] = camextractcou(currpic, r, num, cp);
  A = [A Avec'];
  tt= [tt; i*dt];
end
ctr = 0; amp = 0;
for i=1:size(A,1)
  [Ft.f ahel pha] = cbfft(tt, A(i,:)', [1 60e3], 0.7, 0.5);
  amp = amp + ahel;
end
Ft.a = amp/size(A,1);

end