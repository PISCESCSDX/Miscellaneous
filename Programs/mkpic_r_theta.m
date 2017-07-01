% 2013-Aug-08_20:23, Christian Brandt, San Diego
% This m-file is for showing detailed snapshots of r vs theta with time

filebase ='18437_f650_ap1.4';
% filebase ='18428_f650_ap1.4';
% filebase ='18430_f650_ap1.4';
filename = [filebase '.cine'];
info = cineInfo(filename);
%----------------------------------- Conversion Parameters x,y to azimuthal
% Convert to cylindrical coordinates
cp = [61 66];
% Resolution of azimuthal direction
Nphi = 420;
% Pixel2radius (1pixel = 0.1333cm)
pix2r = 0.1333;
% --- Determine lowest distance from center position to boundary of data --
% (This is the maximum of the radial vector.)
% Get dimensions of matrix
sizever = info.Height;
sizehor = info.Width;
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
%--------------------------------------------------------------------------

N = info.NumFrames;
fs = info.frameRate;
dt = 1/fs;

savefn = [filebase '_statistics.mat'];
load(savefn);
x=1:size(movstat.avg,1);
y=1:size(movstat.avg,2);

% number of smoothing points
sm = 2;
% Pre-load data
% d = 15; ishot =  500 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d]; % inward fl, KH
% d = 15; ishot = 1576 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d];
% d = 15; ishot = 2800 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d];
% d = 15; ishot = 3400 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d];
% d = 15; ishot = 3600 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d];
% d = 15; ishot = 3700 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d]; % nice KH
% d = 15; ishot = 4130 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d]; % PSST
d = 15; ishot = 4200 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d]; % inward flux
% d = 15; ishot = 4600 + [0*d 1*d 2*d 3*d 4*d 5*d 6*d 7*d];
for i=1:length(ishot)
  picraw = double(cineRead(filename, ishot(i)));
  picraw = (picraw - movstat.avg) ./ movstat.std;
  pic{i} = smoothBrochard(smoothBrochard(picraw,sm)',sm)';
  for ix = 1:size(xi,1)
    for iy = 1:size(xi,2)
      A{i}(ix,iy) = pic{i}( yi(ix,iy) , xi(ix,iy) );
    end
  end
end


fonts = 12;
figx = 12; figeps(figx,14.5,1); clf; epsx = num2str( round( 7.5*figx ) );
x0 = 0.13; y0 = 0.087;
xw = 0.80; yw = 0.095;
dx = 0.00; dy = 0.105;
j=0;
j=j+1; ax{j} = [x0 y0+7*dy xw yw];
j=j+1; ax{j} = [x0 y0+6*dy xw yw];
j=j+1; ax{j} = [x0 y0+5*dy xw yw];
j=j+1; ax{j} = [x0 y0+4*dy xw yw];
j=j+1; ax{j} = [x0 y0+3*dy xw yw];
j=j+1; ax{j} = [x0 y0+2*dy xw yw];
j=j+1; ax{j} = [x0 y0+1*dy xw yw];
j=j+1; ax{j} = [x0 y0+0*dy xw yw];
j=0;

for i=1:length(ishot)
  j=j+1; axes('Position',ax{j})
  M=A{i}';
  M = [M(:,331:end) M(:,1:330)];
  pcolor(flipud(Mphi(:,1))/pi,Mrad(1,:)'*pix2r,M);
  shading interp
  colormap(gray)
  set(gca,'clim', [-2.5 2.5])
  set(gca,'ylim',[0 8],'ytick',[0 3 6])
  set(gca,'xlim',[0 2])
  if j==length(ishot); xlb = 'azimuthal angle \theta (\pi)'; else xlb = '-1'; end
  if j==1
    ylb = 'radial position (cm)';
    [~,hy]=mkplotnice(xlb,ylb,fonts, '-19', '-25');
    set(hy,'Position',[ -0.1357    -25   17.3205])
  else
    ylb = ' ';
    mkplotnice(xlb,ylb,fonts, '-22', '-25');
  end
  if j==1
  mknicecolorbar('NorthOutside' , ...
    '(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
      fonts-2, 0.18, 0.15, 2.5);
  end
  tstr = ['\tau=' sprintf('%.0f',1e6*((ishot(i)-ishot(1))*dt)) '{\mu}s'];
  % puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
  puttextonplot(gca, [0 1],5,-35,tstr,0,12,'w');
  % Plot vertical limit lines
  x0 = 0.30; dx = 0.50; dxt = 0.059;
  line([x0 x0]+(i-1)*dxt,[0 8],'LineWidth',1.5,'Color',rgb('DeepSkyBlue'),'LineStyle','--')
  line([x0+dx x0+dx]+(i-1)*dxt,[0 8],'LineWidth',1.5,'Color',rgb('IndianRed'),'LineStyle','--')
end
return
% Print
savefn = ['mkpic_r_theta_' num2str(ishot(1)) '_x' epsx '-r200_q30.eps'];
print_adv([1 1 1 1 1 1 1 0 1],'-r200',savefn,30,4);
%
% % Changed Line Styles in the eps afterwards:
% line types: solid, dotted, dashed, dotdash
% /SO { [] 0 setdash } bdef
% /DA { [4.5 dpi2point mul 2.0 dpi2point mul] 0 setdash } bdef
% /DO { [6 dpi2point mul] 0 setdash } bdef
% /DD { [.5 dpi2point mul 4 dpi2point mul 6 dpi2point mul 4
%   dpi2point mul] 0 setdash } bdef
%==========================================================================