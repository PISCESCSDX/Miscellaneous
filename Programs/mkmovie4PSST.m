% Sep-05-2013, C. Brandt, San Diego

% Define movies
filebase{1} = '18423_f650_ap1.4'; % B= 40mT
filebase{2} = '18427_f650_ap1.4'; % B=140mT
filebase{3} = '18429_f650_ap1.4'; % B=160mT
filebase{4} = '18437_f650_ap1.4'; % B=240mT

B = {'100mT','140mT','160mT','240mT'};

%==========================================================================
% Play movie
%--------------------------------------------------------------------------

% number of smoothing points
sm = 2;
% Definition of Center pixel
cp = [60 68];
% Pixel to cm
pix2r = 0.1333;

x0=0.06; y0=0.10;
xw=0.18; yw=0.30;
dx=0.24; dy=0.47;

j=0;
j=j+1; ax{j} = [x0+0*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+0*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+3*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+3*dx y0+0*dy xw yw]; j=0;

zoom = 1;
% Video using PCOLOR
set(gcf,'PaperUnits','centimeters','PaperType','a4letter', ...
  'PaperPosition', [1 1080 zoom*15 zoom*9],'Color','w');
% 15x9 seems to work for avi export
wysiwyg_vid(1000)
clf;

N = 400;
% Preallocate movie structure.
mov(1:N) = struct('cdata', [], 'colormap', []);

for i=1:N
  j=0;
  for nf = 1:4
    filename = [filebase{nf} '.cine'];
    info = cineInfo(filename);
    fs = info.frameRate;
    dt = 1/fs;
    savefn = [filebase{nf} '_statistics.mat'];
    load(savefn);
    x=( (1:size(movstat.avg,1))-cp(2) )*pix2r;
    y=( (1:size(movstat.avg,2))-cp(1) )*pix2r;

    picraw = double(cineRead(filename, i));
    picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
    picpixstd = (picraw - movstat.avg) ./ movstat.std;

    raw = picraw/5e3;
    j=j+1; axes('Position',ax{j})
    gamma = 0.2;
    J = imadjust(raw,[0 1],[0 1], gamma);
    pcolor(x,y,J); shading flat
    colormap(gray)
    set(gca,'clim', [0.2 1.0])
    mkplotnice('x (cm)', 'y (cm)', 12, '-22', '-22');
    mknicecolorbar('NorthOutside','raw image intensity (arb.u.)', ...
      10, 0.15, 0.1, 4);
    tstr = ['\tau=' sprintf('%.3f',1e3*((i-1)*dt)) 'ms'];
    puttextonplot(gca, [0 1],70,55,B{nf},0,12,'k');
    
    puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
    puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
    set(gca,'nextplot','replacechildren');

    j=j+1; axes('Position',ax{j})
    pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
    pcolor(x,y,pic); shading flat
    colormap(gray)
    set(gca,'zLim',[0 1000])
    set(gca,'clim', 4*[-1 1])
    mkplotnice('x (cm)', 'y (cm)', 12, '-22', '-22');
    puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
    puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
    set(gca,'nextplot','replacechildren');
    mknicecolorbar('NorthOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
      10, 0.15, 0.1, 3);
  end
  % Get movie frame
  mov(i) = getframe(gcf);
  pause(0.001); clf
end


% Create AVI file.
movie2avi(mov, 'mkmovie4PSST.avi', 'compression', 'None', 'fps', 25);
%==========================================================================