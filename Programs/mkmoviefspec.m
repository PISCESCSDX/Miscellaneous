% movfile='18662_f650_ap1.7.cine';
% cp = [64 64];
% Nphi = 64;
% [rvec,fspec] = moviefspec(movfile,cp,Nphi);

fonts = 12;
figeps(12,8,1); clf; 
axes('position',[0.13 0.18 0.75 0.75])
pcolor(rvec,fspec.fre/1e3,fspec.amp)
shading flat
set(gca,'ylim',[0 20])
set(gca,'clim',[0 100])
mkplotnice('radius (pixel)','frequency (kHz)',fonts,'-20','-30');
cb = mknicecolorbar('EastOutside','A (arb.u.)',fonts,0.15,0.1,5);

print_adv([0 1], '-r300', 'moviefspec.eps', 50, 4)