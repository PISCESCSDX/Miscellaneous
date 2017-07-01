load mkpic_RadialProfilesBscan

j=0;
j=j+1; ax{j} = [0.15 0.56 0.80 0.40];
j=j+1; ax{j} = [0.15 0.11 0.80 0.40];


figeps(12,12,1); clf; fonts = 12; j=0;
j=j+1; axes('Position',ax{j})
xlim = 7*[-1 1];
x = Pneu.avg.x;
y = Pneu.avg.z(:,19);
ub = [1e3];  lb = [0.1];
fit_start = [1];
ffun = @(c,x) c(1)./((x.^2) + (c(1)/2)^2);
xx = x; yy = y;
options = optimset('Display','off','TolFun',1e-8);
ffit = lsqcurvefit(ffun, fit_start, xx, yy, lb, ub, options);
hold on
plot(x,y,'b')
plot(x,ffun(ffit,x),'r-')
hold off
set(gca,'xlim',xlim)
mkplotnice('-1','neutral light intensity (arb.u.)',fonts,'-25','-30');
puttextonplot(gca,[0 1],5,-15,'measurement',0,fonts,'b');
puttextonplot(gca,[0 1],5,-35,'fit',0,fonts,'r');

j=j+1; axes('Position',ax{j})
xlim = 7*[-1 1];
x = Pion.avg.x;
y = Pion.avg.z(:,19);
ub = [1e3];  lb = [0.1];
fit_start = [1];
ffun = @(c,x) c(1)./((x.^2) + (c(1)/2)^2);
xx = x; yy = y;
options = optimset('Display','off','TolFun',1e-8);
ffit = lsqcurvefit(ffun, fit_start, xx, yy, lb, ub, options);
hold on
plot(x,y,'b')
plot(x,ffun(ffit,x),'r-')
hold off
set(gca,'xlim',xlim)
mkplotnice('r (cm)','ion light intensity (arb.u.)',fonts,'-25','-30');
puttextonplot(gca,[0 1],5,-15,'measurement',0,fonts,'b');
puttextonplot(gca,[0 1],5,-35,'fit',0,fonts,'r');

print('-depsc2','testLorentzfit.eps')