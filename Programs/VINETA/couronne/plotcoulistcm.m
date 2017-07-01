function [hax] = plotcoulistcm(num, xlb, numlist, tint, yoffs, lb, ...
  CLIM_fac, logx, str_col_cmplot)
%function [hax] = plotcoulistcm(num, xlb, numlist, tint, yoffs, lb, ...
%  CLIM_fac, logx)
%  Almost the same as plotcoulist: the kf-spectrum is missing and instead a
%  exciter trace is added. 
%  See PLOTCOULIST for details!


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
fft_xlim = [1 25];  % -1 for automatic


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fonts = 10;
figeps(20, 4, 1);

% at first plot timetrace, spectrum and zebra-plot
% some parameters for the optic of the whole diagram window
% PARAMETER for Axes-Position
x0 = [0.060 0.290 0.520 0.760];
y0 = 0.28;
xw = [0.150 0.150 0.170 0.200];
yw = 0.65;
ax{1} = [x0(1) y0 xw(1) yw];
ax{2} = [x0(2) y0 xw(2) yw];
ax{3} = [x0(3) y0 xw(3) yw];
ax{4} = [x0(4) y0 xw(4) yw];

lb = {['(' lb(1) ')'], ['(' lb(2) ')'], ['(' lb(3) ')'], ['(' lb(4) ')']};

lx = [ 3  3 85  2];
ly = [90 90 90 90];

switch xlb
  case 0
    xlb_tt    = '-1';
    xlb_fft   = '-1';
  case 1
    xlb_tt    = 'time [ms]';
    xlb_fft   = 'f [kHz]';
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
load 5____ex.mat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE THAT ALL PLOTS HAVE THE SAME AXIS LIMITS:
% find the plot limits for the tt-, fft-, zebra-, kf-plot from the numlist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(numlist)
  a(i,:) = ampl{numlist(i)};
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % CALCULATE I_sat I=U/R (100 OHM Shunt) in mA (*1000) 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  tsig{numlist(i)} = tsig{numlist(i)}/100 *1000; 
  ttamp(i,:) = tsig{numlist(i)} *1.2;
  %
  exsig{numlist(i)} = cm.volt{numlist(i)}; 
  exttamp(i,:) = exsig{numlist(i)} *1.2;
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

fftlim = [min(min(a)) max(max(a))]; 
ttlim  = [-matmax(abs(ttamp)) matmax(abs(ttamp))];
cmttlim  = [-matmax(abs(exttamp)) matmax(abs(exttamp))];
% SET XLIM FOR FFT-PLOT
if fft_xlim == -1
  fft_xlim = [freq(1) freq(length(freq))]./1e3;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZEBRA-PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=4;  
axes('Position', ax{j}); hax(j) = gca;
[hzp hcb] = subplotzebra(zt,phi,zA{num},xlb,tint,zebralim,0,fonts);
freezeColors(hzp);  freezeColors(hcb);
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME ROW OF CURRENT MONITOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=1;
axes('Position', ax{j});  hax(j) = gca;
[hyl hp] = subplottt(cm.tt*1e3, cm.volt{num}*1e3, xlb_tt, ...
  'I_{ex} [mA]', [0 2*tint], cmttlim*1e3, fonts);
set(hp, 'color', str_col_cmplot);
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME ROW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=2;
axes('Position', ax{j});  hax(j) = gca;
subplottt(ttrace*1e3, tsig{num}, xlb_tt, 'I_s [mA]', ...
    [0 2*tint], ttlim, fonts);
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT-PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # INPUT: logx axis?
j = 3;
axes('Position', ax{j}); hax(j) = gca;
% DEACTIVATE these Lines if no background should be shown
if num==numlist(1)
  subplotfftcol(freq, ampl{num}, xlb, fftlim, logx, fonts, fft_xlim);
else
  subplotfftduo(freq, ampl{num}, ampl{numlist(1)}, ...
    xlb, fftlim, logx, fonts, fft_xlim);
end
% % ACTIVATE these lines for not overlayed spectra
% subplotfft(freq, ampl{num(i)}, xlb, fftlim);
puttextonplot(gca, lx(j), ly(j), lb(j), 0, fonts);

end