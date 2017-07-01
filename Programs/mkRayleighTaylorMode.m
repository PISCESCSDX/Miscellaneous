% Aug-16-2013 13:39 C. Brandt, San Diego
% This m-file is for extracting a space-time plot of the counter-rotating
% center mode structure. Probably belonging to the Rayleigh-Taylor mode


% =======================================================================
% Calculations for plots
% =======================================================================
% Define movie file
movfile= '18428_f650_ap1.4.cine';
% Define center pixel (of azimuthal cross-section
cp = [60 64];
% Define number of points in azimuthal direction
Nphi = 64;
phi = ((1:Nphi+1)'/Nphi)*2*pi;
% Define radial position (in units of pixels)
rad = 13;

% Help array = azimuthal array (zero center) + cp
xi = round( rad*cos(phi) + cp(2) );
yi = round( rad*sin(phi) + cp(1) );

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


%==========================================================================
% Plot Business
%--------------------------------------------------------------------------
fonts = 12;
figx=12; figeps(figx,8.5,1); clf; epsx = num2str( round(7.5*figx) );
x0 = 0.12; y0 = 0.16;
xw = 0.75; yw = 0.38;
dx = 0.00; dy = 0.44;
j=0;
j=j+1; ax{j} = [x0 y0+1*dy xw yw];
j=j+1; ax{j} = [x0 y0+0*dy xw yw];
j=0;

xlim=[0 1];

% Remove average
avg = ones(size(P,1),1) * mean(P);
A = P - avg;
% Filtering
  % sample frequency
  fs = 500e3;
  % Define filter frequencies
  flo = 12000; Fst = 2*flo/fs;
  fpa = flo+1e3;  Fp = 2*fpa/fs;
  % Use a zero-phase shift filter (filtfilt)
  f_fi = 35000; Fst = 4*f_fi/fs;
  d =fdesign.highpass('N,F3dB',32,Fst);
  Hd= design(d,'butter');
  A_hi = filtfilt(Hd.sosMatrix,Hd.ScaleValues,A);
  
  % Cut the edges (are not usable after filtering)
  delta = 500;
  ind = 1+delta:size(A,1)-delta;
  A = A(ind,:);
  A_hi = A_hi(ind,:);
  tcut = tt(ind); tcut=tcut-tcut(1);
  % subtract offset
  tcut=tcut-0.0059;

% Normalization (along time)
  norm = ones(size(A,1),1) * std(A);
  A_norm = A ./ norm;
  %
  norm = ones(size(A,1),1) * std(A_hi);
  A_hi_norm = A_hi ./ norm;
% Smoothing
  A_norm_sm    = A_norm;
  A_hi_norm_sm = A_hi_norm;

% Phi vector
phi = (0:64)/64*2;

j=0;
j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_norm_sm');
shading interp
colormap(gray)
% set(gca,'clim',0.5*matmax(A_norm_sm)*[-1 1])
set(gca,'clim',2.3*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('-1','\alpha (\pi)',fonts,'-20','-25');
freezeColors;
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,4);
cbfreeze(cb);
puttextonplot(gca,[0 1],5,-15,'(a)',0,fonts,'k');

j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_hi_norm_sm');
shading interp
colormap(gray)
% set(gca,'clim',0.5*matmax(A_hi_norm_sm)*[-1 1])
set(gca,'clim',0.7*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('time (ms)','\alpha (\pi)',fonts,'-23','-25');
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,4);
puttextonplot(gca,[0 1],5,-15,'(b)',0,fonts,'w');

return
fn = ['mkRayleighTaylorMode_x' epsx '-r200_q30.eps'];
print_adv([0 1 0 1],'-r200',fn,30,4);
%==========================================================================
return


[freq mvec kfsp] = kfspec(A, tt, [-8 8], 25e3, 40, 0.5);

%==========================================================================
% Test plots for detailed investigation of filtering, smoothing, normal.
%--------------------------------------------------------------------------
figx = 12; 
figeps(figx,8,1);
figeps(figx,8,2);
figeps(figx,8,3);

figure(1); clf; j=0;
j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A');
shading interp
colormap(sunset(33))
set(gca,'clim',200*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('-1','\alpha (\pi)',fonts,'-20','-25');
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,3);
title('filtered')

j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_hi');
shading interp
colormap(sunset(33))
set(gca,'clim',100*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('time (ms)','\alpha (\pi)',fonts,'-20','-25');
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,3);


figure(2); clf; j=0;
j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_norm');
shading interp
colormap(sunset(33))
set(gca,'clim',0.5*matmax(A_norm)*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('-1','\alpha (\pi)',fonts,'-20','-25');
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,3);
title('filtered & normalized (along t)')

j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_hi_norm');
shading interp
colormap(sunset(33))
set(gca,'clim',0.5*matmax(A_hi_norm)*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('time (ms)','\alpha (\pi)',fonts,'-20','-25');
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,3);


figure(3); clf; j=0;
j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_norm_sm');
shading interp
colormap(gray)
set(gca,'clim',0.5*matmax(A_norm_sm)*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('-1','\alpha (\pi)',fonts,'-20','-25');
freezeColors;
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,3);
cbfreeze(cb);
title('filtered, normalized & smoothed')

j=j+1; axes('Position',ax{j})
pcolor(tcut*1e3,phi,A_hi_norm_sm');
shading interp
colormap(gray)
set(gca,'clim',0.5*matmax(A_hi_norm_sm)*[-1 1])
set(gca,'xlim',xlim)
mkplotnice('time (ms)','\alpha (\pi)',fonts,'-20','-25');
cb = mknicecolorbar('EastOutside','p / \sigma',fonts,0.15,0.1,3);


% Frequency spectra (for checking the filter)
x = A(:,1);
h=fdesign.highpass('N,F3dB', 32,Fst);
d1 = design(h,'butter');
y = filtfilt(d1.sosMatrix,d1.ScaleValues,x);

figure;
subplot(2,1,1);
plot(x,'b:'); hold on;
plot(y,'r','linewidth',3);
subplot(2,1,2);
  [f a ~] = fftspec(tcut, x);
  [f1 a1 ~] = fftspec(tcut, y);
  plot(f,1.1*a,'b:'); hold on
  plot(f1,a1,'r','linewidth',3)
legend('Noisy ECG','Zero-phase Filtering','location','NorthEast');