% Jun-26-2013, C. Brandt, San Diego
% This m-file is for plotting certain specified camera frames of rawdata,
% or average removed or normalized to standard deviation.

% %==========================================================================
% % Plot a 3x3 plot (columns: different B-fields)
% %--------------------------------------------------------------------------
% d1 = 10; d2 = 10; d3 = 20;
% filebase{1} = '18423_f650_ap1.4'; iframe{1} = 560+[0 d1 2*d1];
% filebase{2} = '18429_f650_ap1.4'; iframe{2} = 100+[0 d2 2*d2];
% filebase{3} = '18437_f650_ap1.4'; iframe{3} = 560+[0 d3 2*d3];
% 
% % Figure Parameters
% figx = 18; epsx = 7.5 * figx;
% figeps(figx,18,1); clf;
% fonts = 12;
% x0 = 0.10; y0 = 0.09;
% xw = 0.27; yw = xw;
% dx = 0.30; dy = 0.28;
% j=0;
% j=j+1; ax{j} = [x0+0*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+0*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+0*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+0*dy xw yw];
% % Smoothing points of picture
% sm = 2;
% % Pixel to cm conversion
% pix2r = 0.1333;
% % Center position
% xc = 8.5; yc = 7.5;
% 
% j=0; % Reset axes counter
% for iB = 1:3
%   
%   filename = [filebase{iB} '.cine'];
%   info = cineInfo(filename);
%   fs = info.frameRate;
%   dt = 1/fs;
% 
%   savefn = [filebase{iB} '_statistics.mat'];
%   load(savefn);
%   x=1:size(movstat.avg,1);
%   y=1:size(movstat.avg,2);
% 
%   % Loop over 3 frames for each B-field
%   for i = 1:3
%     picraw = double(cineRead(filename, iframe{iB}(i)));
%     picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
%     picpixstd = (picraw - movstat.avg) ./ movstat.std;
% 
%     j=j+1; axes('Position',ax{j})
%     pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
%     pcolor(x*pix2r-xc,y*pix2r-yc,pic); shading interp
%     colormap(gray(64))
%     switch iB
%       case 1
%         clim = 2.1*[-1 1];
%       case 2
%         clim = 2.1*[-1 1];
%       case 3
%         clim = 3.1*[-1 1];
%     end
%     set(gca,'clim', clim)
%     if iB==1; lby = 'y (cm)'; else lby = '-1'; end
%     if  i==3; lbx = 'x (cm)'; else lbx = '-1'; end
%     mkplotnice(lbx, lby, fonts, '-22', '-28');
%     puttextonplot(gca, [0 1],5,-13,['#' num2str(iframe{iB}(i))],0,fonts,'w');
%     tstr = ['\tau=' sprintf('%.3f', ...
%       1e3*((iframe{iB}(i)-iframe{iB}(1))*dt)) 'ms'];
%     puttextonplot(gca, [0 1],5,-28,tstr,0,fonts,'w');
%     set(gca,'nextplot','replacechildren');
%     if i==1
%       mknicecolorbar('NorthOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
%       fonts-2, 0.15, 0.1, 3);
%     end
%   end
% end
% fn = ['3-Bfields_camera_3frames_x' num2str(round(epsx)) '.eps'];
% print_adv([1 1 0 1  1 1 0 1  1 1 0 1], '-r300', fn, 50, 4)
% return
% %==========================================================================


% %==========================================================================
% % Plot a 3x4 plot (rows: different B-fields)
% %--------------------------------------------------------------------------
% d1 = 10; d2 = 10; d3 = 20;
% filebase{1} = '18423_f650_ap1.4'; iframe{1} = 560+[0 d1 2*d1 3*d1];
% filebase{2} = '18429_f650_ap1.4'; iframe{2} = 100+[0 d2 2*d2 3*d2];
% filebase{3} = '18437_f650_ap1.4'; iframe{3} = 560+[0 d3 2*d3 3*d3];
% 
% % Figure Parameters
% figx = 24; epsx = 7.5*figx;
% figeps(24,18,1); clf;
% fonts = 12;
% x0 = 0.06; y0 = 0.08;
% xw = 0.21; yw = 1.35*xw;
% dx = 0.22; dy = 0.31;
% j=0;
% j=j+1; ax{j} = [x0+0*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+3*dx y0+2*dy xw yw];
% j=j+1; ax{j} = [x0+0*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+3*dx y0+1*dy xw yw];
% j=j+1; ax{j} = [x0+0*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+3*dx y0+0*dy xw yw];
% % Smoothing points of picture
% sm = 2;
% % Pixel to cm conversion
% pix2r = 0.1333;
% % Center position
% xc = 8.5; yc = 7.5;
% 
% j=0; % Reset axes counter
% for iB = 1:3
%   
%   filename = [filebase{iB} '.cine'];
%   info = cineInfo(filename);
%   fs = info.frameRate;
%   dt = 1/fs;
% 
%   savefn = [filebase{iB} '_statistics.mat'];
%   load(savefn);
%   x=1:size(movstat.avg,1);
%   y=1:size(movstat.avg,2);
% 
%   % Loop over 4 frames for each B-field
%   for i = 1:4
%     picraw = double(cineRead(filename, iframe{iB}(i)));
%     picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
%     picpixstd = (picraw - movstat.avg) ./ movstat.std;
% 
%     j=j+1; axes('Position',ax{j})
%     pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
%     pcolor(x*pix2r-xc,y*pix2r-yc,pic); shading interp
%     colormap(gray(64))
%     switch iB
%       case 1
%         clim = 2.1*[-1 1];
%       case 2
%         clim = 2.1*[-1 1];
%       case 3
%         clim = 3.1*[-1 1];
%     end
%     set(gca,'clim', clim)
%     if iB==3; lbx = 'x (cm)'; else lbx = '-1'; end
%     if  i==1; lby = 'y (cm)'; else lby = '-1'; end
%     mkplotnice(lbx, lby, fonts, '-22', '-28');
%     puttextonplot(gca, [0 1],5,-13,['#' num2str(iframe{iB}(i))],0,fonts,'w');
%     tstr = ['\tau=' sprintf('%.3f', ...
%       1e3*((iframe{iB}(i)-iframe{iB}(1))*dt)) 'ms'];
%     puttextonplot(gca, [0 1],5,-28,tstr,0,fonts,'w');
%     set(gca,'nextplot','replacechildren');
%     if i==4
%       mknicecolorbar('EastOutside', ...
%         '(p-{\langle}p{\rangle}) / \sigma_{xy}', fonts-2, 0.15, 0.1, 5);
%     end
%   end
% end
% fn = ['3-Bfields_camera_4frames_x' num2str(round(epsx)) '.eps'];
% print_adv([0 1 1 1 1  0 1 1 1 1  0 1 1 1 1], '-r300', fn, 50, 4)
% %==========================================================================


% %==========================================================================
% % Plot a 1x3 plot (columns: different B-fields)
% % (Size for Two-column Paper, single colum figure)
% %--------------------------------------------------------------------------
% d1 = 10; d2 = 10; d3 = 20;
% filebase{1} = '18423_f650_ap1.4'; iframe{1} = 560;
% filebase{2} = '18429_f650_ap1.4'; iframe{2} = 110;
% filebase{3} = '18437_f650_ap1.4'; iframe{3} = 600;
% 
% lbl = {'(a)','(b)','(c)'};
% 
% % Figure Parameters
% figx = 12; epsx = figx*7.5;
% figeps(12,6,1); clf;
% fonts = 12;
% x0 = 0.09; y0 = 0.21;
% xw = 0.28; yw = 0.57;
% dx = 0.31; dy = 0.28;
% j=0;
% j=j+1; ax{j} = [x0+0*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+1*dx y0+0*dy xw yw];
% j=j+1; ax{j} = [x0+2*dx y0+0*dy xw yw];
% % Smoothing points of picture
% sm = 2;
% % Pixel to cm conversion
% pix2r = 0.1333;
% % Center position
% xc = 8.5; yc = 7.5;
% 
% j=0; % Reset axes counter
% for iB = 1:3
%   
%   filename = [filebase{iB} '.cine'];
%   info = cineInfo(filename);
%   fs = info.frameRate;
%   dt = 1/fs;
% 
%   savefn = [filebase{iB} '_statistics.mat'];
%   load(savefn);
%   x=1:size(movstat.avg,1);
%   y=1:size(movstat.avg,2);
% 
%   % Loop over 3 frames for each B-field
%   for i = 1
%     picraw = double(cineRead(filename, iframe{iB}(i)));
%     picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
%     picpixstd = (picraw - movstat.avg) ./ movstat.std;
% 
%     j=j+1; axes('Position',ax{j})
%     pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
%     pcolor(x*pix2r-xc,y*pix2r-yc,pic); shading interp
%     colormap(gray(64))
%     switch iB
%       case 1
%         clim = 2.1*[-1 1];
%       case 2
%         clim = 2.1*[-1 1];
%       case 3
%         clim = 3.1*[-1 1];
%     end
%     set(gca,'clim', clim)
%     if iB==1; lby = 'y (cm)'; else lby = '-1'; end
%     if  i==1; lbx = 'x (cm)'; else lbx = '-1'; end
%     mkplotnice(lbx, lby, fonts, '-20', '-20');
%     set(gca,'nextplot','replacechildren');
%     if i==1
%       mknicecolorbar('NorthOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
%       fonts-2, 0.15, 0.1, 3);
%     end
%     puttextonplot(gca, [0 1],4,-12,lbl{iB},0,fonts,'w');
%   end
% end
% 
% fn = ['3-Bfields_camera_1frame_x' num2str(round(epsx)) '.eps'];
% print_adv([0 1 0 1 0 1], '-r300', fn, 50, 4)
% %==========================================================================


%==========================================================================
% Plot a 1x3 plot (columns: different B-fields)
% (Size for Two-column Paper, single colum figure)
%--------------------------------------------------------------------------
I_B = [130 160 190 230 260 290 320 360 390 420 460 ...
       490 520 560 590 620 650 680 720 750 780];
B_shots = B_CSDX(I_B);

shots = [7 13 21];

d1 = 10; d2 = 10; d3 = 20;
filebase{1} = '18423_f650_ap1.4'; iframe{1} = 560+[0 d1 2*d1 3*d1];
filebase{2} = '18429_f650_ap1.4'; iframe{2} = 100+[0 d2 2*d2 3*d2];
filebase{3} = '18437_f650_ap1.4'; iframe{3} = 560+[0 d3 2*d3 3*d3];

lbl = {'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)', ... 
       '(i)','(j)','(k)','(l)'};

% Figure Parameters
figx = 12; epsx = figx*7.5;
figeps(12,18,1); clf;
fonts = 12;
x0 = 0.09; y0 = 0.07;
xw = 0.28; yw = 0.19;
dx = 0.31; dy = 0.210;
j=0;
j=j+1; ax{j} = [x0+0*dx y0+3*dy xw yw];
j=j+1; ax{j} = [x0+0*dx y0+2*dy xw yw];
j=j+1; ax{j} = [x0+0*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+0*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+3*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+2*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+1*dx y0+0*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+3*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+2*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+1*dy xw yw];
j=j+1; ax{j} = [x0+2*dx y0+0*dy xw yw];
% Smoothing points of picture
sm = 2;
% Pixel to cm conversion
pix2r = 0.1333;
% Center position
xc = 8.5; yc = 7.5;

j=0; % Reset axes counter
for iB = 1:3
  
  filename = [filebase{iB} '.cine'];
  info = cineInfo(filename);
  fs = info.frameRate;
  dt = 1/fs;

  savefn = [filebase{iB} '_statistics.mat'];
  load(savefn);
  x=1:size(movstat.avg,1);
  y=1:size(movstat.avg,2);

  % Loop over 4 frames for each B-field
  for i = 1:4
    picraw = double(cineRead(filename, iframe{iB}(i)));
    picmaxstd = (picraw - movstat.avg) ./ matmax(movstat.std);
    picpixstd = (picraw - movstat.avg) ./ movstat.std;

    j=j+1; axes('Position',ax{j})
    pic = smoothBrochard(smoothBrochard(picpixstd,sm)',sm)';
    pcolor(x*pix2r-xc,y*pix2r-yc,pic); shading interp
    colormap(gray(64))
    switch iB
      case 1
        clim = 2.1*[-1 1];
      case 2
        clim = 2.1*[-1 1];
      case 3
        clim = 3.1*[-1 1];
    end
    set(gca,'clim', clim)
    if iB==1; lby = 'y (cm)'; else lby = '-1'; end
    if  i==4; lbx = 'x (cm)'; else lbx = '-1'; end
    mkplotnice(lbx, lby, fonts, '-20', '-20');
    set(gca,'nextplot','replacechildren');
    if i==1
      mknicecolorbar('NorthOutside','(p-{\langle}p{\rangle}) / \sigma_{xy}', ...
      fonts-2, 0.15, 0.1, 2.5);
      Bstr = ['B=' sprintf('%.0f', 1e3*(B_shots(shots(iB)))) 'mT'];
      puttextonplot(gca, [0 1],30,55,Bstr,0,fonts,'k');
    end
    puttextonplot(gca, [0 1],4,-12,lbl{j},0,fonts,'w');
    tstr = ['\tau=' sprintf('%.0f', ...
      1e6*((iframe{iB}(i)-iframe{iB}(1))*dt)) '{\mu}s'];
    puttextonplot(gca, [0 1],5,-28,tstr,0,fonts,'w');
  end
end

return

fn = ['3-Bfields_camera_4frames_x' num2str(round(epsx)) '-r200_q30.eps'];
print_adv([1 1 1 0 1  1 1 1 0 1  1 1 1 0 1], '-r200', fn, 30, 4)
%==========================================================================