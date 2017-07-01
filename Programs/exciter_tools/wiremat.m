function [mat] = wiremat;
% CREATION OF WIRE-MATRIX of the magnetic octupole.

% a length of short coil side /m
  a=0.0343;
% b length of long coil side /m
  b=0.155;
% distance to tube center
  rc=0.067;

% angle coil edge to x-axis
  small_phi = atan((a/2)/rc);
% distance to coil edge
  helpdist  = sqrt((a/2)^2 + rc^2);

for i=1:8
  alpha=45/180*pi*(i-1);
  x1=rc*cos(alpha+small_phi);
  y1=rc*sin(alpha+small_phi);
  x2=rc*cos(alpha-small_phi);
  y2=rc*sin(alpha-small_phi);
  % wire 1 (along z)
  mat(i,1) = x1;
  mat(i,2) = y1;
  mat(i,3) = x2;
  mat(i,4) = y2;
%   % PLOT for control of the z-wire positions
%     plot(x1,y1, 'ro'); hold on
%     plot(x2,y2, 'bo'); hold on
end;


end