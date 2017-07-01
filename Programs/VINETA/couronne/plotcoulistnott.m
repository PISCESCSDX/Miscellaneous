function [axfft, axzebra, axkf] = plotcoulistnott(num, xlb, numlist, tint, yoffs)
%function plotcoulistnott(num, xlb, numlist, tint, yoffs)
% Plot in one line: timerow, fft-spectrum, zebra-plot, kf-spectrum.
% You can chose wether the xlabels in the time, fft and zebra-plot
% are plotted.
%
%NEED: cnm*.BIN files of measurement (create with mdf2bin.m)
%      kf.mat-file produced by cnmeva
%      fft.mat-file produced by cnmeva
% IN: num: number vector measurement which should be plotted
%     ch: channel
%     xlb (opt) 1: xlabels on, 0: xlabels off
%     numlist (opt): vector of numbers of measurements which should be
%       taken into account for normalizing the z-axis
%     tint: time interval of time- and zebra-plot
%     yoffs: yoffset in case of dB-shift
%OUT: One plot with: time-, fft-, zebra-, kf-plot
%
% EX: plotcoulist(num, xlb, numlist, tint)
% EX-DEFAULT: plotcoulistnott([1:3], 1, [1:3], 2, 30);
% PRINT: print_adv([0 0 0 0 0 0 0 1 0 1 0 1], '-r300', 'test.eps')

if nargin < 5; yoffs = 0; end;
if nargin < 4; tint = -1; end;
if nargin < 3; numlist = num; end;
if nargin < 2; xlb = 1; end;
if nargin < 1; error('number of measurement(s) is missing ...'); end;

% FIGURE - get the amount of rows
  p_y = size(num, 2);
  figeps(20, 4.2*p_y, 1);

% load data evaluated from "cnmxxxx.BIN" files with "cnmeva.m"
  load 1____tt.mat
  load 2___fft.mat
  % smooth the power spectrum
  for i=1:length(ampl)
    ampl{i} = 20*log10(ampl{i}) + yoffs;
  end;
  load 3_zebra.mat
  load 4____kf.mat

% find the plot limits for the tt-, fft-, zebra-, kf-plot from the numlist
  for i=1:length(numlist)
    kfzlim(i) = kfaxis{numlist(i)}(6);
    a(i,:) = ampl{numlist(i)};
    ttamp(i,:) = tsig{numlist(i)};
    zA{numlist(i)} = zA{numlist(i)} - mean(mean( zA{numlist(i)} ));
    zebramax(i) = max(max(abs(zA{numlist(i)})));
  end;
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALIZE ZEBRA DATA to +1 & -1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zebralim = max(zebramax); 
for i=1:length(numlist)
  zA{numlist(i)} = zA{numlist(i)}./(zebralim);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET kf-maximum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
for i=1:length(numlist)
  kfaxis{numlist(i)}(6) = max(kfzlim);
end;

fftlim = [min(min(a)) max(max(a))]; 
ttlim = [min(min(ttamp)) max(max(ttamp))]; 

% plot all into one diagram & plot graphs which have more axes
% e.g. waterfall plots at the end for print_adv
% print with cb: print_adv([0 0 1 0 0], 100, 'test.eps')
% print without cb: print_adv([0 1 0 0], 100, 'test.eps')
% for jpeg-export: print -djpeg -r400 j01.jpeg

% at first plot timetrace, spectrum and zebra-plot
% some parameters for the optic of the whole diagram window
% PARAMETER for Axes-Position
  y0=0.30; yd=0.98;

% # LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% lb1 = {'(a)', '(d)', '(g)'};
% lb2 = {'(b)', '(e)', '(h)'};
% lb3 = {'(c)', '(f)', '(i)'};
lb1 = {'(j)', '(m)', '(p)'};
lb2 = {'(k)', '(n)', '(q)'};
lb3 = {'(l)', '(o)', '(r)'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZEBRA-PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:p_y
  axzebra = axes('Position', [0.37 ((y0+p_y-i)*yd)/p_y 0.25 0.67/p_y]);
  %
  [hzp hcb] = subplotzebra(zt, phi, zA{num(i)}, xlb, tint);
  freezeColors(hzp);  freezeColors(hcb);
  puttextonplot(gca, 2, 90, lb2(i), 0, 12);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FFT-PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # INPUT: logx axis?
logx = 1;
for i=1:p_y
  axfft = axes('Position', [0.08 ((y0+p_y-i)*yd)/p_y 0.22 0.67/p_y]);
% DEACTIVATE these Lines if no background should be shown
  if i==1
    subplotfftcol(freq, ampl{num(i)}, xlb, fftlim, logx);
  else
    subplotfftduo(freq, ampl{num(i)}, ampl{num(1)}, xlb, fftlim, logx);
  end  
  puttextonplot(gca, 87, 90, lb1(i), 0, 12);

% % ACTIVATE these lines for not overlayed spectra
% subplotfft(freq, ampl{num(i)}, xlb, fftlim);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KF-PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=p_y:-1:1
  axkf = axes('Position', [0.73 ((y0+p_y-i)*yd)/p_y-(0.07/p_y) 0.23 1.2*0.67/p_y]);
  subplotkf(kff, kfm, kfmat{num(i)}, kfaxis{num(i)}, 2, 2);
  puttextonplot(gca, 120, 220, lb3(i), 0, 12);
%  subplotkfcolcod(kff, kfm, kfmat{num(i)}, kfaxis{num(i)});
end;

end