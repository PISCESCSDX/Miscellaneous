function [cb yh] = our_colorbar(lbl, fonts, dist, wdth, chpos, cbloc, ...
  caxislim, clim, xylim)
%==========================================================================
%function [cb yh] = our_colorbar(lbl, fonts, dist, wdth, chpos, cbloc, ...
%  caxislim, clim, xylim)
%--------------------------------------------------------------------------
%function varnargout = our_colorbar(lbl, fonts, dist, wdth, chpos, cbloc)
% OUR_COLORBAR generates a colorbar without resizing the current
% axes and sets the distance to the axes to chpos (of 1) and the
% width of the colorbar to wdth (of 1). The label is set to dist
% (of 1).
%--------------------------------------------------------------------------
% IN: 1: lbl: string with the label
%     2: fonts: fontsize
%     3: dist: distance label <-> axis
%     4: wdth: width of colorbar
%     5: chpos: distance colorbar-axis
%     6: cbloc: string with location [default:  EastOutside]
%     7: caxislim: limits for caxis
%     8: clim: limits for clim
%     9: xylim: limits of x- or y-axis, respectively, depending on cbloc
%OUT: handle of colorbar
%--------------------------------------------------------------------------
% EX: our_colorbar('\delta n [a.u.]', 12, 0.001, 0.015, 0.002);
%     cb = our_colorbar('S (dB)', 10, 5, 0.010, 0.015, 'EastOutside');
% our_colorbar(1: label,      2: fs,          3: dist lb-ax,
%              4: wdth,       5: dist cb-ax,  6: loc of cb,
%              7: caxis,      8: xy lim)
%==========================================================================

if nargin < 9; xylim=[]; end
if nargin < 8; clim=[]; end
if nargin < 7; caxislim=[]; end
if nargin < 6; cbloc = 'EastOutside'; end
if nargin < 5; chpos = 0.002; end
if nargin < 4; wdth = 0.015; end
if nargin < 3; dist = 1; end
if nargin < 2; fonts = 12; end
if nargin < 1; lbl = ''; end


% Get current axis positions
ah = gca();
ax_pos = get(ah, 'position');

% Create colorbar and reset axes
switch cbloc
  case 'EastOutside'
    cb = colorbar;
    if ~isempty(caxislim); caxis(caxislim); end
    if ~isempty(clim); set(cb, 'clim', clim); end
    if ~isempty(xylim); set(cb, 'ylim', xylim); end
    % Reshape colorbar (closer to axes and thinner) and reset axes
    cb_pos = [ ax_pos(1) + ax_pos(3) + chpos, ax_pos(2), wdth, ax_pos(4)];
    set(cb,'Position', cb_pos, 'Fontsize', fonts);
    % Ylabel
    yh     = ylabel(cb, lbl, 'fontsize', fonts);
    pos    = get(yh, 'position');
    pos(1) = dist;
    set(yh, 'position', pos);
  case 'NorthOutside'
    cb = colorbar(cbloc);
    if ~isempty(caxislim); caxis(caxislim); end
    if ~isempty(clim); set(cb, 'clim', clim); end
    if ~isempty(xylim); set(cb, 'xlim', xylim); end
    % Reshape colorbar (closer to axes and thinner) and reset axes
    cb_pos = [ ax_pos(1), ax_pos(2) + ax_pos(4) + chpos, ax_pos(3), wdth];
    set(cb,'Position', cb_pos, 'Fontsize', fonts);
    % Ylabel
    yh     = xlabel(cb, lbl, 'fontsize', fonts);
    pos    = get(yh, 'position');
    pos(2) = dist;
    set(yh, 'position', pos);
end

end