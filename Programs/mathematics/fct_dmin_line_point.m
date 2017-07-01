function [dmin, tmin, pmin] = fct_dmin_line_point(v1, v2, p)
%==========================================================================
%function [dmin, tmin, pmin] = fct_dmin_line_point(v1, v2, p)
%--------------------------------------------------------------------------
% Calculates the minimal distance between a straight line and a point in
% 3D space.
% v1 and v2 are vectors defining the line: line = v2 + t*(v2-v1)
% p is the point in space.
%
% If [0 <= tmin <= 1] minimal distance lies between v1 and v2.
%--------------------------------------------------------------------------
% dmin: absolute value of minimal distance
% tmin: t minimal  line = v2 + t*(v2-v1)
% pmin: point on line of minimal distance
%--------------------------------------------------------------------------
% Example
%[dmin, tmin, pmin] = fct_dmin_line_point([0 0 0], [1 1 0], [1 1 1])
%==========================================================================

% Direction vector of line
q = v2-v1;

tmin = ( dot(p,q) - dot(v2,q) ) / dot(q,q);
dmin = norm(p-(v2+tmin*q));
pmin = v2 + tmin*(v2-v1);

end