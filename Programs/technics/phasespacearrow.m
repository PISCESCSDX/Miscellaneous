function phasespacearrow(pos2d, alpha, larrow, arrcol, arrwdth, currax, ...
  currfig)
%==========================================================================
%function phasespacearrow(pos2d, alpha, larrow, arrcol, arrwdth, currax)
%--------------------------------------------------------------------------
% Plots an 2D arrow head at the 2D point 'pos2d' to the direction 'alpha' 
% and the length 'larrow'.
%--------------------------------------------------------------------------
% IN: pos2d: [x y] coordinate of arrow tip in diagram scales
%     alpha: angle (mathematical sense)
%     larrow: length of arrow (in diagram scales)
%     arrcol: color of arrow
%     arrwdth: LineWidth of arrow
%--------------------------------------------------------------------------
% EX: phasespacearrow(pos2d, alpha, larrow, arrcol, arrwdth)
%==========================================================================

x0 = pos2d(1);
y0 = pos2d(2);

figxw = currfig.Position(3);
figyw = currfig.Position(4);

xlim = currax.XLim(2)-currax.XLim(1);
ylim = currax.YLim(2)-currax.YLim(1);
xw   = currax.Position(3)*figxw;
yw   = currax.Position(4)*figyw;

xratio = xw/xlim;
yratio = yw/ylim;

xfac = yratio/xratio;
yfac = 1;

% Define directions of left and right arrow line
angLe = alpha + 145/180*pi;
angRi = alpha - 145/180*pi;

% Calculate point 1 (x1,y1) and point 2 (x2,y2)
x1 = x0 + larrow*cos(angLe) *xfac;
y1 = y0 + larrow*sin(angLe) *yfac;

x2 = x0 + larrow*cos(angRi) *xfac;
y2 = y0 + larrow*sin(angRi) *yfac;

% Plot arrowhead
line([x0 x1], [y0 y1], 'Color', arrcol, 'LineWidth', arrwdth)
line([x0 x2], [y0 y2], 'Color', arrcol, 'LineWidth', arrwdth)

end