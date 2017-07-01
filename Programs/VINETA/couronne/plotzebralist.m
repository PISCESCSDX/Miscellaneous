function plotzebralist(numv, ch, xlb, numlist, tint);
%
%FUNCTION PLOTZEBRALIST(numv, ch, xlb, numlist, tint);
% needs:    cnm*.BIN files of measurement (create with mdf2bin.m)
%  IN: numv: vector of numbers of measurement
%    ch: channel
%    xlb(opt): 1: xlabels on, 0: xlabels off
%    numlist(opt): vector of numbers of measurements which should be
%      taken into account for normalizing the y-axis of
%    tint: time interval of time- and zebra-plot
% OUT: One plot all zebraplots
% EXAMPLE: plotzebralist(num, ch, xlb, numlist, tint);
%          plotzebralist([1 2 3], 1, 1, [1 2 3], 1);

if nargin < 5; tint = -1; end;
if nargin < 4; numlist = []; end;
if nargin < 3; xlb = 1; end;
if nargin < 2; ch = 1; end;
if nargin < 1; error('Number of measurement is missing!'); end;

fonts = 14;

% get the amount of rows
  p_y = size(numv,2);

set(gcf,'PaperUnits','centimeters','PaperType','a4letter', ...
      'PaperPosition',[0 0 10 6*p_y], 'Color', [1.0 1.0 1.0]);
%-- make pictures look the same on printer and on screen
  wysiwyg;

  load 3_zebra.mat

% find the plot limits for the tt-, fft-, zebra-, kf-plot from the numlist
  for i=1:length(numv)
    zebramax(i) = max(max(abs(zA{numv(i)})));
  end;
  zebralim = max(zebramax);  

% at first plot timetrace, spectrum and zebra-plot
% some parameters for the optic of the whole diagram window
% PARAMETER for Axes-Position
  y0=0.25; yd=0.98;
  
% ZEBRA-PLOTS
for i=1:p_y
  axes('Position', [0.15 ((y0+p_y-i)*yd)/p_y 0.7 0.7/p_y]);
  [hzp hcb] = subplotzebra(zt, phi, zA{numv(i)}, xlb, tint, zebralim);
  freezeColors(hzp);  freezeColors(hcb);
end;

end