function [spx, spy] = mkspline(x, y, pts)
%==========================================================================
%function [spx, spy] = mkspline(x, y, pts)
%--------------------------------------------------------------------------
% Input is discrete data, output is the spline spx, spy.
%--------------------------------------------------------------------------
% spx: spline x-values
% spy: spline y-values
% x  : x vector
% y  : y vector
% pts: interpolating points (1: output=input, 2: double the points, 3: ...)
%--------------------------------------------------------------------------
% EX: pts = 10;
%     [spx, spy] = mkspline(x, y, pts)
%==========================================================================

  spx = interp(x, pts);
  ind = spx > min(x); spx = spx(ind);
  ind = spx < max(x); spx = spx(ind);
  
  cs  = spline(x, y);
  spy = ppval(cs, spx);

end