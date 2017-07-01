function htext = puttextonplot(haxis, bp, xpix, ypix, textstr, ...
  bgcol, fonts, txtcol)
%==========================================================================
% function htext = puttextonplot(haxis, bp, xpix, ypix, textstr, ...
%   bgcol, fonts, txtcol)
%--------------------------------------------------------------------------
%20080913-Sa-08:34 Brandt: differ between log & linear xy-scales
% PUTTEXTONPLOT puts a textstring "textstr" on a axis "haxis" at the 
% position (xpix, ypix) relative to the base position 'bp'.
% OUTPUT is the texthandle 'htext'. If bgcolor is one the background color 
% is white.
% Apply AFTER changing the scale type of the axes. Otherwise, the
% positioning gets incorrect.
%--------------------------------------------------------------------------
% IN: haxis: axis handle
%        bp: base position in relative values of the current ax.: [bpx bpy]
%            e.g. [0 1] is the left upper corner
%      xpix: absolut pixel value x-direction from bp
%      ypix: absolut pixel value y-direction from bp
%   textstr: text string
%     bgcol: if 1, sets bgcolor white, colorless if ~=1
%     fonts: fontsize (default 12)
%OUT: htext: handle of text object
%--------------------------------------------------------------------------
% EX: htext = puttextonplot(gca, [0 1], 5, -15, '(a)', 0, 12, 'k');
%==========================================================================

if nargin < 7; txtcol = 'k'; end;
if nargin < 6; fonts  = 12;  end;
if nargin < 5; bgcol  =  0;  end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Figure size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figsize = get(gcf, 'position');
figx = figsize(3);
figy = figsize(4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET Relative Axes size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axs = get(haxis, 'position');
% Absolute lengths of x- and y-axes
dax = axs(3)*figx;
day = axs(4)*figy;
% Relative distance to the base position (bp)
epx = bp(1) + xpix/dax;
epy = bp(2) + ypix/day;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET XLIM, YLIM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pxlim = get(haxis, 'xlim');
pylim = get(haxis, 'ylim');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SCALES ("linear" or "log")    (log means log10)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  xsc = get(haxis, 'xscale');
  ysc = get(haxis, 'yscale');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALC POSITIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch xsc
  case 'log'
    dx = log10(pxlim(2)) - log10(pxlim(1));
    xpos = 10^( log10(pxlim(1)) + dx*epx );
  case 'linear'
    dx = pxlim(2)-pxlim(1);
    xpos = pxlim(1) + dx*epx;
end

switch ysc
  case 'log'
    dy = log10(pylim(2)) - log10(pylim(1));
    ypos = 10^( log10(pylim(1)) + dy*epy );
  case 'linear'
    dy = pylim(2)-pylim(1);
    ypos = pylim(1) + dy*epy;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUT TEXT ON PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
htext = text(xpos, ypos, textstr);
set(htext, 'fontsize', fonts);
if bgcol == 1
  set(htext, 'backgroundColor', 'w');
end

  set(htext, 'Color', txtcol);
  p=get(htext,'position'); set(htext,'position', [p(1) p(2) 1])

end