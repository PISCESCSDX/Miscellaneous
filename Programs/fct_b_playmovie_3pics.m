function fct_b_playmovie_3pics(filebase)
% Jun-07-2013, C. Brandt, San Diego

filename = [filebase '.cine'];
info = cineInfo(filename);
fs = info.frameRate;
dt = 1/fs;

%==========================================================================
% Play movie
%--------------------------------------------------------------------------
savefn = [filebase '_statistics.mat'];
load(savefn);
x=1:size(movstat.avg,1);
y=1:size(movstat.avg,2);

% number of smoothing points
sm = 2;

j=0;
j=j+1; ax{j} = [0.05 0.15 0.26 0.75];
j=j+1; ax{j} = [0.38 0.15 0.26 0.75];
j=j+1; ax{j} = [0.69 0.15 0.26 0.75];

zoom = 1;
% Video using PCOLOR
set(gcf,'PaperUnits','centimeters','PaperType','a4letter', ...
  'PaperPosition', [1 1080 zoom*20 zoom*7],'Color','w');
wysiwyg_vid(1000)
clf;

N = 100;
% Preallocate movie structure.
mov(1:N) = struct('cdata', [], 'colormap', []);

for i=1:N
  j=0;
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
  title('rawdata (gamma enhanced)','FontSize',12)
  freezeColors
  mkplotnice('x (pixel)', 'y (pixel)', 12, '-27', '-27');
  mknicecolorbar('EastOutside','raw image intensity (arb.u.)', ...
    10, 0.15, 0.1, 4);
  tstr = ['\tau=' sprintf('%.3f',1e3*((i-1)*dt)) 'ms'];
  puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
  puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
  set(gca,'nextplot','replacechildren');
  
  j=j+1; axes('Position',ax{j})
  pcolor(x,y,picmaxstd); shading flat
  colormap(hot)
  set(gca,'zLim',[0 2000])
  set(gca,'clim', 1.0*[-1 1])
  freezeColors
  title('average removed','FontSize',12)
  mkplotnice('x (pixel)', '-1', 12, '-27', '-32');
  puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
  puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
  set(gca,'nextplot','replacechildren');
  mknicecolorbar('EastOutside','(p-{\langle}p{\rangle}) / \sigma_{max}',...
    10, 0.15, 0.1, 3);
  
  j=j+1; axes('Position',ax{j})
  pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
  pcolor(x,y,pic); shading flat
  colormap(gray)
  set(gca,'zLim',[0 1000])
  set(gca,'clim', 4*[-1 1])
  title('avg. removed & norm. to pixels std','FontSize',12)
  mkplotnice('x (pixel)', '-1', 12, '-27', '-32');
  puttextonplot(gca, [0 1],5,-15,['#' num2str(i)],0,12,'k');
  puttextonplot(gca, [0 1],5,-35,tstr,0,12,'k');
  set(gca,'nextplot','replacechildren');
  mknicecolorbar('EastOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
    10, 0.15, 0.1, 3);
  
  % Get movie frame
  mov(i) = getframe(gcf);
  pause(0.001); clf
end

% Create AVI file.
movie2avi(mov, [filebase '.avi'], 'compression', 'None', 'fps', 25);
%==========================================================================

end