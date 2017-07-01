% Jun-12-2013
% Calculate the average of those movies
% (C) Jul-10-2013 included mksum.m (lightfluc calculation)

I_B = [130 160 190 230 260 290 320 360 390 420 460 490 ...
  520 560 590 620 650 680 720 750 780];

%==========================================================================
% STEP 1: Calculate average picture of movie files
%--------------------------------------------------------------------------
a = dir('*f650*.cine');
b = dir('*f450*.cine');
c = [a;b];

% Define raw files to use (avoid overexposed rawdata)
% for i=1:length(c); disp([num2str(i) '  ' c(i).name]); end
%ivec = [1:21 22:40 42:43];
ivec = [6];

for i=1:length(ivec)
  filename{i} = c(ivec(i)).name;
end

% Aperture Area
% The f-number N is given by N = f/D
% where f is the focal length and D the diamter of the entrance pupil.
% A = pi (f / 2 N)^2
% A_1 = pi (f / 2 N_1)^2
% A_2 = pi (f / 2 N_2)^2
%
% A_2/A_1 = N_1^2 / N_2^2

% camera lens:
movstat.focal_length = 0.025; % 25mm

for ifile=1:length(ivec)
  % Extract the aperture
  filter = filename{ifile}(end-13:end-11);
  movstat.filter = str2double(filter);
  movstat.aperture = str2double(filename{ifile}(end-7:end-5));
  str_shot = filename{ifile}(1:5);
  disp(['*** Calculating statistics for shot # ' str_shot ' filter' filter])
  
  info_cine = cineInfo(filename{ifile});
  % Exposure time
  movstat.t_exp = info_cine.exposure;
  
  NumFrames = info_cine.NumFrames;
  
  % Sampling frequency
  fs = info_cine.frameRate;
  dt = 1/fs;
  
  %------------------------------------------ Calculate average movie image
  movstat.avg = 0;
  for i=1:NumFrames
    disp_num(i,NumFrames);
    pic = double(cineRead(filename{ifile}, i));
    movstat.avg = movstat.avg + pic;
  end
  movstat.avg = movstat.avg/NumFrames;

  %------------------------------------------- Calculate standard deviation
  movstat.std = 0;
  s = 0;
  flucpic = 0;
  for i=1:NumFrames
    disp_num(i,NumFrames);
    pic = double(cineRead(filename{ifile}, i));
    hv = (pic - movstat.avg).^2;
    s = s + hv;
    %
    s2 = abs( (pic-movstat.avg)./movstat.avg );
    flucpic = flucpic + s2;
    %
    lightfluc.min(i)     = matmin( (pic-movstat.avg) );
    lightfluc.max(i)     = matmax( (pic-movstat.avg) );
    lightfluc.minperc(i) = matmin( (pic-movstat.avg)./movstat.avg );
    lightfluc.maxperc(i) = matmax( (pic-movstat.avg)./movstat.avg );
    lightfluc.std(i)     =   std2( (pic-movstat.avg) );
    lightfluc.stdnorm(i) =   std2( (pic-movstat.avg)./movstat.avg );
  end
  movstat.std = sqrt(s/NumFrames);
  movstat.flucpic = flucpic/NumFrames;
  lightfluc.time = ((1:NumFrames)-1)*dt;
  lightfluc.amp = (lightfluc.max-lightfluc.min)/2;
  lightfluc.ampperc = (lightfluc.maxperc-lightfluc.minperc)/2;

  %--------------------------------------------------- Save statistics data
  filebase = filename{ifile}(1:end-5);
  savefn = [filebase '_statistics.mat'];
  save(savefn,'movstat','lightfluc');
  
end
return
%==========================================================================


%==========================================================================
% STEP 2: Calculate azimuthally averaged radial profiles
%--------------------------------------------------------------------------
% This m-file shoul test the newly written function Matrix2dAzimuthalAvg.m

% List all tif-files
dirion = dir('*f450*statistics.mat');
dirneu = dir('*f650*statistics.mat');
la= numel(dirion);

% Resolution of azimuthal angle
resphi = 128;
fonts = 12;
% Scan width around found maximum to search for best center (default: 10)
rd = 10;  

% NEUTRALS
figeps(16,16,1); clf;
figeps(16,16,2); clf;
for i=1:la
  disp( [num2str(i) ' ' sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT']);
  
  load(dirneu(i).name);
  
  % --- BEGIN: Find the best center ---
  matavg = movstat.avg;
  % Find start value: maximum of mat
  [v1, i1] = max(matavg);
  [ ~, colmax] = max(v1);
  rowmax = i1(colmax);
  vrow = -rd:1:rd;  vcol = vrow;
  int = zeros(numel(vrow),numel(vcol));
  for irow = 1:length(vrow)
    for icol = 1:length(vcol)
      cptest = [rowmax+vrow(irow) colmax+vcol(icol)];
      [rvec, mavg] = Matrix2dAzimuthAvg(matavg, cptest, resphi);
      y = std(mavg,1)';
      % Integration of standard deviation is a measure of deviation:
      int(irow,icol) = int_discrete(rvec,y);
    end
  end
  % Find indices of local minimum of integration matrix 'int'
  [v1, i1] = min(int);
  [ ~, colmin] = min(v1);
  rowmin = i1(colmin);
  % Store new center position to variable
  cp = [rowmax+vrow(rowmin) colmax+vcol(colmin)];
  prof.neu{i}.cp = cp;
  % --- END: Find the best center ---
  
  % Average Image
  area = pi * (movstat.focal_length /(2*movstat.aperture))^2;
  matavg = 1e-6* movstat.avg / (area * movstat.t_exp);
  [~, mavg] = Matrix2dAzimuthAvg(matavg, cp, resphi);
  % Standard Deviation Image
  matstd = 1e-6* movstat.std / (area * movstat.t_exp);
  [rvec, mstd] = Matrix2dAzimuthAvg(matstd, cp, resphi);

figure(1); clf;
subplot(2,2,1)
pcolor(matavg); shading flat
line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
puttextonplot(gca, [0 1], 5, -15, num2str(movstat.aperture), 0, 12, 'k');
axis square
title('initial matrix','FontSize',fonts)
mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');

subplot(2,2,2)
pcolor(mavg); shading flat
axis square
title('radial-azimuthal matrix','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');

subplot(2,2,3)
plot(rvec,mean(mavg,1))
set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
title('average radial profile','FontSize',fonts)
mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');

subplot(2,2,4)
y = std(mavg,1)';
plot(rvec,y)
set(gca,'xlim',[rvec(1) rvec(end)])
title('standard deviation of avg','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
int = int_discrete(rvec,y);
str = ['\int y dr = ' sprintf('%.3f',int)];
puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');

prof.neu{i}.rvec = rvec;
prof.neu{i}.avg = mean(mavg,1);
prof.neu{i}.std = mean(mstd,1);
prof.neu{i}.I_B = I_B(i);
prof.neu{i}.B = B_CSDX( I_B(i) );
info{1} = 'rvec in pixel; light data is normalized to area';
info{2} = 'matavg = 1e-6* movstat.avg / (area * movstat.t_exp);';
info{3} = 'area = pi * (movstat.focal_length /(2*movstat.aperture))^2;';


figure(2); clf;
subplot(2,2,1)
pcolor(matstd); shading flat
line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])

axis square
title('initial matrix','FontSize',fonts)
mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');

subplot(2,2,2)
pcolor(mstd); shading flat
axis square
title('radial-azimuthal matrix','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');

subplot(2,2,3)
plot(rvec,mean(mstd,1))
set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
title('average radial profile','FontSize',fonts)
mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');

subplot(2,2,4)
y = std(mstd,1)';
plot(rvec,y)
set(gca,'xlim',[rvec(1) rvec(end)])
title('standard deviation of avg','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
int = int_discrete(rvec,y);
str = ['\int y dr = ' sprintf('%.3f',int)];
puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
end


% IONS
figeps(16,16,1); clf;
figeps(16,16,2); clf;
for i=1:la
  disp( [num2str(i) ' ' sprintf('%.1f',1e3*B_CSDX( I_B(i) )) ' mT']);
  
  load(dirion(i).name);
  
  % --- BEGIN: Find the best center ---
  matavg = movstat.avg;
  % Find start value: maximum of mat
  [v1, i1] = max(matavg);
  [ ~, colmax] = max(v1);
  rowmax = i1(colmax);
  vrow = -rd:1:rd;  vcol = vrow;
  int = zeros(numel(vrow),numel(vcol));
  for irow = 1:length(vrow)
    for icol = 1:length(vcol)
      cptest = [rowmax+vrow(irow) colmax+vcol(icol)];
      [rvec, mavg] = Matrix2dAzimuthAvg(matavg, cptest, resphi);
      y = std(mavg,1)';
      int(irow,icol) = int_discrete(rvec,y);
    end
  end
  [v1, i1] = min(int);
  [ ~, colmin] = min(v1);
  rowmin = i1(colmin);
  cp = [rowmax+vrow(rowmin) colmax+vcol(colmin)];
  prof.ion{i}.cp = cp;
  % --- END: Find the best center ---
  
  % Average Image
  area = pi * (movstat.focal_length /(2*movstat.aperture))^2;
  matavg = 1e-6* movstat.avg / (area * movstat.t_exp);
  [~, mavg] = Matrix2dAzimuthAvg(matavg, cp, resphi);
  % Standard Deviation Image
  matstd = 1e-6* movstat.std / (area * movstat.t_exp);
  [rvec, mstd] = Matrix2dAzimuthAvg(matstd, cp, resphi);

figure(1); clf;
subplot(2,2,1)
pcolor(matavg); shading flat
line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])
puttextonplot(gca, [0 1], 5, -15, num2str(movstat.aperture), 0, 12, 'k');
axis square
title('initial matrix','FontSize',fonts)
mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');

subplot(2,2,2)
pcolor(mavg); shading flat
axis square
title('radial-azimuthal matrix','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');

subplot(2,2,3)
plot(rvec,mean(mavg,1))
set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
title('average radial profile','FontSize',fonts)
mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');

subplot(2,2,4)
y = std(mavg,1)';
plot(rvec,y)
set(gca,'xlim',[rvec(1) rvec(end)])
title('standard deviation of avg','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
int = int_discrete(rvec,y);
str = ['\int y dr = ' sprintf('%.3f',int)];
puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');

prof.ion{i}.rvec = rvec;
prof.ion{i}.avg = mean(mavg,1);
prof.ion{i}.std = mean(mstd,1);
prof.ion{i}.I_B = I_B(i);
prof.ion{i}.B = B_CSDX( I_B(i) );
info{1} = 'rvec in pixel; light data is normalized to area';
info{2} = 'matavg = 1e-6* movstat.avg / (area * movstat.t_exp);';
info{3} = 'area = pi * (movstat.focal_length /(2*movstat.aperture))^2;';


figure(2); clf;
subplot(2,2,1)
pcolor(matstd); shading flat
line([0.9*cp(2) 1.1*cp(2)],[0.9*cp(1) 1.1*cp(1)])
line([1.1*cp(2) 0.9*cp(2)],[0.9*cp(1) 1.1*cp(1)])

axis square
title('initial matrix','FontSize',fonts)
mkplotnice('horizontal', 'vertical', fonts, '-20', '-30');

subplot(2,2,2)
pcolor(mstd); shading flat
axis square
title('radial-azimuthal matrix','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\theta (arb.u.)', fonts, '-20', '-30');

subplot(2,2,3)
plot(rvec,mean(mstd,1))
set(gca,'xlim',[rvec(1) rvec(end)], 'ylim', [0 15])
title('average radial profile','FontSize',fonts)
mkplotnice('radius (arb.u.)', 'avg. value (arb.u.)', fonts, '-20', '-45');

subplot(2,2,4)
y = std(mstd,1)';
plot(rvec,y)
set(gca,'xlim',[rvec(1) rvec(end)])
title('standard deviation of avg','FontSize',fonts)
mkplotnice('radius (arb.u.)', '\sigma of avg. (arb.u.)',fonts,'-20','-35');
int = int_discrete(rvec,y);
str = ['\int y dr = ' sprintf('%.3f',int)];
puttextonplot(gca, [0 1],5,-15,str,0,fonts,'k');
end


% Store data
save('camerastatistics.mat','prof','info')
input('Press any key to continue ...')
%==========================================================================