function [m, n, x0] = line1d(p1, p2)
%==========================================================================
%function [m, n, x0] = line1d(p1, p2)
%--------------------------------------------------------------------------
% Line1D calculates the parameters of a line m, n for a given point pair.
% IN: p1, p2: 2D-point coordinates [x1 y1], [x2, y2]
%OUT: m=slope (+ increasing, - decreasing), n: y=f(0), x0: f(x)=0
%     normal line: m, n, x0 defined
%     perpendicular line (p2 above p1): m=+inf, n=-inf, x0 defined
%     perpendicular line (p1 above p2): m=-inf, n=+inf, x0 defined
%     no line, both points equal: m,n,x0=NaN
%--------------------------------------------------------------------------
% EX: [m, n, x0] = line1d([x1 y1], [x2 y2])
%==========================================================================

if p2(1)-p1(1)==0
  % perpendicular increasing line
  if p2(2)>p1(2)
    m = +Inf;
    n = -Inf;
    x0= p1(1);
  end
  % perpendicular decreasing line
  if p2(2)<p1(2)
    m = -Inf;
    n = +Inf;
    x0= p1(1);
  end
  % no line, both points are equal
  if p1(2)==p2(2)
    m = NaN;
    n = NaN;
    x0= NaN;
  end
else
  % normal 1d-line
  m = ( p2(2)-p1(2) ) / ( p2(1)-p1(1) );
  n = p1(2) - m*p1(1);

  % normal 1d-line parallel to x-axis
  if m==0
    x0 = +sign(p1(1)-p2(1))*Inf;
  else
    x0= -n/m;
  end
end

end