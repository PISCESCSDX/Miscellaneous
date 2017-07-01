load eex_5electodes.mat

x0 = 0.024; y0 = 0.13;
xw = 0.16; yw = 0.30;
dx = 0.19; dy = 0.50;

j=-1;
j=j+1; ax{j+1} = [0.02 0.38 xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*j y0+dy xw yw];
j=j+1; ax{j+1} = [x0+dx*(j-4) y0 xw yw];
j=j+1; ax{j+1} = [x0+dx*(j-4) y0 xw yw];
j=j+1; ax{j+1} = [x0+dx*(j-4) y0 xw yw];
j=j+1; ax{j+1} = [x0+dx*(j-4) y0 xw yw];

figeps(18,10,1); clf

xlim = 0.031*[-1 1];
ylim = 0.031*[-1 1];
clim = [-1 1];
climvec = linspace(clim(1), clim(2), 50);

for it=1:length(tv)

  % Plot m=0
  axes('Position',ax{1})
  pcolor(xv,yv,V{5,it}/220); shading interp
%   [~, hC] = contourf(xv,yv,V{im,it}, climvec);
%   set(hC,'LineStyle','none');
  mkplotnice('-1', '-1', 12, '-20', '-30');
  colormap(pastelldeep(128))
  set(gca, 'xlim', xlim, 'ylim', ylim)
  set(gca, 'clim', clim)
  subplotexciter(1.05*ex.r,ex.L,-11,3,'k',ex.N)
  
  i=1;
  for im=[4 3 2 1 6 7 8 9]
  i=i+1;
  axes('Position',ax{i})
  pcolor(xv,yv,V{im,it}/150); shading interp
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