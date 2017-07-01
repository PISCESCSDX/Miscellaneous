function [rvec,fspec] = moviefspec(movfile,cp,Nphi)
%==========================================================================
%function [rvec,fspec] = moviefspec(cp,Nphi)
%--------------------------------------------------------------------------
% Jun-15-2013, C. Brandt, San Diego
% MOVIEFSPEC calculates the average radial frequency spectrum from camera
% movies recorded along a cylindrical plasma column.
%--------------------------------------------------------------------------
%INPUT
%  movfile: string of movie file (*.cine)
%  cp: center position (cp(1) row or vertical, cp(2) column or horizontal)
%  Nphi: number of azimuthal points
%OUTPUT
%  rvec: vector of radial pixel positions (unit: pixels)
%  fspec: array of azimuthally averaged frequency spectra
%--------------------------------------------------------------------------
%EXAMPLE
% movfile='18662_f650_ap1.7.cine';
% cp = [64 64];
% Nphi = 64;
% [rvec,fspec] = moviefspec(movfile,cp,Nphi);
%==========================================================================

% Get information about cine movie file
info_cine = cineInfo(movfile);

% --- Determine lowest distance from center position to boundary of data --
% (This is the maximum of the radial vector.)
% Get dimensions of matrix
sizever = info_cine.Height;
sizehor = info_cine.Width;

% Distances from center position:
 distLeft = cp(2) - 1;
distRight = sizehor - cp(2);
   distUp = sizever - cp(1);
 distDown = cp(1) - 1;
% Minimal distance:
mindist = matmin([distLeft distRight distUp distDown]);


% --- Create array of radial-azimuthal pixels ---
rvec = (1:1:mindist)';
% --- Create radial-azimuthal array (zero in the center) ---
phi = ((1:Nphi+1)'/Nphi)*2*pi;
% Meshgrid
[Mrad,Mphi] = meshgrid(rvec,phi);

% Help array = azimuthal array (zero center) + cp
xi = round( Mrad.*cos(Mphi) + cp(2) );
yi = round( Mrad.*sin(Mphi) + cp(1) );

% Create pixel array 'pix'
ctr = 0;
pix = zeros(size(xi,1)*size(xi,2),2);
for j=1:size(xi,2)
  % TEST testpic = zeros(size(xi,1),size(xi,2));
  for k=1:size(xi,1)
    ctr = ctr+1;
    pix(ctr,:) = [yi(k,j) xi(k,j)];
    % TEST testpic(pix(ctr,1),pix(ctr,2)) = 1;
  end
  % TEST pcolor(testpic); shading flat
end

% Read time traces of all the pixels
chk = 'checkplot-on';
[tt,P] = pixel2tt(movfile,pix,chk);

% Calculate frequency spectra for each radius and average
winrat = 1;
olap = 0.5;

[~,freq] = fftwindowparameter(length(tt),winrat,olap,1/(tt(2)-tt(1)),[]);
lfreq = length(freq.total);
amp = zeros(lfreq,Nphi); pha = amp;
fspec.amp = zeros(lfreq,length(rvec));
ctr = 0;
for j=1:size(xi,2)
  for k=1:size(xi,1)
    ctr = ctr+1;
    sig = P(:,ctr) - mean(P(:,ctr));
    [fre amp(:,k) pha(:,k)] = fftspec(tt,sig,winrat,olap);
  end
  % Average frequency plots azimuthally
  fspec.amp(:,j) = mean(amp,2);
  fspec.pha(:,j) = mean(pha,2);
end
fspec.fre = fre;

end