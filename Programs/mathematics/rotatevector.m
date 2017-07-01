function [rrot] = rotatevector(a, r, alpha)
%function [rotvec] = rotatevector(a, r, alpha)
% ROTATEVECTOR rotates vector r around vector a by the angle alpha.
% Vector algebra calculated with Mathematica (camvec.nb).
% IN: a, r: [x,y,z]'
%     alpha: angle in rad
%OUT: rrot: [x,y,z]'
% EX: vec = rotatevector(a, r, alpha)

aa = sqrt(dot(a,a));
rr = sqrt(dot(r,r));
zn = dot(a,r)/aa;
xn = sqrt(rr^2 - zn^2);

rx = (a(1)*zn + cos(alpha)*(aa*r(1)-a(1)*zn) + ...
     sin(alpha)*(a(2)*r(3)-a(3)*r(2)) )/aa;
ry = (a(2)*zn + cos(alpha)*(aa*r(2)-a(2)*zn) + ...
     sin(alpha)*(a(3)*r(1)-a(1)*r(3)) )/aa;
rz = (a(3)*zn + cos(alpha)*(aa*r(3)-a(3)*zn) + ...
     sin(alpha)*(a(1)*r(2)-a(2)*r(1)) )/aa;

rrot = [rx, ry, rz];
end