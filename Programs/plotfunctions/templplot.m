load('data.mat')
%==========================================================================
% Plot
%==========================================================================
sf = 0.8;
figx = 12.0  *sf;
figy = 10.0  *sf;
fig1 = figeps(figx,figy,1,5,5); clf
epsx = round(6.75*figx); % in mm
fonts = 12;

% Plot constants
x0 = 0.15;
xw = 0.80;
y0 = 0.15;
yw = 0.80;
ax{1} = [x0 y0 xw yw];

col(1,:) = [0.0 0.0 1.0];
col(2,:) = [1.0 0.0 0.0];
col(3,:) = [1.0 0.7 0.0];
col(4,:) = [0.0 1.0 0.0];
col(5,:) = [0.0 0.6 1.0];
col(6,:) = [1.0 0.0 0.8];

xlim  = [0.2 5.99];
xtick = ceil(xlim(1)):1:ceil(xlim(2));
ylim  = [-2 25];
ytick = 0:5:30;

% Plots
axes('position', ax{1})
hold on
  err = errorbar(x, dat, daterr);
  set(err, 'LineStyle', 'none')
  plot(x, y, 'Color', col(mode,:),'LineStyle', '-', 'LineWidth', 2)
hold off
set(err, 'Color', col(mode,:))
set(err, 'MarkerFaceColor', col(mode,:), 'MarkerEdgeColor', col(mode,:))
set(err, 'Marker', 'o', 'MarkerSize', 2.0)

set(gca, 'xlim', xlim, 'xtick', xtick)
set(gca, 'ylim', ylim, 'ytick', ytick)

mkplotnice('radius (cm)', 'frequency (kHz)', fonts, -30);

% Print
fn = ['20100226_dispersion_m' num2str(mode) '_'];
print('-depsc2', '-r300', [fn '.eps'])
print('-dpng', '-r300', [fn '.png'])

dy = -25;
puttextonplot_v2(gca, [0 1], 8, -15+0*dy, 'm_1', 0, fonts, col(1,:));
puttextonplot_v2(gca, [0 1], 8, -15+1*dy, 'm_2', 0, fonts, col(2,:));

%clf