function [nx,ny] = scalelin2log(xx,yy,logxmin)
% function [nx] = scalelin2log(xvec,logdx)
% Create a logarithmic scale from a linear vector, with equally spaced
% data-points.
%    xx: linear vector
% logdx: distance in the logarhitmic 
%    nx: new linear x-scale (for equal distances in semilogx-plot)
%    ny: new linear y-scale (for equal distances in semilogx-plot)
% EX: [nx,ny] = scalelin2log(xx,yy)
% Brandt: 2009-03-12

ctr=0; xmin=0; while xmin==0
  ctr = ctr+1;
  xmin = min(xx(ctr));
end
xmax = max(xx);
le_x = length(xx);

logdx = (log10(xmax)-log10(xmin))./le_x;
  xlog  = log10(xmin):logdx:log10(xmax);
     nx = 10.^(xlog);

% MAKE spline
spx  = interp(xx, 10);
cs   = spline(xx, yy);
  ny = ppval(cs, nx);

end