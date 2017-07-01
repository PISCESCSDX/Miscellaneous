function quivermovie(mode, res, ppp, per, zpos, d)
%function quivermovie(mode, res, ppp, per, zpos, d)
% !!! picture export: take care time stamp has correct position in eps
% IN: mode: MODE NO.
%     res: spatial resolution [mm]
%     ppp: points per period
%     per: # of periods
%     zpos: z-position of azimutal calculation slab
% EX: quivermovie(i, 4, 4, 1, -40, 100);
% for i=-3:-1; quivermovie(i,4,400,1,0,80);close all;clear all;end

if nargin<6; d=100; end
if nargin<5; zpos=0; end
if nargin<4; per=2; end
if nargin<3; ppp=20; end
if nargin<2; res=10; end
if nargin<1; mode=1; end

% FONTSIZE
  fsize = 16;

% === QUIVER PLOT OPTIONS ===
% if autoscale is switched off, the arrow length can be influenced 
% by this factor: quivf (ex: 10)
% remove all arrows bigger then quivavg*avg(arrow length)
switch mode
  case -1
  quivavg = 1;   % default 4
  quivlgth = 2;  % default 1.5 
  case -2
  quivavg = 0.7;   % default 4
  quivlgth = 4;  % default 1.5 
  case -3
  quivavg = 0.7;   % default 4
  quivlgth = 4;  % default 1.5   
end

% SIZE of XY-CALCULATION-SLAB [mm]
  dfd  = round(0.2*d);
  xmin = -d+dfd;
  xmax = +d-dfd;
  ymin = -d+dfd;
  ymax = +d-dfd;

% === EXCITER OPTIONS ===
% CURRENT [A]
  current_ampl=1;
% FREQUENCY
  freq = 1000;
% TIMESTEPS
  timesteps = ppp*per;
% DELTA_t for TIME ROW
  deltat = 1/(ppp*freq);

% CREATE MATRIX WITH OCTUPOLE WIRES
  wires = octwires;

% CALCULATION OF B-FIELD in T (Tesla)
  B=[0 0 0];
% CALCULATE BFIELD for one PERIOD
for it=1:ppp;
    disp_num(it, ppp)
    ctr = 0;
  phase = 2*pi*freq*(it-1)*deltat;
  counterix=1;
for ix=xmin:res:xmax
  counteriy=1;
  for iy=ymin:res:ymax
  ctr=ctr+1;
    for j=1:8
      phaseshift = -( ((360*mode)/8) /180*pi*(j-1));
      current = current_ampl*cos(phase+phaseshift);
      for i=1:4
        Bhelp=my_bfield_wire(wires(4*(j-1)+i,2), wires(4*(j-1)+i,3), ...
        wires(4*(j-1)+i,4), wires(4*(j-1)+i,5), wires(4*(j-1)+i,6), ...
        wires(4*(j-1)+i,7), current, wires(4*(j-1)+i,8), ix/1e3,iy/1e3,zpos/1e3);
        B=B+Bhelp;
      end;     
    end;
    moviemat(counterix,counteriy,it)=B(3);
    movloc(ctr, 1) = counterix;
    movloc(ctr, 2) = counteriy;
    movbx(ctr, it) = B(1);
    movby(ctr, it) = B(2);        
    B=[0 0 0];
    counteriy=counteriy+1;
  end;
  counterix=counterix+1;    
end;

end;


% PREPARATIONS for QUIVER-PLOT
% CALCULATE position vectors into real positions
  movloc(:,1) = (movloc(:,1)-1)*res+xmin;
  movloc(:,2) = (movloc(:,2)-1)*res+ymin;
% AVOID LONG QUIVER ARROWS
% Problem: if autoscale is off, there can be very long arrows, caused by
% a singularity point (e.g. bfield very near a infinite small wire).
% Try: look at the vector length(data), calculate the mean, set all vectors
% to zero, if the length is bigger then the mean.
  for tt=1:ppp
    for j=1:length(movbx(:,1))
      veclength(j,tt) = sqrt(movbx(j,tt).^2+movby(j,tt).^2);
    end
  end
  % CALCULATE MEAN of all VECTOR LENGTH
  vecmean = mean(mean(veclength));
%  for tt=1:ppp
  ctr=0;
    for j=1:length(movbx(:,1))
      % If along a timerow a vector is bigger then quivavg*vecmean ...)
      if sum(veclength(j,:)>=quivavg*vecmean)>0
        %overload matrix
        ctr=ctr+1;
         ovloc(ctr,1)=movloc(j,1);
         ovloc(ctr,2)=movloc(j,2);
         alpha=atan(movby(j,:)./movbx(j,:));
         ovbx(ctr,:)=sign(movbx(j,:)).*abs(quivavg*vecmean*cos(alpha));
         ovby(ctr,:)=sign(movby(j,:)).*abs(quivavg*vecmean*sin(alpha));
        %
        movbx(j,:)=NaN;
        movby(j,:)=NaN;
      end
    end
%  end
% CALCULATE a FACTOR to ENLARGE THE ARROWSIZE
  quivf = quivlgth*(res/vecmean);

% CALCULATE CIRCLE (50mm is inner radius of magn. exciter)
  xcirc = -51:1:51;
  ycirc = sqrt(51^2-xcirc.^2);
  
% MAKE MOVIE (AVI)
fig1=figure(1);
% pw = round([800 650]); % 400 350 ok for vlc and for xvid
pw = round([400 350]); % 400 350 ok for vlc and for xvid
set(gcf,'PaperUnits','points','PaperPosition',[1 1 pw(1) pw(2)],'Color','w');
% What You See Is What You Get (PRINTER and SRCEEN SHOW SAME)
  wysiwyg;
% MOVIE SETTINGS
% some tips for movie generation:
% - amount of frames should be 20, so avi-players work correcty
% - values of winsize must be integer, otherwise problems later on
  set(fig1,'DoubleBuffer','on');
  set(gca,'xlim',[-100 100], 'ylim',[-100 100], ...
    'NextPlot','replace','Visible','off')
  mov = avifile(['quiver_m' num2str(mode)]);
  mov.fps = 20;
  mov.quality = 100;
% USE THIS to get the whole window frame
  ws = get(fig1,'Position');
%
%
% PLOT AND MAKE MOVIE
for ip=1:per
for tt=1:ppp
  % ARROW PLOT
  hpl = quiver(movloc(:,1), movloc(:,2), ...
    quivf*movbx(:,tt), quivf*movby(:,tt), 2);
  set(hpl, 'linewidth', 0.5);
  set(hpl, 'autoscale', 'off');
  set(hpl, 'color', 'b');
  set(gca, 'xtick', [-50 0 50]);
  set(gca, 'ytick', [-50 0 50]);
  set(gca, 'fontsize', fsize);
  xlim([(-d+dfd) (d-dfd)]);  xlabel('x [mm]', 'fontsize', fsize);
  ylim([(-d+dfd) d]);  ylabel('y [mm]', 'fontsize', fsize);
  % ADD LEGEND
  hold on
    [vecnum vstr ndec] = numberunit(vecmean);
    vecnum = rounddec_adv(vecnum);
    legend=quiver([-0.9*(d-dfd) -0.9*(d-dfd)+d],[0.94*d 0],[quivf*quivavg*vecnum*ndec 0],[0 0]);
    set(legend, 'color', 'b',  'linewidth', 0.5, 'autoscale', 'off');
    text(-0.65*(d-dfd),0.94*d, [sprintf('%1.0f', vecnum) ' ' vstr 'T'], ...
       'fontsize', fsize-2);
    legend2=quiver([-0.9*(d-dfd) -0.9*(d-dfd)+d],[0.86*d 0],[0.5*quivf*quivavg*vecnum*ndec 0],[0 0]);
    set(legend2, 'color', 0.5*[1 1 1],  'linewidth', 0.5, 'autoscale', 'off');
    text(-0.65*(d-dfd),0.86*d, ['>' sprintf('%1.0f', vecnum) ' ' vstr 'T'], ...
       'fontsize', fsize-2);     
  hold off
  % CREATE GOOD SIZE OF AXES (for video export)
    set(gca, 'units', 'points');
      % widths of axes
      dx = xmax-xmin; dy = ymax-ymin;
      % COMPARE with width of figure:
      if pw(1)/pw(2)>=1
        awy = round(0.85*pw(2));
        awx = round(dx/dy*awy);       
      else
        awx = round(0.80*pw(1));
        awy = round(dy/dx*awx);     
      end
      apx = ws(1)+round(70);
      apy = ws(2)+round(40);
      apx = ws(1)+round(60); % 400 350: 70, 40
      apy = ws(2)+round(40);
    set(gca, 'position', [apx apy 0.9*awx awy]);
% PLOT INNER DIAMETER OF OCTUPOLE
  hold on;
  plot(xcirc, +ycirc,'-','LineWidth', 2, 'Color', 0.3*[1 1 1]);
  plot(xcirc, -ycirc,'-','LineWidth', 2, 'Color', 0.3*[1 1 1]);  
  hold off
% ADD TIME STAMP
  text(0.49*(d-dfd),0.94*d, ['t=' sprintf('%1.4f', (tt-1)/ppp+(ip-1)) ' T'], ...
      'fontsize', fsize-2);
% ADD SECOND QUIVER PLOT (RED)
hold on
  opl = quiver(ovloc(:,1), ovloc(:,2), 0.5*quivf*ovbx(:,tt), 0.5*quivf*ovby(:,tt), 2);
  set(opl, 'linewidth', 0.5);
  set(opl, 'autoscale', 'off');  
  set(opl, 'color', 0.5*[1 1 1]);
hold off
% TAKE VIDEO FRAMES
  for k=1:1 % more frames per second, otherwise vlc has problems
    F = getframe(fig1, ws);
    mov = addframe(mov,F);
  end
% % TAKE EPS-Pictures 
  pic_vec = (0:20:200)+1;
  if sum(tt==pic_vec)==1 & ip==1
    num = my_filename(tt, 3, '', '');
    fn = ['m' num2str(mode) '_' num '-' num2str(ppp) '.eps']
    print('-depsc2', '-r300', fn);    
  end
  clf;
end; %tt
end; %ip
mov = close(mov);

end