function vf = vecfieldaddvec(xlim, ylim, dx, dy, vec1, vec2)
%==========================================================================
%function vf = vecfieldaddvec(xlim, ylim, dx, dy, vec1, vec2)
%--------------------------------------------------------------------------
% The 2D function VECFIELDADDVEC divides a certain x-y-range into dx and dy 
% parts, and adds a vector with the starting point vec1 and the end point 
% vec2 to this range.
% The variable vf contains the space coordinates x and y, and the vector
% components for each position.
%--------------------------------------------------------------------------
%INPUT
% xlim: [x0 xend]
% ylim: [y0 yend]
% dx:   delta x of the grid
% dy:   delta y of the grid
% vec1:  [v1x, v1y] vector components of point 1
% vec2:  [v2x, v2y] vector components of point 2
%--------------------------------------------------------------------------
% Example:
% vf = vecfieldaddvec([0 20], [0 60], 1, 1, [5 10], [18 50]);
% quiver(vf.x,vf.y,real(vf.vfield),imag(vf.vfield))
%--------------------------------------------------------------------------
% Last modification: C. Brandt, 08.12.2010
%==========================================================================

% create x-y-range
x = xlim(1):dx:xlim(2); lx = length(x);
y = ylim(1):dy:ylim(2); ly = length(y);

% create the meshgrid for 
[vf.x, vf.y] = meshgrid(x,y);

% initialize vf.vfield (complex vectorfield = 2D-field)
vf.vfield(1:ly, 1:lx) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Follow those fields, which the arrow (the vector) covers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p = p1 + t*s = p1 + t*(p2-p1)
%-------------------------------
% px = p1x + t*(p2x-p1x)
% py = p1y + t*(p2y-p1y)
%-------------------------------
p1x = vec1(1); p1y = vec1(2);
p2x = vec2(1); p2y = vec2(2);
p1 = p1x+1i*p1y;  p2 = p2x+1i*p2y;

% Calculate vector length
%L = sqrt((p2x-p1x)^2+(p2y-p1y)^2);
L = abs(p2-p1);

% Calculate direction vector s
s1x = p2x-p1x;  s1y = p2y-p1y;
s = s1x + 1i*s1y;

% Definition of the stepwidth of tracing the vector (the smaller the more
% exact the fields are found).
stepw = dx/5;

% Trace procedure
% Amount of steps: vector length / stepwidth
N = L/stepw;
Nfloor = floor(N);

% Definition: vector length added at each step
ds = s/N;

if Nfloor>0
  for j=0:Nfloor
    tvec = p1+j*ds;
    casx = floor((real(tvec)-x(1))/dx);
    casy = floor((imag(tvec)-y(1))/dy);  
    vf.vfield(casy,casx) = vf.vfield(casy,casx) + ds;
  end
end

end