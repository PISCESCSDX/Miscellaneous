function [rvec, mavg] = Matrix2dAzimuthAvg(mat, cp, resphi)
%==========================================================================
%function [rvec, mavg] = Matrix2dAzimuthAvg(mat, cp, resphi)
%--------------------------------------------------------------------------
% Jun-14-2013, C. Brandt, San Diego
% MATRIX2DAZIMUTHAVG calculates the azimuthally averaged vector of matrix
% 'mat' around the center position 'cp'.
%--------------------------------------------------------------------------
%INPUT
%  mat: 2D data matrix
%  cp: coordinates of center position [centerrow centercolumn]
%  (optional) resphi: resolution of azimuthal angle (default: 64)
%OUTPUT
%  rvec: radial vector
%  mavg: azimuthally averaged vector
%--------------------------------------------------------------------------
%EXAMPLE
% mat = peaks(128); cp = [80 70]; fonts = 12; resphi = 64;
% [rvec, mavg] = Matrix2dAzimuthAvg(mat, cp, resphi);
% 
% figeps(16,16,1); clf;
% subplot(2,2,1)
% pcolor(mat); shading flat
% line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% 
% axis square
% title('initial matrix','FontSize',fonts)
% mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');
% 
% subplot(2,2,2)
% pcolor(mavg); shading flat
% axis square
% title('radial-azimuthal matrix','FontSize',fonts)
% mkplotnice('r (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');
% 
% subplot(2,2,3)
% plot(rvec,mean(mavg,1))
% set(gca,'xlim',[rvec(1) rvec(end)])
% title('average radial profile','FontSize',fonts)
% mkplotnice('r (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');
% 
% subplot(2,2,4)
% y = std(mavg,1)';
% plot(rvec,y)
% set(gca,'xlim',[rvec(1) rvec(end)])
% title('standard deviation of avg','FontSize',fonts)
% mkplotnice('r (arb.u.)','\sigma of avg. (arb.u.)',fonts,'-20','-35');
% int = int_discrete(rvec,y);
% str = ['\int y dr = ' sprintf('%.3f',int)];
% puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
%==========================================================================

if nargin<3; resphi=64; end

% Get dimensions of matrix
sizever = size(mat,1);
sizehor = size(mat,2);

% --- Determine lowest distance from center position to boundary of data --
% (This is the maximum of the radial vector.)
% Distances from center position:
 distLeft = cp(2) - 1;
distRight = sizehor - cp(2);
   distUp = sizever - cp(1);
 distDown = cp(1) - 1;
% Minimal distance:
mindist = matmin([distLeft distRight distUp distDown]);

% --- Create radial-azimuthal array (zero in the center) ---
 phi = ((1:resphi+1)'/resphi)*2*pi;
rvec = (0:1:mindist)';
% Meshgrid
[Mrad,Mphi] = meshgrid(rvec,phi);

% --- Calculate interpolated points at azimuthal array ---
% Help array = azimuthal array (zero center) + cp
xi = Mrad.*cos(Mphi) + cp(2);  % xi means horizontal
yi = Mrad.*sin(Mphi) + cp(1);  % yi means vertical

% Old coordinates
x = (1:1:sizehor)';
y = (1:1:sizever)';
[X,Y] = meshgrid(x,y);
mavg = interp2(X,Y,mat,xi,yi);

end