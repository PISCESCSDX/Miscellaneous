% % Aug-16-2013 13:39 C. Brandt, San Diego
% % This m-file is for extracting a space-time plot of the counter-rotating
% % center mode structure. Probably belonging to the Rayleigh-Taylor mode
% 
% 
% 
% %==========================================================================
% % Prepare Centermode Data
% % (Size for Two-column Paper, single colum figure)
% %--------------------------------------------------------------------------
% I_B = [130 160 190 230 260 290 320 360 390 420 460 ...
%        490 520 560 590 620 650 680 720 750 780];
% B_shots = B_CSDX(I_B);
% shots = [12 13 14];
% 
% cp.shots = shots;
% cp.B_shots = B_shots;
% cp.xlim = 7.5*[-1 1];
% cp.ylim = cp.xlim;
% cp.clim = 2.1*[-1 1];
%     
% d1 = 10; d2 = 10; d3 = 20;
% filebase{1} = '18428_f650_ap1.4'; iframe{1} = 150;
% filebase{2} = '18429_f650_ap1.4'; iframe{2} = 110;
% filebase{3} = '18430_f650_ap1.4'; iframe{3} = 430;
%     
% 
% % Smoothing points of picture
% sm = 2;
% % Pixel to cm conversion
% pix2r = 0.1333;
% % Center position
% xc = 8.5; yc = 7.8;
% 
% for iB = 1:3
%   filename = [filebase{iB} '.cine'];
%   info = cineInfo(filename);
%   fs = info.frameRate;
%   dt = 1/fs;
% 
%   savefn = [filebase{iB} '_statistics.mat'];
%   load(savefn);
%   x=1:size(movstat.avg,1);
%   y=1:size(movstat.avg,2);
% 
%   % Loop over 4 frames for each B-field
%   i=1;
%   picraw = double(cineRead(filename, iframe{iB}(i)));
%   picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
%   picpixstd = (picraw - movstat.avg) ./ movstat.std;
% 
%   pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
%   cp.Xn{iB} = x*pix2r-xc;
%   cp.Yn{iB} = y*pix2r-yc;
%   cp.Zn{iB} = pic;
% end
% save('CenterModePics.mat','cp')
% 
% 
% 
% 
% % =======================================================================
% % Calculations for space time plots
% % =======================================================================
% % Define movie file
% movfile= '18428_f650_ap1.4.cine';
% % Define center pixel (of azimuthal cross-section
% cp = [60 64];
% % Define number of points in azimuthal direction
% Nphi = 64;
% phi = ((1:Nphi+1)'/Nphi)*2*pi;
% % Define radial position (in units of pixels)
% rad = 13;
% 
% % Help array = azimuthal array (zero center) + cp
% xi = round( rad*cos(phi) + cp(2) );
% yi = round( rad*sin(phi) + cp(1) );
% 
% % Create pixel array 'pix'
% ctr = 0;
% pix = zeros(size(xi,1)*size(xi,2),2);
% for j=1:size(xi,2)
%   % TEST testpic = zeros(size(xi,1),size(xi,2));
%   for k=1:size(xi,1)
%     ctr = ctr+1;
%     pix(ctr,:) = [yi(k,j) xi(k,j)];
%     % TEST testpic(pix(ctr,1),pix(ctr,2)) = 1;
%   end
%   % TEST pcolor(testpic); shading flat
% end
% 
% % Read time traces of all the pixels
% chk = 'checkplot-on';
% [tt,P] = pixel2tt(movfile,pix,chk);
% 
% % Calculate frequency spectra for each radius and average
% winrat = 1;
% olap = 0.5;
% 
% [~,freq] = fftwindowparameter(length(tt),winrat,olap,1/(tt(2)-tt(1)),[]);
% lfreq = length(freq.total);
% amp = zeros(lfreq,Nphi); pha = amp;
% ctr = 0;
% for j=1:size(xi,2)
%   for k=1:size(xi,1)
%     ctr = ctr+1;
%     sig = P(:,ctr) - mean(P(:,ctr));
%     [fre amp(:,k) pha(:,k)] = fftspec(tt,sig,winrat,olap);
%   end
%   % Average frequency plots azimuthally
%   fspec.amp(:,j) = mean(amp,2);
%   fspec.pha(:,j) = mean(pha,2);
% end
% fspec.fre = fre;
% 
% 
% % Remove average
% avg = ones(size(P,1),1) * mean(P);
% A = P - avg;
% % Filtering
%   % sample frequency
%   fs = 500e3;
%   % Define filter frequencies
%   flo = 12000; Fst = 2*flo/fs;
%   fpa = flo+1e3;  Fp = 2*fpa/fs;
%   % Use a zero-phase shift filter (filtfilt)
%   f_fi = 35000; Fst = 4*f_fi/fs;
%   d =fdesign.highpass('N,F3dB',32,Fst);
%   Hd= design(d,'butter');
%   A_hi = filtfilt(Hd.sosMatrix,Hd.ScaleValues,A);
%   
%   % Cut the edges (are not usable after filtering)
%   delta = 500;
%   ind = 1+delta:size(A,1)-delta;
%   A = A(ind,:);
%   A_hi = A_hi(ind,:);
%   tcut = tt(ind); tcut=tcut-tcut(1);
%   % subtract offset
%   tcut=tcut-0.0059;
% 
% % Normalization (along time)
%   norm = ones(size(A,1),1) * std(A);
%   A_norm = A ./ norm;
%   %
%   norm = ones(size(A,1),1) * std(A_hi);
%   A_hi_norm = A_hi ./ norm;
% % Smoothing
%   A_norm_sm    = A_norm;
%   A_hi_norm_sm = A_hi_norm;
% 
% % Phi vector
% phi = (0:64)/64*2;
% 
% Or.Xn = tcut*1e3;
% Or.Yn = phi;
% Or.Zn = A_norm_sm';
% Fi.Xn = tcut*1e3;
% Fi.Yn = phi;
% Fi.Zn = A_hi_norm_sm';
% save('CenterMode_filtered.mat','Or','Fi')




%==========================================================================
% Plot Business
%--------------------------------------------------------------------------
% Figure Parameters
figx = 12;
figeps(12,9.1,1); clf; epsx = num2str( round(7.5*figx) );
fonts = 12;

x0 = 0.11; y0 = 0.14;
xw1 = 0.24; yw1 = 0.33;
dx1 = 0.27; dy1 = 0.46;
xw2 = 0.33; yw2 = 0.30;
dx2 = 0.45; dy2 = 0.25; 
j=0;
j=j+1; ax{j} = [x0+0*dx2 y0+0*dy2 xw2 yw2];
j=j+1; ax{j} = [x0+1*dx2 y0+0*dy2 xw2 yw2];
j=j+1; ax{j} = [x0+0*dx1 y0+dy1 xw1 yw1];
j=j+1; ax{j} = [x0+1*dx1 y0+dy1 xw1 yw1];
j=j+1; ax{j} = [x0+2*dx1 y0+dy1 xw1 yw1];

lbl = {'(d)','(e)','(a)','(b)','(c)'};

xlim=[0 0.6]; xtick = [0:0.2:0.6];
load('CenterMode_filtered.mat');
j=0;
j=j+1; axes('Position',ax{j})
Or.Zn = smooth2dBrandt(Or.Zn,3,3);
pcolor(Or.Xn,Or.Yn,Or.Zn);
shading interp
colormap(gray)
set(gca,'clim',2.3*[-1 1])
set(gca,'xlim',xlim,'xtick',xtick)
mkplotnice('time (ms)','\theta (\pi)',fonts,'-23','-25');
freezeColors;
cb = mknicecolorbar('EastOutside', ...
  '(p-{\langle}p{\rangle}) / \sigma_{xy}',fonts-2,0.15,0.1,4.5);
cbfreeze(cb);
puttextonplot(gca,[0 1],5,-15,lbl{j},0,fonts,'k');

j=j+1; axes('Position',ax{j})
Fi.Zn = smooth2dBrandt(Fi.Zn,3,3);
pcolor(Fi.Xn,Fi.Yn,Fi.Zn);
shading interp
colormap(gray)
set(gca,'clim',1.3*[-1 1])
set(gca,'xlim',xlim,'xtick',xtick)
mkplotnice('time (ms)','-1',fonts,'-23','-25');
cb = mknicecolorbar('EastOutside', ...
  '(p-{\langle}p{\rangle}) / \sigma_{xy}',fonts-2,0.15,0.1,5.0);
puttextonplot(gca,[0 1],5,-15,lbl{j},0,fonts,'k');

%------------------------------------------------------------- Camera plots
load('CenterModePics.mat')
for iB = 1:3
  j=j+1; axes('Position',ax{j})
  pcolor(cp.Xn{iB},cp.Yn{iB},cp.Zn{iB}); shading interp
  colormap(gray(64))
  set(gca,'clim', cp.clim)
  set(gca,'xlim',cp.xlim,'ylim',cp.xlim)
  if iB==1; lby = 'y (cm)'; else lby = '-1'; end
  lbx = 'x (cm)';
  mkplotnice(lbx, lby, fonts, '-21', '-25');
  if iB ==3
  mknicecolorbar('EastOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
    fonts-2, 0.15, 0.1, 5);
  end
  Bstr = ['B=' sprintf('%.0f', 10*round(1e2*(cp.B_shots(cp.shots(iB)))) ) 'mT'];
  puttextonplot(gca, [0 1],20,13,Bstr,0,fonts,'k');
  puttextonplot(gca, [0 1],4,-12,lbl{j},0,fonts,'w');
end

fn = ['mkRayleighTaylorMode_Bscan_at_threshold_x' epsx '-r200_q30.eps'];
print_adv([0 1 1 1  0 1  0 1],'-r300',fn,40,4);
%==========================================================================