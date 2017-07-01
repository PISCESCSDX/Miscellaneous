%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 12;
lb1 = {'(a)', '(b)'};
lx = 5;
ly = -15;

% Axes business
dx = 0.50;
x0 = 0.10;
dy = 0.17;
y0 = 0.16;
xw = 0.35;
yw = 0.70;
%
i=0;
%
i=i+1; ax{i} = [x0+0*dx y0+0*dy xw yw];
i=i+1; ax{i} = [x0+1*dx y0+0*dy xw yw];


% Load density matrix
load plcart_Lz1400_m3_x5y5z100_zgrad11
load camsummary.mat

j=0;

%==========================================================================
% Look at fluctuation data (inverse mode)
%==========================================================================
ctr = 16;
i=8;
ctr = ctr-i;

% Plot density d3d
  j=j+1; axes('position', ax{j});
  mat = plas.d3d(:,:,ctr)-plas.d3d0(:,:,ctr);
  pcolor(plas.X, plas.Y, mat/1.8)
  set(gca, 'clim', [-1 1])
  set(gca, 'ytick', -200:50:200)
  shading interp
  axis square
  colormap pastell
  mkplotnice('x (mm)', 'y (mm)', fs-2, '-20', '-25');
  str = sprintf('%0.2f', i*0.050+0.750);
  puttextonplot(gca, [1 0], -60, 7, ['z=' str 'm'],0,fs-2,'k');
    [cb ~] = our_colorbar('\delta{n} (arb.u.)', fs-2, ...
    3, 0.020, -0.010, 'NorthOutside');
    set(cb, 'xtick', [-1 1])

i = 10;
  j=j+1; axes('position', ax{j});
  pcolor(invccdd.ccd{i}'/matmax(invccdd.ccd{15}))
  set(gca, 'clim', [-1 1])
  set(gca, 'xtick', 0:50:150, 'ytick', 0:50:150)
  shading interp
  axis square
  colormap pastell
  mkplotnice('x pixel', 'y pixel', fs-2, '-25', '-30');
    [cb ~] = our_colorbar('I_{light} (arb.u.)', ...
    fs-2, 3, 0.020, -0.010, 'NorthOutside');
    set(cb, 'xtick', [-1 1])