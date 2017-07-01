function bfield_wire = varnargout(s1x, s1y, s1z, s2x, s2y, s2z, current, windings, rx, ry, rz)
%prooved 20081018 C. Brandt
%function bfield_wire = varnargout(s1x, s1y, s1z, s2x, s2y, s2z, current,
%windings, rx, ry, rz)
%
% Calculates the B-field-components Bx, By, Bz in a point P(rx, ry, rz). 
% The B-field is created by an infinite thin even short wire where 
% PC1(s1x, s1y, s1z) and PC2(s2x, s2y, s2z) are the start and end points of
% the wire. The current direction points from PC1 to PC2.
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
%
% IN: s1x, s1y, s1z   start point of wire [m]
%     s2x, s2y, s2z   end point of wire [m]
%     current         current through one winding [A]
%     windings        number of coil windings
%     rx, ry, rz      coordinates of the point where the Bfield
%                     should be calculated [m]
%OUT: [B] = [Bx, By, Bz] [Tesla]
%
% EX: B = bfield_wire(0,-100,0,  0,100,0,  1,100,  0.02,0,0) delivers:
%     B = [0 0 -1e-3]; This is in absolute agreement with the 
%     calculated Bt = -4*pi*1e-7*1*100./(2*pi.*0.02) for the
%     even infinite long wire B_wire = mu0*I/(2*pi*r)
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Short Script to test the m-file
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Das Verhältnis Abstand/Drahtlänge zeigt in etwa an, ab wann die
% % Abweichung zu groß wird. Zur Berechnung des Oktupol-Feldes muss B für 
% % eine Drahtlänge von 4cm und ein Abstand von ca. 10cm berechnet werden.
% % Daher die Standard-Werte ldraht = 0.04, und x(end)=0.1;
% % Ändere die Drahtlänge um mit dem unendlich langen Leiter zu vergleichen.
% %
% % Rote Kreise: Berechnung Unendlich langer Draht
% % Blau: Berechnung für beliebig kurzes, unendlich dünnes Leiterstück.
% % Für große Längen werden beide Rechnungen gleich.
% ldraht= 10.04;
% 
% wind  = 100;
% curr  = 1;
% 
% zlim = ldraht/2;
% for i = 1:100
%   x(i)  =  i*0.001;
%   B = bfield_wire(0,0,-zlim,  0,0,zlim,  curr,wind,  x(i),0,0);
%   Bx(i) = B(1);
%   By(i) = B(2);
%   Bz(i) = B(3);
% end
% 
% Bt = 4*pi*1e-7*curr*wind./(2*pi*x);
% 
% figeps(10,8,1);
% hold on
%   plot(x,1e3*By, 'b');
%   plot(x,1e3*Bt, 'ro');
% hold off
% mkplotnice('r [m]', 'B [mT]', 12);
% 
% % Bei kürzer werdenden Drähten, nimmt die Abweichung zum ideal unendlich 
% % langen Leiter mit größeren Abständen zu.
% figeps(10,8,2);
% plot(x, (By-Bt)./By*100);
% mkplotnice('r [m]', 'Abweichung zum langen Draht [%]', 12);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
  xx = sqrt(((rx-s1x-(s2x-s1x)*zz/a))^2 + ((ry-s1y-(s2y-s1y)*zz/a))^2 + ((rz-s1z-(s2z-s1z)*zz/a))^2);
% Byy: B-field strength in the transformed coordinate system K'
  Byy = 1e-7*windings*current/xx*((a-zz)/(sqrt((xx)^2+((a-zz))^2))+(zz/(sqrt((xx)^2+(zz)^2))));
% calculation of the components in the original coordinate system K
  Bx = Byy/(a*xx)*(-s1z*s2y + rz*(-s1y+s2y) + ry*(s1z-s2z) + s1y*s2z);
  By = Byy/(a*xx)*(rz*s1x - rx*s1z - rz*s2x + s1z*s2x + rx*s2z - s1x*s2z);
  Bz = Byy/(a*xx)*(-s1y*s2x + ry*(-s1x+s2x) + rx*(s1y-s2y) + s1x*s2y);

if nargout == 0
else
    bfield_wire = [Bx By Bz];
end;    