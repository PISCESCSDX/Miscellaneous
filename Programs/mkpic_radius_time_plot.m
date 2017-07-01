% 2013-08-08_23:11, C. Brandt, San Diego
% This m-file plots the time-vs-radius plot of the movie, to show
% the packages that peel of and spiral inward. In this way the frequency
% can be determined that the velocity code can detect for inward flowing
% structures. (here we get something like 20kHz)

fname = '18437_f650_ap1.4.cine';
% 
pix(:,1) = (1:63)';
pix(:,2) = 68*ones(63,1);
chk = 'checkplot-on';
[tt,P] = pixel2tt(fname,pix,chk);

fonts = 12;
pix2r = 1.333;

figeps(12,8,1); clf;
axes('Position',[0.12 0.15 0.77 0.78])
q_avg = mean(P,1);
avg = q_avg'*ones(1,length(tt));
q_std = std(P,1);
norm = q_std'*ones(1,length(tt));
mat = (P'-avg) ./ norm;
pcolor(tt*1e3,((1:63)-63)*pix2r,mat)
shading interp
colormap(jet)
set(gca,'xlim',22+[0 1])
set(gca,'clim',[-1 1])
cb = mknicecolorbar('EastOutside','signal/\sigma(r) (arb.u.)',fonts-2,0.15,0.1,3);
mkplotnice('time (ms)', 'radius (mm)', fonts, '-20', '-30');

% print_adv([0 1], '-r300', '18437_f650_radius-time-plot.eps', 50, 4)
% Install 'netpbm' and 'jpg2ps' files ... 
return


% 
% % Calculate Frequency Spectra radially resolved
% fend = 35e3;
% for i=1:63
% [f,a,p] = fftspec(tt,mat(i,:)',0.2,0.5);
% amp(:,i) = a;
% end
% 
% i_f = find(f<35e3);
% x = ((1:63)-63)*pix2r;
% y = f(i_f)/1e3;
% z = amp(i_f,:);
% 
% figeps(12,8,2); clf;
% axes('Position',[0.12 0.15 0.77 0.78])
% pcolor(x,y,20*log10(z))
% shading flat
% set(gca,'clim', [-60 0])
% cb = mknicecolorbar('EastOutside','A (dB)',fonts-2,0.15,0.1,5);
% mkplotnice('radius (mm)', 'frequency (kHz)', fonts, '-20', '-30');
% % print_adv([0 1], '-r300', '18662_f650_radius-frequency-plot.eps', 50, 4)


filename = '18662_f650_ap1.7_velo_triangle_d1_t0001-5000_winrat0.20.mat';
cp = [66 66];
[rvec, vazavg] = Velocimetry2D_AVGazimuth(filename, cp);
fonts = 12;
xlim = [0 63];
figeps(12,13,3); clf;
df = 1000;
for fvec = 0+df:df:30000-df;
  clf;
  fa = fvec; fb = fvec+df;
  indf = find( (vazavg.freq>fa) & (vazavg.freq<fb));
%   vx = sum(vvec(:,:,indf,1),3) ./ numel(indf);
%   vy = sum(vvec(:,:,indf,2),3) ./ numel(indf);
  
  vazim = vazavg.vrad(:,:,indf);
  axes('Position',[0.15 0.55 0.80 0.40])
  yshow = mean(vazavg.vrad(:,:,indf),1);
  yshow = mean(yshow,3);
  plot(rvec, yshow, 'bd')
  set(gca,'ylim',[-1000 1000])
  set(gca,'xlim',xlim)
  mkplotnice('-1','v_r (m/s)',fonts,'-23','-35');
  % and vice versa: strangely uphi seems to behave like I expected urad
  axes('Position',[0.15 0.10 0.80 0.40])
  yshow = mean(vazavg.vtheta(:,:,indf),1);
  yshow = mean(yshow,3);
  plot(rvec, yshow, 'ro')
  set(gca,'ylim',[-1000 1000])
  set(gca,'xlim',xlim)
  mkplotnice('r (pixel)','v_\theta (m/s)',fonts,'-23','-35');
  
  puttextonplot(gca, [0 1], 5, +15, num2str([fa fb]), 0, 10,'k');
  
  input('Press Any Key to Continue')
end