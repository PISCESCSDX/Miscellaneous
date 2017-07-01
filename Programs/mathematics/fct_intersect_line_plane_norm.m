function [P_int, String] = fct_intersect_line_plane_norm(v0, vd, p0, nv)
%==========================================================================
%function [X] = fct_intersect_line_plane_norm(v0, vd, p0, nv)
% May 18 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% FCT_INTERSECT_LINE_PLANE_NORM calculates the intersection of a line with
% a plane. The plane is given by its normal vector 'nv' and by one point on
% the plane 'p0'.
%--------------------------------------------------------------------------
%INPUT
% v0: start vector of line
% vd: direction vector of line    Line: v0 + t*vd
% p0: point on plane
% nv: normal vector of plane
%OUTPUT
% P_int: Intersection point
% String: 
%--------------------------------------------------------------------------
% Example:
% [P,str]=fct_intersect_line_plane_norm([0 0 2],[0 0 -1],[0 0 0],[0 0 1])
%==========================================================================


d_upper = dot( (p0 - v0), nv);
d_lower = dot(vd, nv);

if d_upper==0 && d_lower~=0
  String = 'Line is parallel to plane and not intersecting.';
  return
end

if d_upper==0 && d_lower==0
  String = 'Line is parallel to plane and intersecting.';
  return
end

% Parameter d:
d = d_upper/d_lower;

% Intersection point:
P_int = v0 + d*vd;
String = 'Line intersects plane in one point P_int.';

end