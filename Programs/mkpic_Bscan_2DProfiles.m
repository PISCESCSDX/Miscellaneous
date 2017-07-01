% May-20-2014, C. Brandt, Juelich

I_B = [130 160 190 230 260 290 320 360 390 420 460 490 ...
  520 560 590 620 650 680 720 750 780];

% mm per pixel (important for conversion from pixel to mm)
% May-21-2014, I just don't remember from which measurement I took this
%              I can look it up, however.
pix2r = 1.333;

% %==========================================================================
% % Prepare for each movie file a statistics mat file
% %--------------------------------------------------------------------------
% a = dir('*f650*.cine');
% b = dir('*f450*.cine');
% c = [a;b];
% 
% % Define raw files to use (avoid overexposed rawdata)
% % for i=1:length(c); disp([num2str(i) '  ' c(i).name]); end
% ivec = [1:21 21+1:21+19 21+21:21+22];
% 
% for i=1:length(ivec)
%   filename{i} = c(ivec(i)).name;
% end
% 
% % Aperture Area
% % The f-number N is given by N = f/D
% % where f is the focal length and D the diameter of the entrance pupil.
% % A = pi (f / 2 N)^2
% % A_1 = pi (f / 2 N_1)^2
% % A_2 = pi (f / 2 N_2)^2
% %
% % A_2/A_1 = N_1^2 / N_2^2
% 
% % camera lens:
% movstat.focal_length = 0.025; % 25mm
% 
% % %---------------------------------------- Go through all chosen movie files
% % for ifile=1:length(ivec)
% %   
% %   %------------ Extract the filter and the aperture from the movie filename
% %   filter = filename{ifile}(end-13:end-11);
% %   movstat.filter = str2double(filter);
% %   movstat.aperture = str2double(filename{ifile}(end-7:end-5));
% %   str_shot = filename{ifile}(1:5);
% %   disp(['*** Calculating statistics for shot # ' str_shot ' filter' filter])
% %   
% %   %-------------------- Get movie information
% %   info_cine = cineInfo(filename{ifile});
% %   
% %   % Exposure time (in mus)
% %   movstat.t_exp = info_cine.exposure;
% %   
% %   NumFrames = info_cine.NumFrames;
% %   
% %   %------------------------------------------ Calculate average movie image
% %   movstat.avg = 0;
% %   for i=1:NumFrames
% %     disp_num(i,NumFrames);
% %     pic = double(cineRead(filename{ifile}, i));
% %     movstat.avg = movstat.avg + pic;
% %   end
% %   movstat.avg = movstat.avg/NumFrames;
% % 
% %   
% %   %------------------------------------------- Calculate standard deviation
% %   movstat.std = 0;
% %   s = 0;
% %   for i=1:NumFrames
% %     disp_num(i,NumFrames);
% %     pic = double(cineRead(filename{ifile}, i));
% %     hv = (pic - movstat.avg).^2;
% %     s = s + hv;
% %   end
% %   movstat.std = sqrt(s/NumFrames);
% % 
% %   
% %   %-------------------------------------------------------------- Save data
% %   filebase = filename{ifile}(1:end-5);
% %   savefn = [filebase '_statistics.mat'];
% %   save(savefn,'movstat');
% %   
% % end
% 
% 
% 
% 
% %--------------------------- Calculate azimuthally averaged radial profiles
% % List all calculated statistics-files
% dirion = dir('*f450*statistics.mat');
% dirneu = dir('*f650*statistics.mat');
% 
% % Number of files per species
% L_ion= numel(dirion);
% L_neu= numel(dirneu);
% 
% % Fontsize
% fonts = 12;
% figeps(16,9,1); clf;
% 
% %================================================================= NEUTRALS
% for i=1:L_neu
%   disp( [num2str(i) ' ' sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT']);
% 
%   str_B = [sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT'];
% 
%   %------------------------------------------ load statistics file
%   load(dirneu(i).name);
%   
%   % Average Image
%   area = pi * (movstat.focal_length /(2*movstat.aperture))^2;
%   matavg = 1e-6* movstat.avg / (area * movstat.t_exp);
%   % Standard Deviation Image
%   matstd = 1e-6* movstat.std / (area * movstat.t_exp);
% 
%   figure(1); clf;
%   subplot(1,2,1)
%   pcolor(matavg); shading flat
%   puttextonplot(gca, [0 1], 5, -15, str_B, 0, 12, 'w');
%    str_aperture = ['ap: ' num2str(movstat.aperture)];
%    puttextonplot(gca, [0 1], 5, -45, str_aperture, 0, 12, 'w');
%   axis square
%   title('averaged movie (f650)','FontSize',fonts)
%   mkplotnice('horizontal (pixel)', 'vertical (pixel)', fonts, '-20', '-30');
% 
%   prof2D.neu{i}.avg = matavg;
%   prof2D.neu{i}.std = matstd;
%   prof2D.neu{i}.I_B = I_B(i);
%   prof2D.neu{i}.B = B_CSDX( I_B(i) );
%   info{2} = 'matavg = 1e-6* movstat.avg / (area * movstat.t_exp);';
%   info{3} = 'area = pi * (movstat.focal_length /(2*movstat.aperture))^2;';
% 
%   subplot(1,2,2)
%   pcolor(matstd)
%   shading flat
%   axis square
%   title('std of movie','FontSize',fonts)
%   mkplotnice('horizontal (pixel)', 'vertical (pixel)', fonts, '-20', '-30');
% 
%   % Wait for next click
%   input('Press any button to continue')
% end
% 
% 
% 
% %===================================================================== IONS
% for i=1:L_ion
%   disp( [num2str(i) ' ' sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT']);
% 
%   str_B = [sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT'];
% 
%   %------------------------------------------ load statistics file
%   load(dirion(i).name);
%   
%   % Average Image
%   area = pi * (movstat.focal_length /(2*movstat.aperture))^2;
%   matavg = 1e-6* movstat.avg / (area * movstat.t_exp);
%   % Standard Deviation Image
%   matstd = 1e-6* movstat.std / (area * movstat.t_exp);
% 
%   figure(1); clf;
%   subplot(1,2,1)
%   pcolor(matavg); shading flat
%   puttextonplot(gca, [0 1], 5, -15, str_B, 0, 12, 'w');
%    str_aperture = ['ap: ' num2str(movstat.aperture)];
%    puttextonplot(gca, [0 1], 5, -45, str_aperture, 0, 12, 'w');
%   axis square
%   title('averaged movie (f450)','FontSize',fonts)
%   mkplotnice('horizontal (pixel)', 'vertical (pixel)', fonts, '-20', '-30');
% 
%   prof2D.ion{i}.avg = matavg;
%   prof2D.ion{i}.std = matstd;
%   prof2D.ion{i}.I_B = I_B(i);
%   prof2D.ion{i}.B = B_CSDX( I_B(i) );
%   info{2} = 'matavg = 1e-6* movstat.avg / (area * movstat.t_exp);';
%   info{3} = 'area = pi * (movstat.focal_length /(2*movstat.aperture))^2;';
% 
%   subplot(1,2,2)
%   pcolor(matstd)
%   shading flat
%   axis square
%   title('std of movie','FontSize',fonts)
%   mkplotnice('horizontal (pixel)', 'vertical (pixel)', fonts, '-20', '-30');
% 
%   % Wait for next click
%   input('Press any button to continue')
% end
% 
% %===================================================================== Save
% save('Bscan_2DProfiles.mat','prof2D')
% return

load('Bscan_2DProfiles.mat')
%==========================================================================


%==========================================================================
% Plot all in one plot
%--------------------------------------------------------------------------
% Figure Parameters
figx = 24; epsx = 7.5*figx;
figeps(figx,10,1); clf;
fonts = 12;
x0 = 0.06; y0 = 0.13;
xw = 0.11; yw = 0.27;
dx = 0.125; dy = 0.29;
j=0;
for irow=0:2
  for icol = 0:6
    j=j+1; ax{j} = [x0+icol*dx y0+(2-irow)*dy xw yw];    
  end
end
lbl = 'abcdefghijklmnopqrstuvwxyz';

% Smoothing points of picture
sm = 2;
% Pixel to cm conversion
pix2r = 0.1333;

xtick = [-50 0 50];
ytick = [-50 0 50];

% % % % Define center pixel
% % % cp = [65 60];
% % % xvec = (1:size(prof2D.neu{1}.avg,2)) - cp(1); xvec * pix2r;
% % % yvec = (1:size(prof2D.neu{1}.avg,1)) - cp(2); yvec * pix2r;


% Trying the same for ion filtered AR II emission
% Define center pixel
cp = [65 60];
xvec = (1:size(prof2D.ion{1}.avg,2)) - cp(1); xvec * pix2r;
yvec = (1:size(prof2D.ion{1}.avg,1)) - cp(2); yvec * pix2r;


% Set colorbar limits
clim = [0 10];

i=0;
for irow=0:2
  for icol = 0:6
  i=i+1; axes('Position',ax{i})
  B = 1e3*B_CSDX( I_B(i) );
  str_B = [sprintf('%.0f', 10*round(B/10)) ' mT'];
  pcolor(xvec,yvec,prof2D.ion{i}.avg)
  shading interp
  colormap(jet)
  if icol==0; ylb = 'y (cm)'; else ylb = '-1';  end
  if irow==2; xlb = 'x (cm)'; else xlb = '-1'; end
  set(gca,'xtick',xtick,'ytick',ytick)
  set(gca,'clim',clim)
  mkplotnice(xlb,ylb,fonts,'-20','-30');
%   puttextonplot(gca,[0 1],5,-15,['(' lbl(i) ')'],0,fonts,'w');
  puttextonplot(gca,[0 1],5,-15,str_B,0,10,'w');
  end
end

% --------------------- Special Colorbar at right side
hax = axes('position',[x0 y0+1*dy-0.3/2 6*dx+xw yw+0.3]);
hp = pcolor([clim; clim]);
set(gca, 'clim', clim)
set(hax, 'visible', 'off')
set(hp,  'visible','off')
cb = mknicecolorbar('EastOutside', 'intensity at 450nm (arb.u.)',12,0.15,0.2,4.5);
% set(cb.handle,'ytick',[0 1])
% set(cb.handle,'yticklabel',{'0','1'})

return
% --------------------- Print
print_adv2([1 1 1 1 1 1 1  1 1 1 1 1 1 1  1 1 1 1 1 1 1  0], ... 
  [0 0 0 0 0 0 0  0 0 0 0 0 0 0  0 0 0 0 0 0 0  0], '-r300', ...
  'mkpic_Bscan_2DProfiles_f650_avg.eps', 50, 5);
%==========================================================================