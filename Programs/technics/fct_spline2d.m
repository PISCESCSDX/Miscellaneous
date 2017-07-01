function [xs, ys] = fct_spline2d(x, y, ds)
%==========================================================================
%function [xs, ys] = fct_spline2d(x, y, ds)
% Last change: 08.03.2012, San Diego, C. Brandt
% 08.03.2012, San Diego, C. Brandt
%--------------------------------------------------------------------------
% FCT_SPLINE2D calculates the 2D spline of a curve.
%--------------------------------------------------------------------------
% IN: x, y: vectors of curve (x,y)
%    ds: spline delta vector
%OUT: xs, ys: spline vectors
%--------------------------------------------------------------------------
% EXAMPLES: [xs, ys] = fct_spline2d(x, y, ds)
%==========================================================================


if nargin < 3
  ds = 0.1;
end

% Help vector
t = 1:numel(x);

% Spline help vector
ts = 1:ds:n;

% Spline x,y vectors
xs = spline(t, x, ts);
ys = spline(t, y, ts);

end