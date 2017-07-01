function [hax] = plotcoulist(num, xlb, numlist, tint, yoffs, lb, ...
  CLIM_fac, logx)
%function [hax] = plotcoulist(num, xlb, numlist, tint, yoffs, lb, ...
%  CLIM_fac, logx)
% Plot in one line: timerow, fft-spectrum, zebra-plot, kf-spectrum.
% You can chose wether the xlabels in the time, fft and zebra-plot
% are plotted.
%
%NEED: cnm*.BIN files of measurement (create with mdf2bin.m)
%      kf.mat-file produced by cnmeva
%      fft.mat-file produced by cnmeva
% IN: num: number of measurement
%     ch: channel
%     xlb (opt) 1: xlabels on, 0: xlabels off
%     numlist (opt): vector of numbers of measurements which should be
%             taken into account for normalizing the y-axis
%     tint time interval of time- and zebra-plot
%     yoffs: contant sum
%     lbl_ypos: 1 abcd; 2 efgh; 3 ijkl
%     CLIM_fac: factor for the colors (mostly good 1-3)
%     logx: 1/0 f-axis logharithmic yes/no
%OUT: hax: axes handles
%     One plot with: time-, fft-, zebra-, kf-plot
%
% EX: plotcoulist(num, xlb, numlist, tint);
% EX: plotcoulist([2:3], 1, [1:2], 4);
%DEFAULT: plotcoulist([1 2 3], 1, [1 2 3], 4);
%         plotcoulist(1, 1, [1], 4, 0, 'abcd')
%         plotcoulist(1, 0, (1:3), 2, 0, 'abcd', CLIM_fac)
% print_adv([0 0 0 1], '-r300', 'cou0001.eps', 50)

if nargin < 8; logx = 1; end;
if nargin < 7; CLIM_fac = 3; end;
if nargin < 6; lb = 'abcd'; end;
if nargin < 5; yoffs = 0; end;
if nargin < 4; tint = -1; end;
if nargin < 3; numlist = []; end;
if nargin < 2; xlb = 1; end;
if nargin < 1; error('Number of measurement is missing!'); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ### INPUT ###
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fft_xlim = [1 60];  % -1 for automatic


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fonts = 12;
figeps(20, 4, 1);

% at first plot timetrace, spectrum and zebra-plot
% some parameters for the optic of the whole diagram window
% PARAMETER for Axes-Position
x0 = [0.065 0.295 0.51 0.76];
y0 = 0.28;
xw = [0.15 0.155 0.20 0.19];
yw = 0.65;
ax{1} = [x0(1) y0      xw(1) yw];
ax{2} = [x0(2) y0      xw(2) yw];
ax{3} = [x0(3) y0      xw(3) yw];
ax{4} = [x0(4) y0+0.04 xw(4) yw];

if strcmp(lb,'-1')
  lb = {'', '', '', ''};
else
  lb = {['(' lb(1) ')'], ['(' lb(2) ')'], ['(' lb(3) ')'], ['(' lb(4) ')']};
end

lx = [ 2 80  2 120];
ly = [90 90 89 220];

switch xlb
  case 0
    xlb_tt    = '-1';
    xlb_fft   = '-1';
  case 1
    xlb_tt    = 'time (ms)';
    xlb_fft   = 'f (kHz)';
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA evaluated from "cnmxxxx.BIN" files with "cnmeva.m"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load 1____tt.mat
load 2___fft.mat
% calculate the power spectrum and smooth
for i=1:length(ampl)
  ampl{i} = 20*log10(ampl{i}) + yoffs;
end;
load 3_zebra.mat
load 4____kf.mat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE THAT ALL PLOTS HAVE THE SAME AXIS LIMITS:
% find the plot limits for the tt-, fft-, zebra-, kf-plot from the numlist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(numlist)
  kfzlim(i) = kfaxis{numlist(i)}(6);
  a(i,:) = ampl{numlist(i)};
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % CALCULATE I_sat I=U/R (100 OHM Shunt) in mA (*1000) 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  tsig{numlist(i)} = tsig{numlist(i)}/100 *1000; 
  ttamp(i,:) = tsig{numlist(i)} *1.2;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % ZEBRA-STUFF
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  zA{numlist(i)} = zA{numlist(i)} - mean(mean( zA{numlist(i)} ));
  zebramax(i) = max(max(abs(zA{numlist(i)})));
  zebramean(i) = mean( mean( abs(zA{numlist(i)}) ) );
end;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALIZE ZEBRA DATA to +1 & -1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeb_mn = 1.4*max(zebramean);
zebralim = CLIM_fac*max(zeb_mn);
for i=1:length(numlist)
  zA{numlist(i)} = zA{numlist(i)}./zeb_mn;  % *0.6 for good color
%OLD  zA{numlist(i)} = zA{numlist(i)}./(zebralim) *0.8;  % *0.6 for good color
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET kf-maximum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
for i=1:length(numlist)
  kfaxis{numlist(i)}(6) = max(kfzlim);
end;

fftlim = [min(min(a)) max(max(a))]; 
ttlim  = [-matmax(abs(ttamp)) matmax(abs(ttamp))];
% SET XLIM FOR FFT-PLOT
if fft_xlim == -1
  fft_xlim = [freq(1) freq(length(freq))]./1e3;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZEBRA-PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=3;  
axes('Position', ax{j}); hax(j) = gca;
[hzp hcb] = subplotzebra(zt,phi,zA{num},xlb,tint,zebralim,0,fonts);
freezeColors(hzp);  freezeColors(hcb);
% set position of ylabel
hyl = get(gca, 'yLabel');
ylp = get(hyl, 'position');
set(hyl, 'position', [ylp(1)+0.15 ylp(2) ylp(3)]);
% put label
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME ROW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=1;
axes('Position', ax{j});  hax(j) = gca;
subplottt(ttrace*1e3, tsig{num}, xlb_tt, 'I_s (mA)', ...
    [0 2*tint], ttlim, fonts);
% set position of ylabel
hyl = get(gca, 'yLabel');
ylp = get(hyl, 'position');
set(hyl, 'position', [ylp(1)+0.10 ylp(2) ylp(3)]);
% put label
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT-PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # INPUT: logx axis?
j = 2;
axes('Position', ax{j}); hax(j) = gca;
% DEACTIVATE these Lines if no background should be shown
fftlim = [fftlim(1)   1]; % otherwise the maximum peak touches the top axis
if num==numlist(1)
  subplotfftcol(freq, ampl{num}, xlb, fftlim, logx, fonts);
else
  subplotfftduo(freq, ampl{num}, ampl{numlist(1)}, ...
      xlb, fftlim, logx, fonts);
end
% % ACTIVATE these lines for not overlayed spectra
% subplotfft(freq, ampl{num(i)}, xlb, fftlim);
set(gca, 'xlim', fft_xlim);
% set position of ylabel
hyl = get(gca, 'yLabel');
ylp = get(hyl, 'position');
set(hyl, 'position', [ylp(1)+0.10 ylp(2) ylp(3)]);
% put label
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts+1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KF-PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=4;
axes('Position', ax{j});  hax(j) = gca;
subplotkf(kff, kfmvec, kfmat{num}, kfaxis{num}, 0, 2, 2, 'm #', fonts);
% set position of zlabel
hyl = get(gca, 'zLabel');
ylp = get(hyl, 'position');
set(hyl, 'position', [ylp(1) ylp(2)+1.1 ylp(3)]);
% put label
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts+1);

end