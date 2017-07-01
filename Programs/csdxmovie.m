filebase = '18437_f650_ap1.4';
filename = [filebase '.cine'];
info = cineInfo(filename);

N = info.NumFrames;
fs = info.frameRate;
dt = 1/fs;

% %==========================================================================
% % Calculate Average
% %--------------------------------------------------------------------------
% % movstat.avg = 0;
% % for i=1:N
% %   disp_num(i,N);
% %   pic = double(cineRead(filename, i));
% %   movstat.avg = movstat.avg + pic;
% % end
% % movstat.avg = movstat.avg/N;
% % 
% % % Calculate Standard Deviation
% % movstat.std = 0;
% % s = 0;
% % for i=1:N
% %   disp_num(i,N);
% %   pic = double(cineRead(filename, i));
% %   hv = (pic - movstat.avg).^2;
% %   s = s + hv;
% % end
% % movstat.std = sqrt(s/N);
% % savefn = [filebase '_statistics.mat'];
% % save(savefn,'movstat');
% % return
% %==========================================================================
% 
%==========================================================================
% Play movie
%--------------------------------------------------------------------------
% savefn = [filebase '_statistics.mat'];
% load(savefn);
% x=1:size(movstat.avg,1);
% y=1:size(movstat.avg,2);
% 
% % number of smoothing points
% sm = 2;
% 
% % Video using PCOLOR
% figeps(17,8,1); clf;
% 
% for i=1:500 % 1:N
%   picraw = double(cineRead(filename, i));
%   pic = (picraw - movstat.avg) ./ movstat.std;
% 
%   axes('Position',[0.03 0.18 0.45 0.74])
%   pcolor(x,y,picraw/1e3)
%   colormap(pastelliceglow(128))
%   shading flat
%   axis square
%   %set(gca,'zLim',[0 500])
%   set(gca,'clim', [000 300]/1e3)
%   freezeColors
%   mkplotnice('x (pixel)', 'y (pixel)', 12, '-27', '-32');
%   our_colorbar('raw image intensity (10^{-3}arb.u.)',10,9,0.015,-0.045);
%   freezeColors
%   
%   axes('Position',[0.52 0.18 0.45 0.74])  
%   pic = smoothBrochard(smoothBrochard(pic,sm)',sm)';
%   pcolor(x,y,pic)
%   %surf(x,y,pic)
% %   [zmax,imax,zmin,imin] = extrema2(pic);
% %   [iminy,iminx] = ind2sub([128 128],imin);
% %   [imaxy,imaxx] = ind2sub([128 128],imax);
% %   hold on
% %   plot3(x(imaxx),y(imaxy),zmax,'ro',x(iminx),y(iminy),zmin,'bo')
% %   hold off
%   shading flat
%   axis square
%   %set(gca,'view',[0 90])
%   colormap(pastelldeep(64))
% %   set(gca,'clim', 5*[-1 1])
%   %set(gca,'zLim',[-500 500])
%   set(gca,'zLim',[0 300])
%   set(gca,'clim', 4*[-1 1])
%   %set(gca,'clim', 1.0*matmax(pic)*[0 1])
%   mkplotnice('x (pixel)', '-1', 12, '-27', '-32');
%   tstr = ['\tau=' sprintf('%.3f',1e3*((i-1)*dt)) 'ms'];
%   puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
%   puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
%   our_colorbar('(p-{\langle}p{\rangle}) / \sigma',10,7,0.015,-0.045);
%   % Print
% %   savefn = ['B242mT' num2str(i) '.png'];
% %   print('-dpng','-r100',savefn);
%   pause(0.001); clf
% end
% return
%==========================================================================


%==========================================================================
% Calculate Velocity (Triangle Method)
%--------------------------------------------------------------------------
% t1 = clock_int;
% 
% d = 1; % !!! only odd positive integers make sense
% crco.winrat = 1/5; crco.fend = 20e3;
% pix2r = 1.333e-3;
% indtime = 1:5000;
% calcphstd = 0;
% VF = Velocimetry2D_TriangleMethod_ver10(filename, indtime, d, ...
%   crco, pix2r, calcphstd);
% 
% t2 = clock_int; disp(clockdiff(t1,t2))
% return
%==========================================================================


%==========================================================================
% Plot Velocity Field (1 Figure: 2 Diagrams OR 3 Diagrams)
%--------------------------------------------------------------------------
strvecplot = 'streamslice'; % OR quiver
diavec = [0 1 1];

switch sum(diavec)
  case 2
  fonts = 12; figeps(12,6.7,5, 0,100); clf; j=0;
  x0 = 0.09; dx = 0.425; y0 = 0.18;
  xw = 0.40; yw = 0.73;
  j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
  j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
  j=0;
  lx =   0; ly = 13;
  case 3
  fonts = 12; figeps(12,5.5,5, 0,100); clf; j=0;
  x0 = 0.09; dx = 0.30; y0 = 0.12;
  xw = 0.28; yw = 0.80;
  j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
  j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
  j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
  j=0;
  lx =   0; ly = 17;
end

colstream = rgb('DimGray');
lw = 0.2;
lbl = {'(a)','(b)','(c)'};
xlim = 8*[-1 1]; ylim = xlim;
xtick= -5:5:5; ytick= xtick;

%--------------------------------------- Load and prepare vector field data
vfname = '18437_f650_ap1.4_velo_triangle_d1_t0001-5000_winrat0.20.mat';
load(vfname);
% Resolution for interpolation
pint = 60;
% Define frequency interval
df = 500;

% for fvec = 12000+df:df:20000-df
fa = 13000; fb = 15000;
% fa = fvec; fb = fvec+df;
indf = find( (pa1.freq>fa) & (pa1.freq<fb));
vx = sum(vvec(:,:,indf,1),3) ./ numel(indf);
vy = sum(vvec(:,:,indf,2),3) ./ numel(indf);

% vxavgabs = matmean(abs(vx));
% vyavgabs = matmean(abs(vy));
scale = 3000;
ind = abs(vx)>2*scale; vx(ind) = 0; vy(ind) = 0;
ind = abs(vy)>2*scale; vx(ind) = 0; vy(ind) = 0;
%--------------------------------------------------------- Smoothing Matrix
% for i=jvec
%   disp(num2str(i))
%   vx(i,:) = smooth(jvec,vx(i,:),0.05,'rloess');
%   vy(i,:) = smooth(jvec,vy(i,:),0.05,'rloess');
% end
% for i=jvec
%   disp(num2str(i))
%   vx(:,i) = smooth(jvec,vx(:,i),0.05,'rloess');
%   vy(:,i) = smooth(jvec,vy(:,i),0.05,'rloess');
% end
%--------------------------------------------------- Averaging Vector Field
% Create grids
jvec = 1:128;
xold = jvec*pix2r;
yold = jvec*pix2r;
[~ , ~,Ax] = interp_matrix(xold,yold,vx, pint*[1 1]);
[xn,yn,Ay] = interp_matrix(xold,yold,vy, pint*[1 1]);
% Normalize vectors to chosen 'scale'
scale = 1000;
ux = Ax/scale;
uy = Ay/scale;
uu = sqrt(ux.^2 + uy.^2);
ux = ux./ (2*uu);
uy = uy./ (2*uu);
[X,Y] = meshgrid(xn);
% Normalize and Offset grids
   x = (   X-0.096)*100;
   y = (   Y-0.096)*100;
xold = (xold-0.096)*100;
yold = (yold-0.096)*100;
% Calculate absolute velocity
 v = sqrt(vx.^2 + vy.^2);
% % Wavelet Interpolation (best smooth method here) of absolute velocity
% WaveletLevel = 2;
% vinter = interp_Wavelet(v,WaveletLevel,'sym');
%-------------------------------------------------------------- Quiver plot
if diavec(1)
j=j+1; axes('Position',ax{j});
hp = quiver(x,y,ux,uy);
set(hp,'Color',rgb('Black'),'LineWidth',lw)
hold off
set(gca,'xlim',xlim,'xtick',xtick)
set(gca,'ylim',ylim,'ytick',ytick)
set(hp,'AutoScale','off')
set(hp,'AutoScaleFactor',1.0e0)
if j==1; ylb = 'y (cm)'; else ylb = '-1'; end
mkplotnice('x (cm)',ylb,fonts,'-20','-15');
sfa = mkstring('','0',fa,9999,'');
sfb = mkstring('','0',fb,9999,'');
str2 = ['|v| = ' sprintf('%.0f',scale) ' m/s'];
puttextonplot(gca, [0.45 1],lx-55,ly, [lbl{j} ' ' str2], 0, fonts, 'k');
str1 = ['f = ' sfa '..' sfb ' Hz'];
end
%---------------------------------------------------------- Streamline Plot
%meshvec = [-6:0.5:-4 -3.5:0.8:3.5 4:0.2:6]; streamopt = [0.5 50];
meshvec = xlim(1):0.6:xlim(2); streamopt = [0.5 40];
[X,Y] = meshgrid((meshvec/100)+0.096);
X = (X-0.096)*100;
Y = (Y-0.096)*100;
startx = X; starty = Y;
startx_red = 2; starty_red = -2.8; streamopt_red = [0.5 200];
if diavec(2)
j=j+1; axes('Position',ax{j});
hold on
% STREAMLINE Plot
XY = stream2(x,y,ux,uy,startx,starty,streamopt);
hp = streamline(XY);
for q=1:length(hp)
  set(hp(q),'Color',colstream,'LineWidth',lw)
end
XY_red = stream2(x,y,ux,uy,startx_red,starty_red,streamopt_red);
hp_red = streamline(XY_red);
for q=1:length(hp_red)
  set(hp_red(q),'Color',rgb('Crimson'),'LineWidth',4*lw)
end
hold on
switch strvecplot
  case 'streamslice'
  % -- Use STREAMSLICE as vectorplot --
  [verts averts] = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
  hp = streamline([[] averts]);
  set(hp, 'Color', 'k')
  case 'quiver'
  % -- Use QUIVER as vectorplot --
  hp = quiver(x(1:3:end),y(1:3:end),ux(1:3:end),uy(1:3:end));
  set(hp,'AutoScale','off')
  set(hp,'AutoScaleFactor',1.0e0)
  set(hp,'Color', 'k')
end
hold off
set(gca,'xlim',xlim,'xtick',xtick)
set(gca,'ylim',ylim,'ytick',ytick)
if j==1; ylb = 'y (cm)'; else ylb = '-1'; end
mkplotnice('x (cm)',ylb,fonts,'-20','-20');
puttextonplot(gca, [0.45 1],lx,ly, lbl{j}, 0, fonts, 'k');
end
%--------------------------------------------------------- Streamslice Plot
if diavec(3)
j=j+1; axes('Position',ax{j});
hold on
hp = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
set(hp,'Color',rgb('Black'),'LineWidth',lw)
set(gca,'xlim',xlim,'xtick',xtick)
set(gca,'ylim',ylim,'ytick',ytick)
if j==1; ylb = 'y (cm)'; else ylb = '-1'; end
% PCOLOR Plot
pcolor(xold,yold,vinter/1e3);
shading interp
colormap(gray(64))
set(gca,'clim',[0.0 1.0])
cb=our_colorbar('',fonts-2,0,0.015,0.008,'EastOutside');
set(cb,'ytick',[0 0.5 1.0])
set(cb,'yticklabel',{'0.0','0.5','1.0'})
puttextonplot(gca, [1 1],-13,14,'v (km/s)', 0, fonts-2, 'k');
hold off
mkplotnice('x (cm)',ylb,fonts,'-20','-25');
puttextonplot(gca, [0.45 1],lx,ly, lbl{j}, 0, fonts, 'k');
end
%-------------------------------------------------------------------- Print
return
sfa = mkstring('','0',fa,1e4,'');
sfb = mkstring('','0',fb,1e4,'');
savefn = [filebase '_' vfname(1:end-4) '_dia' ...
  num2str(diavec(1)) num2str(diavec(2)) num2str(diavec(3)) ...
  '_m1large_f' sfa '-' sfb '_pint' num2str(pint) '.eps'];
print('-depsc2',savefn);
%print_adv([0 1 0], '-r300', savefn, 50, 4)
%==========================================================================


% %==========================================================================
% % Plot Velocity Field (1 Figure: 2 Diagrams OR 3 Diagrams)
% %--------------------------------------------------------------------------
% strvecplot = 'streamslice'; % OR quiver
% diavec = [0 1 1];
% 
% switch sum(diavec)
%   case 2
%   fonts = 12; figeps(12,6.7,5, 0,100); clf; j=0;
%   x0 = 0.11; dx = 0.45; y0 = 0.14;
%   xw = 0.42; yw = 0.80;
%   j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
%   j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
%   j=0;
%   lx =   0; ly = 13;
%   case 3
%   fonts = 12; figeps(12,5.5,5, 0,100); clf; j=0;
%   x0 = 0.09; dx = 0.30; y0 = 0.12;
%   xw = 0.28; yw = 0.80;
%   j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
%   j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
%   j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
%   j=0;
%   lx =   0; ly = 17;
% end
% 
% colstream = rgb('DimGray');
% lw = 0.2;
% lbl = {'(a)','(b)','(c)'};
% xlim = 6*[-1 1]; ylim = xlim;
% xtick= -5:5:5; ytick= xtick;
% 
% %--------------------------------------- Load and prepare vector field data
% vfname = 'velo_triangle_d1_t0001-5000_winrat0.20.mat';
% load(vfname);
% % Resolution for interpolation
% pint = 60;
% % Define frequency interval
% df = 500;
% 
% % for fvec = 12000+df:df:20000-df
% fa = 14500; fb = 15000;
% % fa = fvec; fb = fvec+df;
% indf = find( (pa1.freq>fa) & (pa1.freq<fb));
% vx = sum(vvec(:,:,indf,1),3) ./ numel(indf);
% vy = sum(vvec(:,:,indf,2),3) ./ numel(indf);
% 
% % vxavgabs = matmean(abs(vx));
% % vyavgabs = matmean(abs(vy));
% scale = 3000;
% ind = abs(vx)>2*scale; vx(ind) = 0; vy(ind) = 0;
% ind = abs(vy)>2*scale; vx(ind) = 0; vy(ind) = 0;
% %--------------------------------------------------------- Smoothing Matrix
% % for i=jvec
% %   disp(num2str(i))
% %   vx(i,:) = smooth(jvec,vx(i,:),0.05,'rloess');
% %   vy(i,:) = smooth(jvec,vy(i,:),0.05,'rloess');
% % end
% % for i=jvec
% %   disp(num2str(i))
% %   vx(:,i) = smooth(jvec,vx(:,i),0.05,'rloess');
% %   vy(:,i) = smooth(jvec,vy(:,i),0.05,'rloess');
% % end
% %--------------------------------------------------- Averaging Vector Field
% % Create grids
% jvec = 1:128;
% xold = jvec*pix2r;
% yold = jvec*pix2r;
% [~ , ~,Ax] = interp_matrix(xold,yold,vx, pint*[1 1]);
% [xn,yn,Ay] = interp_matrix(xold,yold,vy, pint*[1 1]);
% % Normalize vectors to chosen 'scale'
% ux = Ax/scale;
% uy = Ay/scale;
% [X,Y] = meshgrid(xn);
% % Normalize and Offset grids
%    x = (   X-0.096)*100;
%    y = (   Y-0.096)*100;
% xold = (xold-0.096)*100;
% yold = (yold-0.096)*100;
% % Calculate absolute velocity
%  v = sqrt(vx.^2 + vy.^2);
% % Wavelet Interpolation (best smooth method here) of absolute velocity
% WaveletLevel = 2;
% vinter = interp_Wavelet(v,WaveletLevel,'sym');
% %-------------------------------------------------------------- Quiver plot
% if diavec(1)
% j=j+1; axes('Position',ax{j});
% hp = quiver(x,y,ux,uy);
% set(hp,'Color',rgb('Black'),'LineWidth',lw)
% hold off
% axis square
% hold off
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylim,'ytick',ytick)
% set(hp,'AutoScale','off')
% set(hp,'AutoScaleFactor',1.0e0)
% if j==1; ylb = 'y (cm)'; else ylb = '-1'; end
% mkplotnice('x (cm)',ylb,fonts,'-20','-20');
% sfa = mkstring('','0',fa,9999,'');
% sfb = mkstring('','0',fb,9999,'');
% str2 = ['|v| = ' sprintf('%.0f',scale) ' m/s'];
% puttextonplot(gca, [0.45 1],lx-55,ly, [lbl{j} ' ' str2], 0, fonts, 'k');
% str1 = ['f = ' sfa '..' sfb ' Hz'];
% end
% %---------------------------------------------------------- Streamline Plot
% %meshvec = [-6:0.5:-4 -3.5:0.8:3.5 4:0.2:6]; streamopt = [0.5 50];
% meshvec = xlim(1):0.6:xlim(2); streamopt = [0.5 40];
% [X,Y] = meshgrid((meshvec/100)+0.096);
% X = (X-0.096)*100;
% Y = (Y-0.096)*100;
% startx = X; starty = Y;
% startx_red = 2; starty_red = -2.8; streamopt_red = [0.5 200];
% if diavec(2)
% j=j+1; axes('Position',ax{j});
% hold on
% % STREAMLINE Plot
% XY = stream2(x,y,ux,uy,startx,starty,streamopt);
% hp = streamline(XY);
% for q=1:length(hp)
%   set(hp(q),'Color',colstream,'LineWidth',lw)
% end
% XY_red = stream2(x,y,ux,uy,startx_red,starty_red,streamopt_red);
% hp_red = streamline(XY_red);
% for q=1:length(hp_red)
%   set(hp_red(q),'Color',rgb('Crimson'),'LineWidth',4*lw)
% end
% hold on
% switch strvecplot
%   case 'streamslice'
%   % -- Use STREAMSLICE as vectorplot --
%   [verts averts] = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
%   hp = streamline([[] averts]);
%   set(hp, 'Color', 'k')
%   case 'quiver'
%   % -- Use QUIVER as vectorplot --
%   hp = quiver(x(1:3:end),y(1:3:end),ux(1:3:end),uy(1:3:end));
%   set(hp,'AutoScale','off')
%   set(hp,'AutoScaleFactor',1.0e0)
%   set(hp,'Color', 'k')
% end
% hold off
% axis square
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylim,'ytick',ytick)
% if j==1; ylb = 'y (cm)'; else ylb = '-1'; end
% mkplotnice('x (cm)',ylb,fonts,'-20','-25');
% puttextonplot(gca, [0.45 1],lx,ly, lbl{j}, 0, fonts, 'k');
% end
% %--------------------------------------------------------- Streamslice Plot
% if diavec(3)
% j=j+1; axes('Position',ax{j});
% hold on
% hp = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
% set(hp,'Color',rgb('Black'),'LineWidth',lw)
% axis square
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylim,'ytick',ytick)
% if j==1; ylb = 'y (cm)'; else ylb = '-1'; end
% % PCOLOR Plot
% pcolor(xold,yold,vinter/1e3); shading interp
% colormap(gray(64))
% our_colorbar('v (km/s)',fonts,7,0.015,0.002,'EastOutside');
% hold off
% mkplotnice('x (cm)',ylb,fonts,'-20','-25');
% puttextonplot(gca, [0.45 1],lx,ly, lbl{j}, 0, fonts, 'k');
% end
% %-------------------------------------------------------------------- Print
% return
% sfa = mkstring('','0',fa,1e4,'');
% sfb = mkstring('','0',fb,1e4,'');
% savefn = [filebase '_' vfname(1:end-4) '_dia' ...
%   num2str(diavec(1)) num2str(diavec(2)) num2str(diavec(3)) ...
%   '_m1large_f' sfa '-' sfb '_pint' num2str(pint) '.eps'];
% print('-depsc2',savefn);
% %==========================================================================


% %==========================================================================
% % Plot Velocity Field (1 Figure: 3 Diagrams)
% %--------------------------------------------------------------------------
% strvecplot = 'streamslice'; % OR quiver
% 
% fonts = 12; figeps(12,6,5, 0,100); clf; j=0;
% x0 = 0.09; dx = 0.30; y0 = 0.10;
% xw = 0.28; yw = 0.80;
% j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
% j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
% j=j+1; ax{j} = [x0+(j-1)*dx y0 xw yw];
% j=0;
% 
% colstream = rgb('DimGray');
% lw = 0.3;
% lx =   0; ly = 17;
% 
% %------------------------------------------- Prepare Vector field plot data
% load velo_triangle_d1_t0001-5000.mat
% % Resolution for interpolation
% pint = 60;
% % Define frequency interval
% df=500;
% 
% % for fvec = 12000+df:df:20000-df
% fa = 4600; fb = 5000;
% % fa = fvec; fb = fvec+df;
% indf = find( (pa1.freq>fa) & (pa1.freq<fb));
% vx = sum(vvec(:,:,indf,1),3) ./ numel(indf);
% vy = sum(vvec(:,:,indf,2),3) ./ numel(indf);
% 
% vxavgabs = matmean(abs(vx));
% vyavgabs = matmean(abs(vy));
% ind = abs(vx)>100*vxavgabs; vx(ind) = 0; vy(ind) = 0;
% ind = abs(vy)>100*vyavgabs; vx(ind) = 0; vy(ind) = 0;
% %---------------------------------------------------- Smooth matrix
% % for i=jvec
% %   disp(num2str(i))
% %   vx(i,:) = smooth(jvec,vx(i,:),0.05,'rloess');
% %   vy(i,:) = smooth(jvec,vy(i,:),0.05,'rloess');
% % end
% % for i=jvec
% %   disp(num2str(i))
% %   vx(:,i) = smooth(jvec,vx(:,i),0.05,'rloess');
% %   vy(:,i) = smooth(jvec,vy(:,i),0.05,'rloess');
% % end
% %--------------------------------------------- Average Vector field
% jvec = 1:128;
% [~ , ~,Ax] = interp_matrix(jvec*pix2r,jvec*pix2r,vx, pint*[1 1]);
% [xn,yn,Ay] = interp_matrix(jvec*pix2r,jvec*pix2r,vy, pint*[1 1]);
% 
% [X,Y] = meshgrid(xn);
% x = (X-0.096)*100;
% y = (Y-0.096)*100;
% 
%  v = sqrt(vx.^2 + vy.^2);
% vs = sqrt(Ax.^2 + Ay.^2);
% 
% scale = matmax(vs);
% scale = 3000;
% 
% % vecx = Ax./vs;
% % vecy = Ay./vs;
% vecx = Ax;
% vecy = Ay;
% 
% ux = vecx/scale;
% uy = vecy/scale;
% 
% 
% %-------------------------------------------------------------- Quiver plot
% j=j+1; axes('Position',ax{j});
% hp = quiver(x,y,ux,uy);
% set(hp,'Color',rgb('Black'),'LineWidth',lw)
% hold off
% axis square
% hold off
% set(gca,'xlim',6*[-1 1])
% set(gca,'ylim',6*[-1 1])
% set(hp,'AutoScale','off')
% set(hp,'AutoScaleFactor',1.0e0)
% mkplotnice('x (cm)','y (cm)',fonts,'-20','-20');
% sfa = mkstring('','0',fa,9999,'');
% sfb = mkstring('','0',fb,9999,'');
% str2 = ['|v| = ' sprintf('%.0f',scale) ' m/s'];
% puttextonplot(gca, [0 1],lx,ly, ['(a) ' str2], 0, fonts, 'k');
% str1 = ['f = ' sfa '..' sfb ' Hz'];
% %---------------------------------------------------------- Streamline Plot
% j=j+1; axes('Position',ax{j});
% % [X,Y] = meshgrid(xn(1:3:end));
% %meshvec = [-6:0.5:-4 -3.5:0.8:3.5 4:0.2:6]; streamopt = [0.5 50];
% meshvec = [-6:0.6:+6]; streamopt = [0.5 40];
% [X,Y] = meshgrid((meshvec/100)+0.096);
% X = (X-0.096)*100;
% Y = (Y-0.096)*100;
% startx = X;
% starty = Y;
% XY = stream2(x,y,ux,uy,startx,starty,streamopt);
% hp = streamline(XY);
% for q=1:length(hp)
%   set(hp(q),'Color',colstream,'LineWidth',lw)
% end
% hold on
% switch strvecplot
%   case 'streamslice'
%   % -- Use STREAMSLICE as vectorplot --
%   [verts averts] = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
%   hp = streamline([[] averts]);
%   set(hp, 'Color', 'k')
%   case 'quiver'
%   % -- Use QUIVER as vectorplot --
%   hp = quiver(x(1:3:end),y(1:3:end),ux(1:3:end),uy(1:3:end));
%   set(hp,'AutoScale','off')
%   set(hp,'AutoScaleFactor',1.0e0)
%   set(hp, 'Color', 'k')
% end
% hold off
% axis square
% set(gca,'xlim',6*[-1 1])
% set(gca,'ylim',6*[-1 1])
% mkplotnice('x (cm)','-1',fonts,'-20','-25');
% puttextonplot(gca, [0.45 1],lx,ly, '(b)', 0, fonts, 'k');
% %--------------------------------------------------------- Streamslice Plot
% j=j+1; axes('Position',ax{j});
% hp = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
% set(hp,'Color',rgb('Black'),'LineWidth',lw)
% axis square
% set(gca,'xlim',6*[-1 1])
% set(gca,'ylim',6*[-1 1])
% mkplotnice('x (cm)','-1',fonts,'-20','-25');
% puttextonplot(gca, [0.45 1],lx,ly, '(c)', 0, fonts, 'k');
% %-------------------------------------------------------------------- Print
% sfa = mkstring('','0',fa,1e4,'');
% sfb = mkstring('','0',fb,1e4,'');
% savefn = ['velocimetry_d1_t0001-5000_B108mT_m1large_f' sfa '-' sfb ...
%   '_streamline_' strvecplot num2str(streamopt(1)) '_' ...
%   num2str(streamopt(2)) '.eps'];
% print('-depsc2',savefn);
% %==========================================================================


% %==========================================================================
% % Plot Velocity Field (3 Figures)
% %--------------------------------------------------------------------------
% fonts = 12;
% colstream = rgb('DimGray');
% lw = 0.3;
% strvecplot = 'streamslice'; % OR quiver
% 
% load velo_triangle_d1_t0001-5000.mat
% % Resolution for interpolation
% pint = 60;
% % Define frequency interval
% df=500;
% figeps(12,11,5, 0,100); clf;
% figeps(12,11,6,40,100); clf;
% figeps(12,11,7,80,100); clf;
% % for fvec = 12000+df:df:20000-df
% fa = 4600; fb = 5000;
% % fa = fvec; fb = fvec+df;
% indf = find( (pa1.freq>fa) & (pa1.freq<fb));
% % vx = vvec1(:,:,indf(1),1);
% % vy = vvec1(:,:,indf(1),2);
% vx = sum(vvec(:,:,indf,1),3) ./ numel(indf);
% vy = sum(vvec(:,:,indf,2),3) ./ numel(indf);
% 
% vxavgabs = matmean(abs(vx));
% vyavgabs = matmean(abs(vy));
% ind = abs(vx)>10*vxavgabs; vx(ind) = 0; vy(ind) = 0;
% ind = abs(vy)>10*vyavgabs; vx(ind) = 0; vy(ind) = 0;
% %-------------------------------------------------------------Smooth matrix
% % for i=jvec
% %   disp(num2str(i))
% %   vx(i,:) = smooth(jvec,vx(i,:),0.05,'rloess');
% %   vy(i,:) = smooth(jvec,vy(i,:),0.05,'rloess');
% % end
% % for i=jvec
% %   disp(num2str(i))
% %   vx(:,i) = smooth(jvec,vx(:,i),0.05,'rloess');
% %   vy(:,i) = smooth(jvec,vy(:,i),0.05,'rloess');
% % end
% %------------------------------------------------------Average Vector field
% jvec = 1:128;
% [~ , ~,Ax] = interp_matrix(jvec*pix2r,jvec*pix2r,vx, pint*[1 1]);
% [xn,yn,Ay] = interp_matrix(jvec*pix2r,jvec*pix2r,vy, pint*[1 1]);
% 
% [X,Y] = meshgrid(xn);
% x = (X-0.096)*100;
% y = (Y-0.096)*100;
% 
%  v = sqrt(vx.^2 + vy.^2);
% vs = sqrt(Ax.^2 + Ay.^2);
% 
% scale = matmax(vs);
% scale = 3000;
% 
% % vecx = Ax./vs;
% % vecy = Ay./vs;
% vecx = Ax;
% vecy = Ay;
% 
% ux = vecx/scale;
% uy = vecy/scale;
% 
% figure(5)
% axes('position',[0.12 0.12 0.84 0.84])
% hp = quiver(x,y,ux,uy);
% hold off
% axis square
% hold off
% set(gca,'xlim',6*[-1 1])
% set(gca,'ylim',6*[-1 1])
% set(hp,'AutoScale','off')
% set(hp,'AutoScaleFactor',1.0e0)
% mkplotnice('x (cm)','y (cm)',fonts,'-25','-30');
% str1 = ['f = ' sprintf('%.0f',fa) '..' sprintf('%.0f',fb) ' Hz'];
% puttextonplot(gca, [0 1], 5, -15, str1, 1, fonts, 'k');
% str2 = ['v_{norm} = ' sprintf('%.0f',scale) ' m/s'];
% puttextonplot(gca, [0 1], 5, -45, str2, 1, fonts, 'k');
% sfa = mkstring('','0',fa,10000,'');
% sfb = mkstring('','0',fb,10000,'');
% % savefn = ['Bvec' sfa '-' sfb '.eps'];
% % print('-depsc2',savefn)
% 
% figure(6);clf;
% axes('position',[0.07 0.12 0.84 0.84])
% % [X,Y] = meshgrid(xn(1:3:end));
% [X,Y] = meshgrid((([-6:0.5:-4 -3.5:0.8:3.5 4:0.2:6])/100)+0.096);
% X = (X-0.096)*100;
% Y = (Y-0.096)*100;
% startx = X;
% starty = Y;
% streamopt = [0.5 50];
% XY = stream2(x,y,ux,uy,startx,starty,streamopt);
% hp = streamline(XY);
% for q=1:length(hp)
%   set(hp(q),'Color',colstream,'LineWidth',lw)
% end
% hold on
% 
% switch strvecplot
%   case 'streamslice'
%   % -- Use STREAMSLICE as vectorplot --
%   [verts averts] = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
%   hp = streamline([[] averts]);
%   set(hp, 'Color', 'k')
%   case 'quiver'
%   % -- Use QUIVER as vectorplot --
%   hp = quiver(x(1:3:end),y(1:3:end),ux(1:3:end),uy(1:3:end));
%   set(hp,'AutoScale','off')
%   set(hp,'AutoScaleFactor',1.0e0)
%   set(hp, 'Color', 'k')
% end
% 
% hold off
% %streamline(x,y,ux,uy,startx,starty);
% axis square
% set(gca,'xlim',6*[-1 1])
% set(gca,'ylim',6*[-1 1])
% mkplotnice('x (cm)','y (cm)',fonts,'-25','-25');
% puttextonplot(gca, [0 1], 5, -15, str1, 1, fonts, 'k');
% savefn = ['velocimetry_d1_t0001-5000_B108mT_m1large_f' ...
%   num2str(fa) '-' num2str(fb) ...
%   '_streamline_' strvecplot num2str(streamopt(1)) '_' ...
%   num2str(streamopt(2)) '.eps'];
% print('-depsc2',savefn);
% 
% figure(7)
% hp = streamslice(x,y,[],ux,uy,[],startx,starty,[],10);
% set(hp,'Color',rgb('Black'),'LineWidth',lw)
% axis square
% set(gca,'xlim',6*[-1 1])
% set(gca,'ylim',6*[-1 1])
% mkplotnice('x (cm)','y (cm)',fonts,'-25','-25');
% 
% % figure(7)
% % axes('position',[0.07 0.12 0.84 0.84])
% % pcolor(x,y,vs/1e3)
% % set(gca,'clim',[0 1.1])
% % axis square
% % set(gca,'xlim',6*[-1 1])
% % set(gca,'ylim',6*[-1 1])
% % shading flat
% % mkplotnice('x (cm)','y (cm)',fonts,'-25','-25');
% % our_colorbar('velocity (km/s)', fonts, 10, 0.015, -0.02);
% 
% % input('<< Press any Key to Continue >>')
% % % pause(1); 
% % clf
% % end
% %========================================================================
% ==