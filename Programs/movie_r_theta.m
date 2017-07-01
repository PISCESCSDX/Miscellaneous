fonts = 12;

filebase ='B_450';

%filebase ='18437_f650_ap1.4';
% filebase ='18428_f650_ap1.4';
% filebase ='18430_f650_ap1.4';

filename = [filebase '.cine'];
info = cineInfo(filename);

%----------------------------------- Conversion Parameters x,y to azimuthal
% Convert to cylindrical coordinates
cp = [61 66];
% Resolution of azimuthal direction
Nphi = 128;
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

fs = info.frameRate;
dt = 1/fs;

savefn = [filebase '_statistics.mat'];
load(savefn);
x=1:size(movstat.avg,1);
y=1:size(movstat.avg,2);

% number of smoothing points
sm = 2;

% Video using PCOLOR
zoom = 1;
set(gcf,'PaperUnits','centimeters','PaperType','a4letter', ...
  'PaperPosition', [1 1 zoom*20 zoom*7],'Color','w');
wysiwyg_vid(1000)
clf;
j=0;
j=j+1; ax{j} = [0.05 0.14 0.25 0.75];
j=j+1; ax{j} = [0.40 0.14 0.57 0.75];

% Pre-load data
N = 200; N0 = 0;
for i=N0+(1:N)
  disp(num2str(i))
  picraw = double(cineRead(filename, i));
  picraw = (picraw - movstat.avg) ./ movstat.std;
  pic{i} = smoothBrochard(smoothBrochard(picraw,sm)',sm)';
  for ix = 1:size(xi,1)
    for iy = 1:size(xi,2)
      A{i}(ix,iy) = pic{i}( yi(ix,iy) , xi(ix,iy) );
    end
  end
end

% Preallocate movie structure.
mov(1:N) = struct('cdata', [], 'colormap', []);

for i=N0+(1:N)
  clf
  j=0;
  j=j+1; axes('Position',ax{j})
  pcolor(x,y,pic{i})
  shading interp
  axis square
  colormap(gray)
  set(gca,'zLim',[0 1000])
  set(gca,'clim', 4*[-1 1])
  mkplotnice('x (pixel)', 'y (pixel)', fonts, '-20', '-25');
  tstr = ['\tau=' sprintf('%.3f',1e3*((i-1)*dt)) 'ms'];
  puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
  puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
  axis tight
  set(gca,'nextplot','replacechildren');
  mknicecolorbar('NorthOutside','(p-{\langle}p{\rangle}) / \sigma', ...
      fonts-2, 0.15, 0.1, 2.5);
    
  j=j+1; axes('Position',ax{j})
  pcolor(flipud(Mphi(:,1))/pi,Mrad(1,:)'*pix2r,A{i}');
  shading interp
  colormap(gray)
  set(gca,'clim', 4*[-1 1])
  mkplotnice('\theta (\pi)', 'r (cm)', 12, '-20', '-25');
  drawnow

  mov(i-N0) = getframe(gcf);
end
% Create AVI file.
movie2avi(mov, [filebase '_r-theta_iend' num2str(i) '.avi'], ...
  'compression', 'None', 'fps', 25);
%==========================================================================