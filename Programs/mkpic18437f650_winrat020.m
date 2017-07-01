filebase = '18437_f650_ap1.4';
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
  x0 = 0.08; dx = 0.285; y0 = 0.20;
  xw = 0.27; yw = 0.63;
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

% for fvec = 1000+df:df:30000-df; clf; fa = fvec; fb = fvec+df;
% for ifvec = 2:length(pa1.freq); clf; fa = pa1.freq(ifvec); fb = fa; j=0;

fa = 10000; fb = 15000;

indf = find( (pa1.freq>=fa) & (pa1.freq<=fb));
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
ux = Ax/scale;
uy = Ay/scale;
[X,Y] = meshgrid(xn);
% Normalize and Offset grids
   x = (   X-0.0846)*100;
   y = (   Y-0.0846)*100;
xold = (xold-0.0846)*100;
yold = (yold-0.0846)*100;
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
mkplotnice('x (cm)',ylb,fonts,'-20','-17');
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
startx_red = 0; starty_red = -4.0; streamopt_red = [0.5 300]; % length red
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
  % Calculate absolute velocity
  v = sqrt(vx.^2 + vy.^2);
  % Wavelet Interpolation (best smooth method here) of absolute velocity
  WaveletLevel = 2;
  vinter = interp_Wavelet(v,WaveletLevel,'sym');
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
cb = mknicecolorbar('EastOutside','',fonts,0.15,0.1,3);
puttextonplot(gca, [1 1],-20,14,'v (km/s)', 0, fonts-2, 'k');
hold off
mkplotnice('x (cm)',ylb,fonts,'-20','-25');
puttextonplot(gca, [0.45 1],lx,ly, lbl{j}, 0, fonts, 'k');
end

str = [num2str(round(fa)) ' to ' num2str(round(fb)) ' Hz'];
ha = puttextonplot(gca, [0 1],2,-9,str,1,fonts-2,'k');
%-------------------------------------------------------------------- Print
return

sfa = mkstring('','0',fa,1e4,'');
sfb = mkstring('','0',fb,1e4,'');
savefn = [filebase '_' vfname(1:end-4) '_dia' ...
  num2str(diavec(1)) num2str(diavec(2)) num2str(diavec(3)) ...
  '_m1large_f' sfa '-' sfb '_pint' num2str(pint) '.eps'];
print_adv([0 1 0], '-r300', savefn, 50, 4)
% print_adv([0 1 0 0], '-r300', savefn, 50, 4)
%==========================================================================