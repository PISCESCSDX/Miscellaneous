% % fname = '18662_f650_ap1.7.cine';
% % 
% % pix(:,1) = (1:63)';
% % pix(:,2) = 68*ones(63,1);
% % chk = 'checkplot-on';
% % [tt,P] = pixel2tt(fname,pix,chk);
% 
% fonts = 12;
% pix2r = 1.333;
% 
% figeps(12,8,1); clf;
% axes('Position',[0.12 0.15 0.77 0.78])
% q_avg = mean(P,1);
% avg = q_avg'*ones(1,length(tt));
% q_std = std(P,1);
% norm = q_std'*ones(1,length(tt));
% mat = (P'-avg) ./ norm;
% pcolor(tt*1e3,((1:63)-63)*pix2r,mat)
% shading interp
% colormap(pastelldeep(64))
% set(gca,'clim', 2*[-1 1])
% cb = mknicecolorbar('EastOutside','signal/\sigma(r) (arb.u.)',fonts-2,0.15,0.1,3);
% mkplotnice('time (ms)', 'radius (mm)', fonts, '-20', '-30');
% % print_adv([0 1], '-r300', '18662_f650_radius-time-plot.eps', 50, 4)
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

cp = [63 66];
filename = '18662_f650_ap1.7_velo_triangle_d1_t0001-5000_winrat1.00.mat';
% [rvec, vazavg] = Velocimetry2D_AVGazimuth(filename, cp);
fonts = 12;
xlim = [0 80];
figeps(12,13,3); clf;
df = 1000;
pix2r = 1.333;

% fa = 18600; fb = 19000; startx_red = 0; starty_red = -4.0;
% fa = 19400; fb = 19970; startx_red = 0; starty_red = -4.0;
% fa = 22240; fb = 22940;

fvec = [18600 19000];
for i = 1:length(fvec)-1
  clf;
  %fa = fvec; fb = fvec+df;
  fa = fvec(i); fb = fvec(i+1);
  indf = find( (vazavg.freq>fa) & (vazavg.freq<fb));
%   vx = sum(vvec(:,:,indf,1),3) ./ numel(indf);
%   vy = sum(vvec(:,:,indf,2),3) ./ numel(indf);
  
  vazim = vazavg.vrad(:,:,indf);
  axes('Position',[0.15 0.55 0.80 0.40])
  yshow = mean(vazavg.vtheta(:,:,indf),1);
  yshow = mean(yshow,3);
  ysm = smooth(rvec*pix2r, yshow,0.5,'rloess');
  xsm2 = 5:0.1:80;
  ind = [5:39 42:63];
  ysm2 = csaps(rvec(ind)*pix2r, yshow(ind), 0.20, xsm2);
  hold on
  plot(rvec*pix2r, yshow, 'ro')
  %plot(rvec*pix2r, ysm, 'r-')
  plot(xsm2, ysm2, 'r-')
  hold off
  set(gca,'ylim',[-500 1200])
  set(gca,'xlim',xlim)
  mkplotnice('-1','v_\theta (m/s)',fonts,'-23','-35');
  str = [num2str(round(fa)) ' to ' num2str(round(fb)) ' Hz'];
  ha = puttextonplot(gca, [0 1],2,-9,str,1,fonts-2,'k');
  
  % and vice versa: strangely uphi seems to behave like I expected urad
  axes('Position',[0.15 0.10 0.80 0.40])  
  yshow = mean(vazavg.vrad(:,:,indf),1);
  yshow = mean(yshow,3);
  ind = [5:23 25:63];
  ysm = smooth(rvec(ind)*pix2r, yshow(ind),0.1,'rloess');
  xsm2 = 5:0.5:35;
  ysm2 = csaps(rvec(ind)*pix2r, yshow(ind), 0.15, xsm2);
  hold on
  plot(rvec*pix2r, yshow, 'bd')
  %plot(rvec*pix2r, ysm, 'b-')
  plot(xsm2, ysm2, 'b-')
  hold off
  set(gca,'ylim',[-300 300])
  set(gca,'xlim',xlim)
  mkplotnice('r (mm)','v_r (m/s)',fonts,'-23','-35');
end

fn = [filename(1:end-4) '_vtheta-vr-avg_19kHz.eps'];
print('-depsc2',fn)