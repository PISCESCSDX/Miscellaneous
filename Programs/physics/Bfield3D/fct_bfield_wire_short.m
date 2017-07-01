function Bvec=fct_bfield_wire_short(S1, S2, current, windings, R)
%==========================================================================
%function Bvec=fct_bfield_wire_short(S1, S2, current, windings, R)
% (prooved 18.10.2008 C. Brandt)
%--------------------------------------------------------------------------
% Calculates the B-field-components Bx, By, Bz in a point P(rx, ry, rz). 
% The B-field is created by an infinite thin even short wire where 
% S1(s1x, s1y, s1z) and S2(s2x, s2y, s2z) are the start and end points of
% the wire. The current direction points from S1 to S2.
%
% The calculation is done with the Biot-Savart-Law for steady state
% currents. For a finite even thin wire is obtained an analytical 
% solution for Bx, By, Bz.
%
% The coordinate-system:
%     y
%     ^
%     |
%   --+---->x
%    /|
%   z
%--------------------------------------------------------------------------
% IN: S1 = [s1x, s1y, s1z]  start point of wire (m)
%     S2 = [s2x, s2y, s2z]  end point of wire (m)
%     current         current through one winding (A)
%     windings        number of coil windings (effects like a factor)
%     R = [rx, ry, rz]  coordinates of the point where the Bfield
%                       should be calculated (m)
%OUT: Bvec = [Bx, By, Bz]  Bfield components at R in Tesla
%--------------------------------------------------------------------------
% EX: B = bfield_wire([0,-100,0] , [0,100,0] , 1, 100, [0.02,0,0] ) :
%     B = [0 0 -1e-3]; This is in absolute agreement with the 
%     calculated Bt = -4*pi*1e-7*1*100./(2*pi.*0.02) for the
%     even infinite long wire B_wire = mu0*I/(2*pi*r)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Short Script to compare the short wire calculation to the infinite wire
%%% (The longer the short wire, the more equal both results should be!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % The ratio distance/wire length indicates, when the deviation gets large.
% % red circles: infinite long thin wire
% %        blue: short, thin wire
% lwire = 0.1;
% wind  = 100;
% curr  = 1;
% zlim = lwire/2;
% S1 = [0,0,-zlim];
% S2 = [0,0,+zlim];
% for i = 1:100
%   x(i)  =  i*0.001;
%   R = [x(i),0,0];
%   B = fct_bfield_wire_short(S1, S2, curr, wind, R);
%   Bx(i) = B(1);
%   By(i) = B(2);
%   Bz(i) = B(3);
% end
% % 
% B_inf_wire = 4*pi*1e-7*curr*wind./(2*pi*x);
% 
% figeps(12,12,1); clf;
% axes('position', [0.2 0.55 0.7 0.35]);
% hold on
%   plot(x,1e3*By, 'b');
%   plot(x,1e3*B_inf_wire, 'ro');
% hold off
% set(gca, 'ylim', [0 3])
% ylabel('B (mT)')
% title('Deviation to infinite wire')
% 
% % With shorter wires the deviations compared to infinite long wires 
% % increases.
% axes('position', [0.2 0.13 0.7 0.35]);
% plot(x, (By-B_inf_wire)./By*100);
% xlabel('r (m)'); ylabel('(B-B_\infty)/B (%)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==========================================================================

s1x = S1(1); s1y = S1(2); s1z = S1(3);
s2x = S2(1); s2y = S2(2); s2z = S2(3);
rx  = R(1);  ry  = R(2);  rz  = R(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The wire in the coordinate system K is transfered to the coordinate
% System K', where the start point of the wire is in the origin of K' and
% the end point lies on the z'-axis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a: length of the wire
  a = sqrt((s2x-s1x)^2 + (s2y-s1y)^2 + (s2z-s1z)^2);
% zz: z-distance of P from origin
  zz = ((rx-s1x)*(s2x-s1x) + (ry-s1y)*(s2y-s1y) + (rz-s1z)*(s2z-s1z))/a;
% xx: x-distance of P from origin
  xx = sqrt(((rx-s1x-(s2x-s1x)*zz/a))^2 + ...
    ((ry-s1y-(s2y-s1y)*zz/a))^2 + ((rz-s1z-(s2z-s1z)*zz/a))^2);
% Byy: B-field strength in the transformed coordinate system K'
  Byy = 1e-7*windings*current/xx*((a-zz)/(sqrt((xx)^2+((a-zz))^2))+...
    (zz/(sqrt((xx)^2+(zz)^2))));
% calculation of the components in the original coordinate system K
  Bx = Byy/(a*xx)*(-s1z*s2y + rz*(-s1y+s2y) + ry*(s1z-s2z) + s1y*s2z);
  By = Byy/(a*xx)*(rz*s1x - rx*s1z - rz*s2x + s1z*s2x + rx*s2z - s1x*s2z);
  Bz = Byy/(a*xx)*(-s1y*s2x + ry*(-s1x+s2x) + rx*(s1y-s2y) + s1x*s2y);

if nargout == 0
else
  Bvec = [Bx By Bz];
end