function [X, P_int_tria, P_int_plane, str_info] = ...
  fct_intersect_line_plane(v0, v1, p0, p1, p2)
%==========================================================================
%function [X] = fct_intersect_line_plane(v0, v1, p0, p1, p2)
% May 18 (2012), Christian Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% FCT_INTERSECT_LINE_PLANE calculates the intersection of a line with
% a plane. The plane is given by the three points 'p0', 'p1', 'p2'.
%--------------------------------------------------------------------------
%INPUT:
% v0: start point of straight line
% v1: end point of straight line
% p0, p1, p2: 3 point vectors spanning a triangular plane
%OUTPUT:
% X: contains parameters: [t, u, v] E RR
%    t: line parameter to intersection: line=v0+t*(v1-v0)
%    u, v: plane parameters: plane=p0+u*(p1-p0)+v*(p2-p0)
% P_int_tria: Point where line intersections the triangle (NaN if outside) 
% P_int_plane: Point where line intersections the plane defined by p0, p1, 
%              p2 (is equal to P_int_tria if within triangle p0, p1, p2)
% str_info: String describing intersection result.
%--------------------------------------------------------------------------
% EXAMPLE:
% % Define 3 test points for surface
% p0 = [+7 +3  0];
% p1 = [-3 +6 -2];
% p2 = [-2 -5  0];
% P  = [p0' p1' p2' p0'];
% % Define Line
% v0 = [-6 -3 +1];
% v1 = [ 0 +2 -2];
% 
% [X, P_int_tria, P_int_plane, str_info] = ...
% fct_intersect_line_plane(v0,v1,p0,p1,p2);
% 
% hold on
% plot3(P(1,:),P(2,:),P(3,:))
% %plot3(P_int_tria(1),P_int_tria(2),P_int_tria(3),'or')
% plot3(P_int_plane(1),P_int_plane(2),P_int_plane(3),'or')
% line([v0(1) v1(1)], [v0(2) v1(2)], [v0(3) v1(3)], 'Color', 'g')
% 
% grid on
% set(gca, 'view', [-68,30])
%==========================================================================

% Matrix A of plane=line vector equation
A = [v0(1)-v1(1), p1(1)-p0(1), p2(1)-p0(1);
     v0(2)-v1(2), p1(2)-p0(2), p2(2)-p0(2);
     v0(3)-v1(3), p1(3)-p0(3), p2(3)-p0(3)];
% Matrix B of plane=line vector equation
B = [v0(1)-p0(1); v0(2)-p0(2); v0(3)-p0(3)];

% X = linsolve(A,B) solves the linear system A*X = B to get the parameters
% t, u and v
X = linsolve(A,B);

% The line parameter t, and the plane parameters u and v
t = X(1);  u = X(2);  v = X(3);

% Check whether line intersects plane
if (u>=0 && u<=1) && (v>=0 && v<=1) && (u+v) <= 1
  str_info = 'line (v0, v1) intersects triangle spanned by p0, p1 and p2';
  P_int_tria = [v0(1)+t*(v1(1)-v0(1)); ...
                v0(2)+t*(v1(2)-v0(2)); ...
                v0(3)+t*(v1(3)-v0(3))];
  P_int_plane = P_int_tria;             
  return
end

% Calculate intersection point
if isnan(t)
  str_info = 'line (v0, v1) is parallel to plane spanned by p0, p1 and p2';
  P_int_tria  = NaN;
  P_int_plane = NaN;
else
 str_info = 'line (v0, v1) is intersecting plane spanned by p0, p1 and p2';
  P_int_tria  = NaN;
  P_int_plane = [v0(1)+t*(v1(1)-v0(1)); ...
                 v0(2)+t*(v1(2)-v0(2)); ...
                 v0(3)+t*(v1(3)-v0(3))];
end

end