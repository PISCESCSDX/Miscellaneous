% Jun-20-2013

I_B = [130 160 190 230 260 290 320 360 390 420 460 490 ...
  520 560 590 620 650 680 720 750 780];

% mm per pixel
pix2r = 1.333;

%==========================================================================
% Prepare for each movie file a statistics mat file
%--------------------------------------------------------------------------
% a = dir('*f650*.cine');
% b = dir('*f450*.cine');
% c = [a;b];
% 
% % Define raw files to use (avoid overexposed rawdata)
% % for i=1:length(c); disp([num2str(i) '  ' c(i).name]); end
% ivec = [1:34 36:41 43:44];
% 
% for i=1:length(ivec)
%   filename{i} = c(ivec(i)).name;
% end
% 
% % Aperture Area
% % The f-number N is given by N = f/D
% % where f is the focal length and D the diamter of the entrance pupil.
% % A = pi (f / 2 N)^2
% % A_1 = pi (f / 2 N_1)^2
% % A_2 = pi (f / 2 N_2)^2
% %
% % A_2/A_1 = N_1^2 / N_2^2
% 
% % camera lens:
% movstat.focal_length = 0.025; % 25mm
% 
% for ifile=1:length(ivec)
%   % Extract the aperture
%   filter = filename{ifile}(end-13:end-11);
%   movstat.filter = str2double(filter);
%   movstat.aperture = str2double(filename{ifile}(end-7:end-5));
%   str_shot = filename{ifile}(1:5);
%   disp(['*** Calculating statistics for shot # ' str_shot ' filter' filter])
%   
%   info_cine = cineInfo(filename{ifile});
%   % Exposure time
%   movstat.t_exp = info_cine.exposure;
%   
%   NumFrames = info_cine.NumFrames;
%   
%   % Calculate average movie image
%   movstat.avg = 0;
%   for i=1:NumFrames
%     disp_num(i,NumFrames);
%     pic = double(cineRead(filename{ifile}, i));
%     movstat.avg = movstat.avg + pic;
%   end
%   movstat.avg = movstat.avg/NumFrames;
% 
%   % Calculate standard deviation
%   movstat.std = 0;
%   s = 0;
%   for i=1:NumFrames
%     disp_num(i,NumFrames);
%     pic = double(cineRead(filename{ifile}, i));
%     hv = (pic - movstat.avg).^2;
%     s = s + hv;
%   end
%   movstat.std = sqrt(s/NumFrames);
% 
%   % Save data
%   filebase = filename{ifile}(1:end-5);
%   savefn = [filebase '_statistics.mat'];
%   save(savefn,'movstat');
%   
% end
% 
% 
% %--------------------------- Calculate azimuthally averaged radial profiles
% % List all tif-files
% dirion = dir('*f450*statistics.mat');
% dirneu = dir('*f650*statistics.mat');
% la= numel(dirion);
% 
% % Resolution of azimuthal angle
% resphi = 128;
% fonts = 12;
% % Scan width around found maximum to search for best center (default: 10)
% rd = 10;  
% 
% % NEUTRALS
% figeps(16,16,1); clf;
% figeps(16,16,2); clf;
% for i=1:la
%   disp( [num2str(i) ' ' sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT']);
%   
%   load(dirneu(i).name);
%   
%   % --- BEGIN: Find the best center ---
%   matavg = movstat.avg;
%   % Find start value: maximum of mat
%   [v1, i1] = max(matavg);
%   [ ~, colmax] = max(v1);
%   rowmax = i1(colmax);
%   vrow = -rd:1:rd;  vcol = vrow;
%   int = zeros(numel(vrow),numel(vcol));
%   for irow = 1:length(vrow)
%     for icol = 1:length(vcol)
%       cptest = [rowmax+vrow(irow) colmax+vcol(icol)];
%       [rvec, mavg] = Matrix2dAzimuthAvg(matavg, cptest, resphi);
%       y = std(mavg,1)';
%       % Integration of standard deviation is a measure of deviation:
%       int(irow,icol) = int_discrete(rvec,y);
%     end
%   end
%   % Find indices of local minimum of integration matrix 'int'
%   [v1, i1] = min(int);
%   [ ~, colmin] = min(v1);
%   rowmin = i1(colmin);
%   % Store new center position to variable
%   cp = [rowmax+vrow(rowmin) colmax+vcol(colmin)];
%   prof.neu{i}.cp = cp;
%   % --- END: Find the best center ---
%   
%   % Average Image
%   area = pi * (movstat.focal_length /(2*movstat.aperture))^2;
%   matavg = 1e-6* movstat.avg / (area * movstat.t_exp);
%   [~, mavg] = Matrix2dAzimuthAvg(matavg, cp, resphi);
%   % Standard Deviation Image
%   matstd = 1e-6* movstat.std / (area * movstat.t_exp);
%   [rvec, mstd] = Matrix2dAzimuthAvg(matstd, cp, resphi);
% 
% figure(1); clf;
% subplot(2,2,1)
% pcolor(matavg); shading flat
% line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% puttextonplot(gca, [0 1], 5, -15, num2str(movstat.aperture), 0, 12, 'k');
% axis square
% title('initial matrix','FontSize',fonts)
% mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');
% 
% subplot(2,2,2)
% pcolor(mavg); shading flat
% axis square
% title('radial-azimuthal matrix','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');
% 
% subplot(2,2,3)
% plot(rvec,mean(mavg,1))
% set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
% title('average radial profile','FontSize',fonts)
% mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');
% 
% subplot(2,2,4)
% y = std(mavg,1)';
% plot(rvec,y)
% set(gca,'xlim',[rvec(1) rvec(end)])
% title('standard deviation of avg','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
% int = int_discrete(rvec,y);
% str = ['\int y dr = ' sprintf('%.3f',int)];
% puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
% 
% prof.neu{i}.rvec = rvec;
% prof.neu{i}.avg = mean(mavg,1);
% prof.neu{i}.std = mean(mstd,1);
% prof.neu{i}.I_B = I_B(i);
% prof.neu{i}.B = B_CSDX( I_B(i) );
% info{1} = 'rvec in pixel; light data is normalized to area';
% info{2} = 'matavg = 1e-6* movstat.avg / (area * movstat.t_exp);';
% info{3} = 'area = pi * (movstat.focal_length /(2*movstat.aperture))^2;';
% 
% 
% figure(2); clf;
% subplot(2,2,1)
% pcolor(matstd); shading flat
% line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% 
% axis square
% title('initial matrix','FontSize',fonts)
% mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');
% 
% subplot(2,2,2)
% pcolor(mstd); shading flat
% axis square
% title('radial-azimuthal matrix','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');
% 
% subplot(2,2,3)
% plot(rvec,mean(mstd,1))
% set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
% title('average radial profile','FontSize',fonts)
% mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');
% 
% subplot(2,2,4)
% y = std(mstd,1)';
% plot(rvec,y)
% set(gca,'xlim',[rvec(1) rvec(end)])
% title('standard deviation of avg','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
% int = int_discrete(rvec,y);
% str = ['\int y dr = ' sprintf('%.3f',int)];
% puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
% end
% 
% 
% % IONS
% figeps(16,16,1); clf;
% figeps(16,16,2); clf;
% for i=1:la
%   disp( [num2str(i) ' ' sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT']);
%   
%   load(dirion(i).name);
%   
%   % --- BEGIN: Find the best center ---
%   matavg = movstat.avg;
%   % Find start value: maximum of mat
%   [v1, i1] = max(matavg);
%   [ ~, colmax] = max(v1);
%   rowmax = i1(colmax);
%   vrow = -rd:1:rd;  vcol = vrow;
%   int = zeros(numel(vrow),numel(vcol));
%   for irow = 1:length(vrow)
%     for icol = 1:length(vcol)
%       cptest = [rowmax+vrow(irow) colmax+vcol(icol)];
%       [rvec, mavg] = Matrix2dAzimuthAvg(matavg, cptest, resphi);
%       y = std(mavg,1)';
%       int(irow,icol) = int_discrete(rvec,y);
%     end
%   end
%   [v1, i1] = min(int);
%   [ ~, colmin] = min(v1);
%   rowmin = i1(colmin);
%   cp = [rowmax+vrow(rowmin) colmax+vcol(colmin)];
%   prof.ion{i}.cp = cp;
%   % --- END: Find the best center ---
%   
%   % Average Image
%   area = pi * (movstat.focal_length /(2*movstat.aperture))^2;
%   matavg = 1e-6* movstat.avg / (area * movstat.t_exp);
%   [~, mavg] = Matrix2dAzimuthAvg(matavg, cp, resphi);
%   % Standard Deviation Image
%   matstd = 1e-6* movstat.std / (area * movstat.t_exp);
%   [rvec, mstd] = Matrix2dAzimuthAvg(matstd, cp, resphi);
% 
% figure(1); clf;
% subplot(2,2,1)
% pcolor(matavg); shading flat
% line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% puttextonplot(gca, [0 1], 5, -15, num2str(movstat.aperture), 0, 12, 'k');
% axis square
% title('initial matrix','FontSize',fonts)
% mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');
% 
% subplot(2,2,2)
% pcolor(mavg); shading flat
% axis square
% title('radial-azimuthal matrix','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');
% 
% subplot(2,2,3)
% plot(rvec,mean(mavg,1))
% set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
% title('average radial profile','FontSize',fonts)
% mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');
% 
% subplot(2,2,4)
% y = std(mavg,1)';
% plot(rvec,y)
% set(gca,'xlim',[rvec(1) rvec(end)])
% title('standard deviation of avg','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
% int = int_discrete(rvec,y);
% str = ['\int y dr = ' sprintf('%.3f',int)];
% puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
% 
% prof.ion{i}.rvec = rvec;
% prof.ion{i}.avg = mean(mavg,1);
% prof.ion{i}.std = mean(mstd,1);
% prof.ion{i}.I_B = I_B(i);
% prof.ion{i}.B = B_CSDX( I_B(i) );
% info{1} = 'rvec in pixel; light data is normalized to area';
% info{2} = 'matavg = 1e-6* movstat.avg / (area * movstat.t_exp);';
% info{3} = 'area = pi * (movstat.focal_length /(2*movstat.aperture))^2;';
% 
% 
% figure(2); clf;
% subplot(2,2,1)
% pcolor(matstd); shading flat
% line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
% 
% axis square
% title('initial matrix','FontSize',fonts)
% mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');
% 
% subplot(2,2,2)
% pcolor(mstd); shading flat
% axis square
% title('radial-azimuthal matrix','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');
% 
% subplot(2,2,3)
% plot(rvec,mean(mstd,1))
% set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
% title('average radial profile','FontSize',fonts)
% mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');
% 
% subplot(2,2,4)
% y = std(mstd,1)';
% plot(rvec,y)
% set(gca,'xlim',[rvec(1) rvec(end)])
% title('standard deviation of avg','FontSize',fonts)
% mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
% int = int_discrete(rvec,y);
% str = ['\int y dr = ' sprintf('%.3f',int)];
% puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
% end
% 
% % Store data
% save('camerastatistics.mat','prof','info')
% input('Press any key to continue ...')
% %==========================================================================


%==========================================================================
% Plot business
%--------------------------------------------------------------------------
% Prepare data for plots
%--------------------------------------------------------------------------
load('camerastatistics.mat')
% Indices for profiles:
ind = 1:58;
% Normalization of STD profiles to lowest ArI value at r=0
profstdnorm = 0.4467;
% Normalize profiles to lowest ArI value at r=0
profnorm = 7.347;
% Preallocate integrated light intensity variables
intlightn = zeros(length(prof.neu));
intlighti = zeros(length(prof.neu));
for i=1:length(prof.neu)
  % Neutrals
  x = prof.neu{i}.rvec(ind)*pix2r/10;
  yavg = prof.neu{i}.avg(ind)';
  ystd = prof.neu{i}.std(ind)';
  intlightn(i) = int_discrete(x,yavg);
  xs = [-flipud(x); x(2:end)];
  ysavg = [flipud(yavg); yavg(2:end)];
  ysstd = [flipud(ystd); ystd(2:end)];
  [~  , spyavg] = mkspline(xs, ysavg, 2); % Double the resolution
  [spx, spystd] = mkspline(xs, ysstd, 2); % Double the resolution
  Pneu.avg.x = spx;
  Pneu.avg.z(:,i) = spyavg./profnorm;
  Pneu.std.x = spx;
  Pneu.std.z(:,i) = spystd./profstdnorm;
  % Ions
  x = prof.ion{i}.rvec(ind)*pix2r/10;
  yavg = prof.ion{i}.avg(ind)';
  ystd = prof.ion{i}.std(ind)';
  intlighti(i) = int_discrete(x,yavg);
  xs = [-flipud(x); x(2:end)];
  ysavg = [flipud(yavg); yavg(2:end)];
  ysstd = [flipud(ystd); ystd(2:end)];
  [~  , spyavg] = mkspline(xs, ysavg, 2); % Double the resolution
  [spx, spystd] = mkspline(xs, ysstd, 2); % Double the resolution
  Pion.avg.x = spx;
  Pion.avg.z(:,i) = spyavg./profnorm;
  Pion.std.x = spx;
  Pion.std.z(:,i) = spystd./profstdnorm;
end


%==========================================================================
% % Plot variant: Vertical
% % All 4 diagrams below: 3D neu., 3D ions, rad. avg, rad. std
%--------------------------------------------------------------------------
fonts = 12;
x0 = 0.13; xw = 0.82;
j=0;
j=j+1; ax{j} = [x0 0.53 xw 0.49];
j=j+1; ax{j} = [x0 0.05 xw 0.49];
load('camerastatistics.mat');

% Define which profiles to use:
ivec = [1 9 19];
% critical curve index (at this index a threshold in profile change exist)
icrit = 11;
% middle curve index
imiddle = 9;

colAr1 = rgb('Black');
colAr2 = rgb('BurlyWood');

figx=12; figeps(figx,17,1); clf; epsx = num2str(round(7.5*figx)); j=0;
%--------------------------------------------------------- 3D neutrals plot
% Definitions for 3D plots:
xo = round(1e3*B_CSDX(I_B)); lxo = length(xo);
res_r = 80;
ang = [-63 24];
xlim = [40 240]; xtick = 40:40:240;
ylim = [-7.5 7.5]; ytick = [-5 0 5];
lw = 0.2;
%

%%%%%%%%%%%%%%%%%%% Prepare Data
y = Pneu.avg.x;
[X,Y] = meshgrid(xo,y);
Z = Pneu.avg.z;
xo2 = interp1(linspace(1,lxo,lxo),xo,linspace(1,lxo,2*lxo));
he1 = linspace(y(1),y(end),length(y));
he2 = linspace(y(1),y(end),res_r);
y2 = interp1(he1,y,he2);
[neut.XI, neut.YI] = meshgrid(xo2, y2);
neut.ZI = interp2(X,Y,Z,neut.XI,neut.YI,'spline');
neut.zlimneu = [0 matmax(neut.ZI)];
%
y = Pion.avg.x;
[X,Y] = meshgrid(xo,y);
Z = Pion.avg.z;
xo2 = interp1(linspace(1,lxo,lxo),xo,linspace(1,lxo,2*lxo));
he1 = linspace(y(1),y(end),length(y));
he2 = linspace(y(1),y(end),res_r);
y2 = interp1(he1,y,he2);
[ions.XI, ions.YI] = meshgrid(xo2, y2);
ions.ZI = interp2(X,Y,Z,ions.XI,ions.YI,'spline');
ions.zlimion = [0 matmax(ions.ZI)];
%------------------------------------------------------------- 3D ions plot
j=2; axes('Position',ax{j})
hold on
hl = line([40 53],0*[1 1],'Color','k','LineWidth',0.5);
hm = mesh(ions.XI,ions.YI,ions.ZI);
set(gca,'ydir','reverse')
set(gca,'xlim',xlim,'ylim',ylim)
set(gca,'xtick',xtick,'ytick',ytick)
set(hm, 'Linewidth', lw)
set(hm, 'EdgeColor', 'k', 'FaceColor', 'w')
plb = [0 -5 3.5*ions.zlimion(2)/neut.zlimneu(2)];
set(gca, 'view', ang)
set(gca,'fontsize', fonts)
set(gca, 'DataAspectRatio', [10 1.2 0.2*ions.zlimion(2)/neut.zlimneu(2)])
axis([0 240 -7 7 0 ions.zlimion(2)])
set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlim)
set(gca, 'GridLineStyle', '-')
set(gca, 'XGrid', 'on', 'XMinorGrid', 'off')
set(gca, 'YGrid', 'on', 'YMinorGrid', 'off')
set(gca, 'ZGrid', 'on', 'ZMinorGrid', 'off')
grid off
hold off
% set(gca, 'Projection', 'perspective')
xl = xlabel('B (mT)', 'FontSize', fonts);
  set(xl,'Position',[130 11 0])
yl = ylabel('r (cm)', 'FontSize', fonts);
  set(yl,'Position',[10 0 0])
zl = zlabel('intensity (arb.u.)', 'FontSize', fonts);
text(plb(1), plb(2), plb(3), '(b)', 'FontSize', fonts)

j=1; axes('Position',ax{j})
hold on  
hl = line([80 80],[-5.9 1.6],'Color','k','LineWidth',0.5);
hl = line([120 120],[-5.9 -3.2],'Color','k','LineWidth',0.5);
hl = line([40 135],[-5 -5],'Color','k','LineWidth',0.5);
hl = line([40 93],0*[1 1],'Color','k','LineWidth',0.5);
hl = line([40 52],5*[1 1],'Color','k','LineWidth',0.5);
hm = mesh(neut.XI,neut.YI,neut.ZI);
set(gca,'ydir','reverse')
set(gca,'xtick',xtick)
plb = [0 -5 3.5];
set(hm, 'Linewidth', lw)
set(hm, 'EdgeColor', 'k', 'FaceColor', 'w')
set(gca, 'view', ang)
set(gca, 'DataAspectRatio', [10 1.2 0.2])
axis([0 240 -7 7 0 neut.zlimneu(2)])
set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', neut.zlimneu)
set(gca, 'GridLineStyle', '-')
set(gca, 'XGrid', 'on', 'XMinorGrid', 'off')
set(gca, 'YGrid', 'on', 'YMinorGrid', 'off')
set(gca, 'ZGrid', 'off', 'ZMinorGrid', 'off')
grid off
hold off
% set(gca, 'Projection', 'perspective')
xl = xlabel('B (mT)', 'FontSize', fonts);
  set(xl,'Position',[130 11 0])
yl = ylabel('r (cm)', 'FontSize', fonts);
  set(yl,'Position',[10 0 0])
zl = zlabel('intensity (arb.u.)', 'FontSize', fonts);
set(gca,'fontsize', fonts)
text(plb(1), plb(2), plb(3), '(a)', 'FontSize', fonts)

%--------------------------------------------------------------- Print Plot
% fn = ['camera-profiles_18417-18437_vertical_2_x' epsx '.eps'];
fn = ['mkpic_RadialProfilesBscan_2_x' epsx '.eps'];
print('-depsc2','-r300',fn);
DO.Lb = 2.5; % length black
DO.Lw = 1.5; % length white
DA.Lb = 9.0; % length black
DA.Lw = 2.0; % length white
DD.Lb = 1.0; % length black
DD.Lw = 1.0; % length white
fct_plotstyle_lines(fn, DA, DO, DD)
%==========================================================================


% %--------------------------------------------------------------------------
% % Plot variant: Horizontal
% % All 4 diagrams below: 3D neu., 3D ions, rad. avg, rad. std
% %--------------------------------------------------------------------------
% fonts = 12;
% x0 = 0.06;
% y0 = 0.09; dy = 0.48;
% xw1 = 0.30; % Width of 3D
% xw2 = 0.47; % Width of 2D
% dx = 0.43;
% j=0;
% j=j+1; ax{j} = [x0+0*dx y0+1*dy-0.03 xw1 0.45];
% j=j+1; ax{j} = [x0+0*dx y0+0*dy-0.03 xw1 0.45];
% j=j+1; ax{j} = [x0+1*dx y0+1*dy xw2 0.37];
% j=j+1; ax{j} = [x0+1*dx y0+0*dy xw2 0.37];
% load('camerastatistics.mat');
% 
% % Define which profiles to use:
% ivec = [1 9 19];
% % critical curve index (at this index a threshold in profile change exist)
% icrit = 11;
% % middle curve index
% imiddle = 9;
% 
% colAr1 = rgb('Black');
% colAr2 = rgb('BurlyWood');
% 
% figeps(24,15,1); clf; j=0;
% %--------------------------------------------------------- 3D neutrals plot
% % Definitions for 3D plots:
% xo = round(1e3*B_CSDX(I_B)); lxo = length(xo);
% res_r = 100;
% ang = [-60 24];
% xlim = [40 240]; ylim = [-7 7];
% lw = 0.2;
% %
% j=j+1; axes('Position',ax{j})
% y = Pneu.avg.x;
% [X,Y] = meshgrid(xo,y);
% Z = Pneu.avg.z;
% xo2 = interp1(linspace(1,lxo,lxo),xo,linspace(1,lxo,2*lxo));
% he1 = linspace(y(1),y(end),length(y));
% he2 = linspace(y(1),y(end),res_r);
% y2 = interp1(he1,y,he2);
% [XI, YI] = meshgrid(xo2, y2);
% ZI = interp2(X,Y,Z,XI,YI,'spline');
% Pneu.mesh.x = XI;
% Pneu.mesh.y = YI;
% Pneu.mesh.z = ZI;
% zlimneu = [0 matmax(ZI)];
% hold on  
% hm = mesh(XI,YI,ZI);
% set(gca,'ydir','reverse')
% plb = [0 -5 3.5];
% set(hm, 'Linewidth', lw)
% set(hm, 'EdgeColor', 'k', 'FaceColor', 'w')
% set(gca, 'view', ang)
% set(gca, 'DataAspectRatio', [10 1.2 0.2])
% axis([0 240 -7 7 0 zlimneu(2)])
% set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlimneu)
% set(gca, 'GridLineStyle', '-')
% set(gca, 'XGrid', 'on', 'XMinorGrid', 'off')
% set(gca, 'YGrid', 'on', 'YMinorGrid', 'off')
% set(gca, 'ZGrid', 'on', 'ZMinorGrid', 'off')
% grid on
% hold off
% % set(gca, 'Projection', 'perspective')
% xl = xlabel('B (mT)', 'FontSize', fonts);
%   set(xl,'Position',[115 11 0])
% yl = ylabel('r (cm)', 'FontSize', fonts);
%   set(yl,'Position',[0 2 0])
% zl = zlabel('intensity (arb.u.)', 'FontSize', fonts);
% set(gca,'fontsize', fonts)
% text(plb(1), plb(2), plb(3), '(a)', 'FontSize', fonts)
% %------------------------------------------------------------- 3D ions plot
% j=j+1; axes('Position',ax{j})
% y = Pion.avg.x;
% [X,Y] = meshgrid(xo,y);
% Z = Pion.avg.z;
% xo2 = interp1(linspace(1,lxo,lxo),xo,linspace(1,lxo,2*lxo));
% he1 = linspace(y(1),y(end),length(y));
% he2 = linspace(y(1),y(end),res_r);
% y2 = interp1(he1,y,he2);
% [XI, YI] = meshgrid(xo2, y2);
% ZI = interp2(X,Y,Z,XI,YI,'spline');
% Pion.mesh.x = XI;
% Pion.mesh.y = YI;
% Pion.mesh.z = ZI;
% zlimion = [0 matmax(ZI)];
% hold on
% hm = mesh(XI,YI,ZI);
% set(gca,'ydir','reverse')
% set(hm, 'Linewidth', lw)
% set(hm, 'EdgeColor', 'k', 'FaceColor', 'w')
% plb = [0 -5 3.5*zlimion(2)/zlimneu(2)];
% set(gca, 'view', ang)
% set(gca,'fontsize', fonts)
% set(gca, 'DataAspectRatio', [10 1.2 0.2*zlimion(2)/zlimneu(2)])
% axis([0 240 -7 7 0 zlimion(2)])
% set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlim)
% set(gca, 'GridLineStyle', '-')
% set(gca, 'XGrid', 'on', 'XMinorGrid', 'off')
% set(gca, 'YGrid', 'on', 'YMinorGrid', 'off')
% set(gca, 'ZGrid', 'on', 'ZMinorGrid', 'off')
% grid on
% hold off
% % set(gca, 'Projection', 'perspective')
% xl = xlabel('B (mT)', 'FontSize', fonts);
%   set(xl,'Position',[115 11 0])
% yl = ylabel('r (cm)', 'FontSize', fonts);
%   set(yl,'Position',[0 2 0])
% zl = zlabel('intensity (arb.u.)', 'FontSize', fonts);
% text(plb(1), plb(2), plb(3), '(b)', 'FontSize', fonts)
% %-------------------------------------------------- Radial profile AVG plot
% % Definitions for 2D plots:
% lw = 1.0;
% xlim = 7*[-1 1];
% xtick = xlim(1):1:xlim(2);
% ylimavg = [0  4.1];
% ylimstd = [0 23.0];
% %
% j=j+1; axes('Position',ax{j})
% hold on
% for j=1:length(ivec)
%   i = ivec(j);
%   if i==imiddle; lis='--'; else lis='-'; end
%   switch i
%     case ivec(1); lis = ':';
%     case ivec(2); lis = '--';
%     case ivec(3); lis = '-';
%   end
%   plot(Pneu.avg.x,2*Pneu.avg.z(:,i),'LineWidth',lw,'Color',colAr1, ...
%     'LineStyle',lis)
%   plot(Pion.avg.x,Pion.avg.z(:,i),'LineWidth',lw,'Color',colAr2, ...
%     'LineStyle',lis)
% end
% hold off
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylimavg)
% mkplotnice('r (cm)', 'light intensity (arb.u.)',fonts,'-25','-30');
% dy = -20;
% puttextonplot(gca, [0 1],5,-15, '(c)' ,0,fonts,'k');
% puttextonplot(gca, [0 1],5,-50+0*dy, 'Ar I (2{\times})' ,0,fonts,colAr1);
% puttextonplot(gca, [0 1],5,-50+1*dy, 'Ar II',0,fonts,colAr2);
% % str = ['B_{crit}=' sprintf('%.0f',1e3*B_CSDX(I_B(icrit))) 'mT'];
% % puttextonplot(gca, [0 1],5,-50+2.5*dy,str,0,fonts,'k');
% %-------------------------------------------------- Radial profile STD plot
% j=j+1; axes('Position',ax{j})
% hold on
% for j=1:length(ivec)
%   i = ivec(j);
%   if i==imiddle; lis='--'; else lis='-'; end
%   switch i
%     case ivec(1); lis = ':';
%     case ivec(2); lis = '--';
%     case ivec(3); lis = '-';
%   end
%   plot(Pneu.std.x,2*Pneu.std.z(:,i),'LineWidth',lw,'Color',colAr1, ...
%     'LineStyle',lis)
%   plot(Pion.std.x,Pion.std.z(:,i),'LineWidth',lw,'Color',colAr2, ...
%     'LineStyle',lis)
% end
% hold off
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylimstd)
% mkplotnice('r (cm)','\sigma(light intensity) (arb.u.)', ...
%   fonts,'-25','-30');
% dy = -20;
% puttextonplot(gca, [0 1],5,-15, '(d)' ,0,fonts,'k');
% puttextonplot(gca, [0 1],5,-50+0*dy, 'Ar I (2{\times})' ,0,fonts,colAr1);
% puttextonplot(gca, [0 1],5,-50+1*dy, 'Ar II',0,fonts,colAr2);
% %--------------------------------------------------------------- Print Plot
% save('mkpic_RadialProfilesBscan.mat','Pion','Pneu')
% fn = ['camerastatistics_18417-18437_radprof_horizontal_res' ...
%   num2str(res_r) '.eps'];
% print('-depsc2','-r300',fn);
% DO.Lb = 2.5; % length black
% DO.Lw = 1.5; % length white
% DA.Lb = 9.0; % length black
% DA.Lw = 2.0; % length white
% DD.Lb = 1.0; % length black
% DD.Lw = 1.0; % length white
% fct_plotstyle_lines(fn, DA, DO, DD)
% %==========================================================================


% %==========================================================================
% % % Plot variant: Vertical
% % % All 4 diagrams below: 3D neu., 3D ions, rad. avg, rad. std
% %--------------------------------------------------------------------------
% fonts = 12;
% x0 = 0.13; xw = 0.82;
% j=0;
% j=j+1; ax{j} = [x0 0.70 xw 0.30];
% j=j+1; ax{j} = [x0 0.39 xw 0.30];
% j=j+1; ax{j} = [x0 0.205 1.0*xw 0.14];
% j=j+1; ax{j} = [x0 0.055 1.0*xw 0.14];
% load('camerastatistics.mat');
% 
% % Define which profiles to use:
% ivec = [1 9 19];
% % critical curve index (at this index a threshold in profile change exist)
% icrit = 11;
% % middle curve index
% imiddle = 9;
% 
% colAr1 = rgb('Black');
% colAr2 = rgb('BurlyWood');
% 
% figeps(12,26,1); clf; j=0;
% %--------------------------------------------------------- 3D neutrals plot
% % Definitions for 3D plots:
% xo = round(1e3*B_CSDX(I_B)); lxo = length(xo);
% res_r = 80;
% ang = [-60 24];
% xlim = [40 240]; ylim = [-7 7];
% lw = 0.2;
% %
% j=j+1; axes('Position',ax{j})
% y = Pneu.avg.x;
% [X,Y] = meshgrid(xo,y);
% Z = Pneu.avg.z;
% xo2 = interp1(linspace(1,lxo,lxo),xo,linspace(1,lxo,2*lxo));
% he1 = linspace(y(1),y(end),length(y));
% he2 = linspace(y(1),y(end),res_r);
% y2 = interp1(he1,y,he2);
% [XI, YI] = meshgrid(xo2, y2);
% ZI = interp2(X,Y,Z,XI,YI,'spline');
% zlimneu = [0 matmax(ZI)];
% hold on  
% hm = mesh(XI,YI,ZI);
% set(gca,'ydir','reverse')
% plb = [0 -5 3.5];
% set(hm, 'Linewidth', lw)
% set(hm, 'EdgeColor', 'k', 'FaceColor', 'w')
% set(gca, 'view', ang)
% set(gca, 'DataAspectRatio', [10 1.2 0.2])
% axis([0 240 -7 7 0 zlimneu(2)])
% set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlimneu)
% set(gca, 'GridLineStyle', '-')
% set(gca, 'XGrid', 'on', 'XMinorGrid', 'off')
% set(gca, 'YGrid', 'on', 'YMinorGrid', 'off')
% set(gca, 'ZGrid', 'on', 'ZMinorGrid', 'off')
% grid on
% hold off
% % set(gca, 'Projection', 'perspective')
% xl = xlabel('B (mT)', 'FontSize', fonts);
% yl = ylabel('r (cm)', 'FontSize', fonts);
% set(yl,'Position',[-945   68    9.7])
% zl = zlabel('intensity (arb.u.)', 'FontSize', fonts);
% set(gca,'fontsize', fonts)
% text(plb(1), plb(2), plb(3), '(a)', 'FontSize', fonts)
% %------------------------------------------------------------- 3D ions plot
% j=j+1; axes('Position',ax{j})
% y = Pion.avg.x;
% [X,Y] = meshgrid(xo,y);
% Z = Pion.avg.z;
% xo2 = interp1(linspace(1,lxo,lxo),xo,linspace(1,lxo,2*lxo));
% he1 = linspace(y(1),y(end),length(y));
% he2 = linspace(y(1),y(end),res_r);
% y2 = interp1(he1,y,he2);
% [XI, YI] = meshgrid(xo2, y2);
% ZI = interp2(X,Y,Z,XI,YI,'spline');
% zlimion = [0 matmax(ZI)];
% hold on
% hm = mesh(XI,YI,ZI);
% set(gca,'ydir','reverse')
% set(hm, 'Linewidth', lw)
% set(hm, 'EdgeColor', 'k', 'FaceColor', 'w')
% plb = [0 -5 3.5*zlimion(2)/zlimneu(2)];
% set(gca, 'view', ang)
% set(gca,'fontsize', fonts)
% set(gca, 'DataAspectRatio', [10 1.2 0.2*zlimion(2)/zlimneu(2)])
% axis([0 240 -7 7 0 zlimion(2)])
% set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlim)
% set(gca, 'GridLineStyle', '-')
% set(gca, 'XGrid', 'on', 'XMinorGrid', 'off')
% set(gca, 'YGrid', 'on', 'YMinorGrid', 'off')
% set(gca, 'ZGrid', 'on', 'ZMinorGrid', 'off')
% grid on
% hold off
% % set(gca, 'Projection', 'perspective')
% xl = xlabel('B (mT)', 'FontSize', fonts);
% yl = ylabel('r (cm)', 'FontSize', fonts);
%   set(yl,'Position',[-945   68    20.5])
% zl = zlabel('intensity (arb.u.)', 'FontSize', fonts);
% text(plb(1), plb(2), plb(3), '(b)', 'FontSize', fonts)
% %-------------------------------------------------- Radial profile AVG plot
% % Definitions for 2D plots:
% lw = 1.0;
% xlim = 7*[-1 1];
% xtick = xlim(1):1:xlim(2);
% ylimavg = [0  4.1];
% ylimstd = [0 23.0];
% %
% j=j+1; axes('Position',ax{j})
% hold on
% for j=1:length(ivec)
%   i = ivec(j);
%   if i==imiddle; lis='--'; else lis='-'; end
%   switch i
%     case ivec(1); lis = ':';
%     case ivec(2); lis = '--';
%     case ivec(3); lis = '-';
%   end
%   plot(Pneu.avg.x,Pneu.avg.z(:,i),'LineWidth',lw,'Color',colAr1, ...
%     'LineStyle',lis)
%   plot(Pion.avg.x,Pion.avg.z(:,i),'LineWidth',lw,'Color',colAr2, ...
%     'LineStyle',lis)
% end
% hold off
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylimavg)
% [hxl hyl] = mkplotnice('-1', '\Gamma(light) (arb.u.)',fonts,'-25','-30');
% dy = -20;
% puttextonplot(gca, [0 1],5,-15, '(c)' ,0,fonts,'k');
% puttextonplot(gca, [0 1],5,-50+0*dy, 'Ar I' ,0,fonts,colAr1);
% puttextonplot(gca, [0 1],5,-50+1*dy, 'Ar II',0,fonts,colAr2);
% str = ['B_{crit}=' sprintf('%.0f',1e3*B_CSDX(I_B(icrit))) 'mT'];
% puttextonplot(gca, [0 1],5,-50+2.5*dy,str,0,fonts,'k');
% %-------------------------------------------------- Radial profile STD plot
% j=j+1; axes('Position',ax{j})
% hold on
% for j=1:length(ivec)
%   i = ivec(j);
%   if i==imiddle; lis='--'; else lis='-'; end
%   switch i
%     case ivec(1); lis = ':';
%     case ivec(2); lis = '--';
%     case ivec(3); lis = '-';
%   end
%   plot(Pneu.std.x,Pneu.std.z(:,i),'LineWidth',lw,'Color',colAr1, ...
%     'LineStyle',lis)
%   plot(Pion.std.x,Pion.std.z(:,i),'LineWidth',lw,'Color',colAr2, ...
%     'LineStyle',lis)
% end
% hold off
% set(gca,'xlim',xlim,'xtick',xtick)
% set(gca,'ylim',ylimstd)
% mkplotnice('radius (cm)','\sigma(light) (arb.u.)', fonts,'-25','-30');
% dy = -20;
% puttextonplot(gca, [0 1],5,-15, '(d)' ,0,fonts,'k');
% puttextonplot(gca, [0 1],5,-50+0*dy, 'Ar I' ,0,fonts,colAr1);
% puttextonplot(gca, [0 1],5,-50+1*dy, 'Ar II',0,fonts,colAr2);
% %--------------------------------------------------------------- Print Plot
% fn = 'camerastatistics_18417-18437_radprof_vertical.eps';
% print('-depsc2','-r300',fn);
% DO.Lb = 2.5; % length black
% DO.Lw = 1.5; % length white
% DA.Lb = 9.0; % length black
% DA.Lw = 2.0; % length white
% DD.Lb = 1.0; % length black
% DD.Lw = 1.0; % length white
% fct_plotstyle_lines(fn, DA, DO, DD)
% %==========================================================================