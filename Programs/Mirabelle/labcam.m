function labcam(t0, tavg, r, num, cp, teston)
%==========================================================================
%function labcam(t0, tavg, r, num, cp, teston)
%--------------------------------------------------------------------------
% LABCAM plots the results of the function CAMPICFAST.
%--------------------------------------------------------------------------
% IN: t0:   time point of the picture
%     tavg: [t1 t2] time intervall used for average
%     r:    radius for the azimuthal array (in pixels)
%     num:  number of virtual equally distanced pixel probes
%     cp:   central pixel position, cp = [xc, yc]
%     teston: 0: no testpicture (default), 1: on
%OUT: pic:  picture data
%     stplot: structure array: A: space-time data, tt time, phi: angle
% EX: t0=0; tavg=[0 2e-3]; r=50; num=64; cp=[100 100];
%     labcam(t0, tavg, r, num, cp)
%
% t0=5e-3; tavg=[t0 t0+8e-3]; r=40; num=64; cp=[95 95]; labcam(t0, tavg, r,
% num, cp, 1)
%==========================================================================

fonts = 12;

% Calculate the 2D picture with removed average and the space-time plot
[pic, stplot, Ft] = campicfast(t0, tavg, r, num, cp, teston);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figeps(16,15,1,52.6,37.1);
ax{1} = [0.10 0.59 0.37 0.38];
ax{3} = [0.58 0.59 0.38 0.38];
ax{2} = [0.10 0.10 0.87 0.38];


% camera picture
axes('position', ax{1});
xpix = 1:size(pic,1);
ypix = 1:size(pic,2);
pcolor(ypix,xpix,pic);
set(gca, 'xlim', [0 ypix(end)+1])
set(gca, 'ylim', [0 xpix(end)+1])
shading flat
colormap pastell
mkplotnice('y (pixel)', 'x (pixel)', fonts, -30);

% Space-time diagram
axes('position', ax{2})
pcolor(stplot.tt*1e3, stplot.phi, stplot.A);
shading interp
colormap pastell
mkplotnice('time (ms)', '\phi (\pi)', fonts, -30);

% Frequency spectrum
f = Ft.f/1e3;
axes('position', ax{3})
plot(f, 20*log10(Ft.a), 'k')
set(gca, 'xlim', [2*f(1)-f(2) f(end)+f(2)-f(1)])
mkplotnice('f (kHz)', 'S (dB)', fonts, -30);

end