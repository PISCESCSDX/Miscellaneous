function cb = mknicecolorbar(cbloc, lbl, fonts, width, dist, lbldist)
%==========================================================================
%function cb = mknicecolorbar(cbloc, lbl, fonts, width, dist, lbldist)
%--------------------------------------------------------------------------
% MKNICECOLORBAR generates a colorbar without resizing the current axes.
% Uses the downloaded function CBFREEZE.
% Jun-14-2013, C. Brandt, San Diego
%--------------------------------------------------------------------------
%INPUT
% cbloc: string of location of colorbar (using like COLORBAR, EastOutside,
%        NorthOutside)
% lbl: string of colorbar label
% fonts: fontsize
% (optional) width: width of colorbar (in cm, default 0.15)
% (optional) dist: distance of colorbar from diagram (in cm, default 0.1)
% (optional) lbldist: distance of label from colorbar (in cm, default 0.5)
%OUTPUT
%  cb: structure of colorbar properties
%    .handle: colorbar handle
%    .label: colorbar label
%--------------------------------------------------------------------------
%EXAMPLE
% figeps(12,8,1);
% axes('position',[0.18 0.18 0.70 0.70]);
% pcolor(peaks(64)); shading flat
% mkplotnice('x (x-units)', 'y (y-units)',12,'-23','-25');
% cb = mknicecolorbar('EastOutside','Intensity (arb.u.)',12,0.15,0.1,3);
% cb = mknicecolorbar('NorthOutside','Intensity (arb.u.)',12,0.15,0.1,3);
%==========================================================================

if nargin < 6; lbldist = 0.50; end
if nargin < 5;    dist = 0.10; end
if nargin < 4;   width = 0.15; end
if nargin < 3;   fonts = 12  ; end
if nargin < 2;     lbl = ''  ; end


% Get current axis positions
cuax = gca();
cuaxpos = get(cuax,'Position');

% Create colorbar and reset axes
cbold = colorbar(cbloc);
% Create frozen colorbar and get the handle
cb.handle = cbfreeze2017(cbold);

% Measure width of figure in centimeters
figunits = get(gcf, 'Units');
set(gcf,'Units','centimeters');
figpos = get(gcf, 'Position');
% Reset Figures Units
set(gcf,'Units',figunits);

% Reset the changed position of the current axes
set(cuax,'Position',cuaxpos)
% Set the fontsize of the colorbar
set(cb.handle,'FontSize',fonts)
% Set the label of the colorbar
cb.label = cblabel(cb.handle,lbl);
set(cb.label,'FontSize',fonts)

switch cbloc
  case 'EastOutside'
    wrat = width/figpos(3);
    drat = dist/figpos(3);
    % Set the position of the colorbar
    newpos = [cuaxpos(1)+cuaxpos(3)+drat cuaxpos(2) wrat cuaxpos(4)];
    set(cb.handle,'Position',newpos)
    p = get(cb.label,'Position');
    set(cb.label,'position',[lbldist p(2) 1.01])
  case 'NorthOutside'
    wrat = width/figpos(4);
    drat = dist/figpos(4);
    % Set the position of the colorbar
    newpos = [cuaxpos(1) cuaxpos(2)+cuaxpos(4)+drat cuaxpos(3) wrat];
    set(cb.handle,'Position',newpos)
    p = get(cb.label,'Position');
    set(cb.label,'position',[p(1) lbldist 1.01])
end

end