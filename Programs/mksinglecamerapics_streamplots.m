%==========================================================================
% Plot a 1x3 plot (columns: different B-fields)
% (Size for Two-column Paper, single colum figure)
%--------------------------------------------------------------------------
I_B = [130 160 190 230 260 290 320 360 390 420 460 ...
       490 520 560 590 620 650 680 720 750 780];
B_shots = B_CSDX(I_B);

shots = [7 11 21];

d1 = 10; d2 = 10; d3 = 20;
filebase{1} = '18423_f650_ap1.4'; iframe{1} = 560+[0 d1 2*d1 3*d1];
filebase{2} = '18427_f650_ap1.4'; iframe{2} = 100+[0 d2 2*d2 3*d2];
filebase{3} = '18437_f650_ap1.4'; iframe{3} = 560+[0 d3 2*d3 3*d3];

lbl = {'(a)','(b)','(c)','(d)', ...
       '(f)','(g)','(h)','(i)', ...
       '(k)','(l)','(m)','(n)',...
       '(e)','(j)','(o)'};

% Figure Parameters
figx = 12; epsx = figx*7.5;
figeps(12,22,1); clf;
fonts = 12;
d = 0.057;
x0 = 0.09; y0 = 0.058;
xw = 0.28; yw = 0.15;
dx = 0.31; dy = 0.160;
j=0;
j=j+1; ax{j} = [x0+0*dx y0+4*dy+d xw yw];
j=j+1; ax{j} = [x0+0*dx y0+3*dy+d xw yw];
j=j+1; ax{j} = [x0+0*dx y0+2*dy+d xw yw];
j=j+1; ax{j} = [x0+0*dx y0+1*dy+d xw yw];
j=j+1; ax{j} = [x0+1*dx y0+4*dy+d xw yw];
j=j+1; ax{j} = [x0+1*dx y0+3*dy+d xw yw];
j=j+1; ax{j} = [x0+1*dx y0+2*dy+d xw yw];
j=j+1; ax{j} = [x0+1*dx y0+1*dy+d xw yw];
j=j+1; ax{j} = [x0+2*dx y0+4*dy+d xw yw];
j=j+1; ax{j} = [x0+2*dx y0+3*dy+d xw yw];
j=j+1; ax{j} = [x0+2*dx y0+2*dy+d xw yw];
j=j+1; ax{j} = [x0+2*dx y0+1*dy+d xw yw];
%
j=j+1; ax{j} = [x0+0*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+0*dy xw yw];
% Smoothing points of picture
sm = 2;
% Pixel to cm conversion
pix2r = 0.1333;
% Center position
xc = 8.5; yc = 7.8;

xlim = 7.5*[-1 1];
ylim = xlim;

j=0; % Reset axes counter
for iB = 1:3
  
  filename = [filebase{iB} '.cine'];
  info = cineInfo(filename);
  fs = info.frameRate;
  dt = 1/fs;

  savefn = [filebase{iB} '_statistics.mat'];
  load(savefn);
  x=1:size(movstat.avg,1);
  y=1:size(movstat.avg,2);

  % Loop over 4 frames for each B-field
  for i = 1:4
    picraw = double(cineRead(filename, iframe{iB}(i)));
    picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
    picpixstd = (picraw - movstat.avg) ./ movstat.std;

    j=j+1; axes('Position',ax{j})
    pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
    pcolor(x*pix2r-xc,y*pix2r-yc,pic); shading interp
    colormap(gray(64))
    switch iB
      case 1
        clim = 2.1*[-1 1];
      case 2
        clim = 2.1*[-1 1];
      case 3
        clim = 3.1*[-1 1];
    end
    set(gca,'clim', clim)
    set(gca,'xlim',xlim,'ylim',ylim)
    if iB==1; lby = 'y (cm)'; else lby = '-1'; end
    if  i==4; lbx = 'x (cm)'; else lbx = '-1'; end
    mkplotnice(lbx, lby, fonts, '-21', '-20');
    set(gca,'nextplot','replacechildren');
    if i==1
      mknicecolorbar('NorthOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
      fonts-2, 0.15, 0.1, 3.0);
      Bstr = ['B=' sprintf('%.0f', 10*round(1e2*(B_shots(shots(iB)))) ) 'mT'];
      if iB==1
        puttextonplot(gca, [0 1],30,55,Bstr,0,fonts,'k');
      else
        puttextonplot(gca, [0 1],26,55,Bstr,0,fonts,'k');
      end
    end
    puttextonplot(gca, [0 1],4,-12,lbl{j},0,fonts,'w');
    tstr = ['\tau=' sprintf('%.0f', ...
      1e6*((iframe{iB}(i)-iframe{iB}(1))*dt)) '{\mu}s'];
    puttextonplot(gca, [0 1],5,-28,tstr,0,fonts,'w');
  end
end


%---------------------------------------------------- Plot streamline plots
fnvel{1} = '18423_f650_ap1.4_velo_triangle_d1_t0001-5000_winrat0.20.mat';
 flim{1} = 1e3*[4.9 5.1];
% flim{1} = 1e3*[4.6 4.8];
% startxy{1} = [-1 0];
 startxy{1} = [0 -0.9];
% fnvel{2} = '18429_f650_ap1.4_velo_triangle_d1_t0001-5000_winrat0.20.mat';
fnvel{2} = '18427_f650_ap1.4_velo_triangle_d1_t0001-5000_winrat0.20.mat';
 flim{2} = [3e3 10e3];
 %flim{2} = [3e3 5e3];
 %flim{2} = [15e3 25e3];
 startxy{2} = [0 -3.5];
fnvel{3} = '18437_f650_ap1.4_velo_triangle_d1_t0001-5000_winrat0.20.mat';
 flim{3} = [10e3 15e3];
 startxy{3} = [0 -3];

 xlim = 5.2*[-1 1];
 ylim = xlim;
for istreamplot=1:3
%==========================================================================
% Plot Velocity Field
%--------------------------------------------------------------------------
colstream = rgb('DimGray');
strvecplot = 'streamslice'; % OR quiver
lw = 0.2;
xtick= -4:4:4; ytick= xtick;

%--------------------------------------- Load and prepare vector field data
vfname = fnvel{istreamplot};

load(vfname);
% Resolution for interpolation
pint = 60;
% Define frequency interval
df = 500;

% for fvec = 1000+df:df:30000-df; clf; fa = fvec; fb = fvec+df;
% for ifvec = 2:length(pa1.freq); clf; fa = pa1.freq(ifvec); fb = fa; j=0;

fa = flim{istreamplot}(1); fb = flim{istreamplot}(2);

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
   y = (   Y-0.0746)*100;
xold = (xold-0.0846)*100;
yold = (yold-0.0846)*100;
%---------------------------------------------------------- Streamline Plot
%meshvec = [-6:0.5:-4 -3.5:0.8:3.5 4:0.2:6]; streamopt = [0.5 50];
meshvec = xlim(1):0.6:xlim(2); streamopt = [0.5 40];
[X,Y] = meshgrid((meshvec/100)+0.096);
X = (X-0.096)*100;
Y = (Y-0.096)*100;
startx = X; starty = Y;
startx_red = startxy{istreamplot}(1);
starty_red = startxy{istreamplot}(2);
%startx_red = 0; starty_red = -3.0;
streamopt_red = [0.5 300]; % length red
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
plot(startx_red,starty_red,'bo','MarkerFaceColor','b','MarkerSize',5)
hold on
switch strvecplot
  case 'streamslice'
  % -- Use STREAMSLICE as vectorplot --
  [verts averts] = streamslice(x,y,[],ux,uy,[],startx,starty,[],5);
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
if j==13; ylb = 'y (cm)'; else ylb = '-1'; end
mkplotnice('x (cm)',ylb,fonts,'-21','-20');
puttextonplot(gca, [0 1],4,-12,lbl{j},0,fonts,'k');
%==========================================================================
end
return
fn = ['mksinglecamerapics_streamplots_99-140-240mT_4.9-5.1_3-10_10-15kHz_x' num2str(round(epsx)) '-r200_q30.eps'];
print_adv([0 0 0  1 1 1 0 1  1 1 1 0 1  1 1 1 0 1], '-r200', fn, 30, 4)
%==========================================================================