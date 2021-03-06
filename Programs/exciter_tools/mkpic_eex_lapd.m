load eex_lapd_21electodes.mat

x0 = 0.024; y0 = 0.13;
xw = 0.16; yw = 0.80;
dx = 0.19; dy = 0.00;

j=-1;
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];

figeps(28,6,1); clf

xlim = 0.031*[-1 1];
ylim = 0.031*[-1 1];
clim = [-1 1];
climvec = linspace(clim(1), clim(2), 50);

for it=1:length(tv)

  i=0;
  for im=[1 2 3 4 5]
  i=i+1;
  axes('Position',ax{i})
  pcolor(xv,yv,V{im,it}/10); shading interp
%   [~, hC] = contourf(xv,yv,V{im,it}, climvec);
%   set(hC,'LineStyle','none');
  mkplotnice('-1', '-1', 12, '-20', '-30');
  colormap(pastelldeep(128))
  set(gca, 'xlim', xlim, 'ylim', ylim)
  set(gca, 'clim', clim)
  subplotexciter(1.05*ex.r,ex.L,-11,3,'k',ex.N)
  end
 
%   ha = axes('Position', [0.85 0.10 0.05 0.86]);
%   hp = pcolor( rand(100,100,1) );
%   [cb, yh] = our_colorbar('signal', 12, 8, 0.015, 0.025, 'EastOutside');
%   set(ha, 'visible', 'off')
%   set(hp, 'visible', 'off')
%   pause(0.1);set(cb, 'ytick', [0 0.5 1], 'Yticklabel', {'-1', '0', '+1'})
  
  % fn = mkstring('eex','0',it,length(tv),'.png');  
%   fn = ['eex_' num2str(it) '.jpg'];
%   print('-djpeg','-r300',fn);
%  input('press any key')
  pause(0.05)
  clf
end


%==========================================================================
% Calculation of how much amplifiers are to be used
%--------------------------------------------------------------------------

N = ex.N;

% Calculate phase differences

N = 21;
m =  10;
pha = ((1:N)-1)*2*pi*m/N;
pha_pi = pha/(2*pi) - floor(pha/(2*pi));
plot(pha_pi, 'hr')