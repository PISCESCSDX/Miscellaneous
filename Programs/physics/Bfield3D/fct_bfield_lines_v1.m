function Blines = fct_bfield_lines(P, B, dPhi)
%==========================================================================
%function Blines = fct_bfield_lines(P, B, dPhi)
% Last change: 26.03.2012, San Diego, C. Brandt
% 06.03.2012, San Diego, C. Brandt
%--------------------------------------------------------------------------
% FCT_BFIELD_LINES calculates the B-field-lines of a 2D magnetic field.
%
% Basic idea:
% The magnetic fueld
% The magnetic flux is defined as Phi = Int vec(B)*vec(dA).
% 
%In x-y-coordinat
%
%--------------------------------------------------------------------------
% IN: P.x : x-position matrix
%     P.y : y-position matrix
%     P.z : z-position matrix
%     B.Bx: Bx-field matrix
%     B.By: By-field matrix
%     B.Bz: Bz-field matrix
%  dPhi: difference of magnetic flux between two B-field lines (Tm^2=Vs=Wb)
%OUT: Blines
%--------------------------------------------------------------------------
% EXAMPLES: Blines = fct_bfield_lines(B, dPhi)
%==========================================================================


% % Maybe use the spline2d-function for plotting the Bfield lines.
% *** [xs, ys] = fct_spline2d(x, y, ds);

% -------------------------------------------------------------------------
% FINALLY Compare with the following code
% -------------------------------------------------------------------------
% yvec = P.x(1,:,1);
%   ly = length(yvec);
% zvec = P.z(1,1,:);
%   lz = length(zvec);
% 
% Bx = B.Bx;
% By = B.By;
% Bz = B.Bz;
% 
% 
% for jz = 1:lz
%   Phi_z(jz,:) = cumtrapz(yvec, Bz(:,jz));
%   Phi_z(jz,:) = Phi_z(jz,:) - Phi_z(jz,81);
% end
% 
% plotcontour(squeeze(zvec), squeeze(yvec), Phi_z',20,'z (cm)','r (cm)', 12);
% -------------------------------------------------------------------------

yvec = squeeze(P.x(1,:,1));
  ly = length(yvec);
zvec = squeeze(P.z(1,1,:));
  lz = length(zvec);

Bx = B.Bx;
By = B.By;
Bz = B.Bz;

for jz = 1:lz
  Phi_z(jz,:) = cumtrapz(yvec, Bz(:,jz));
  Phi_z(jz,:) = Phi_z(jz,:) - Phi_z(jz,81);
end
% plotcontour(squeeze(zvec), squeeze(yvec), Phi_z',20,'z (cm)','r (cm)', 12);

for jy = 1:ly
  Phi_y(:,jy) = cumtrapz(zvec, Bx(jy,:));
  %Phi_y(jy,:) = Phi_y(jy,:) - Phi_z(jy,81);
end



[xn, yn, Bznew] = interp_matrix(yvec, zvec, Bz', [50 50]);
[xn, yn, Bxnew] = interp_matrix(yvec, zvec, Bx', [50 50]);
[X,Y] = meshgrid(xn, yn);
  
  
figeps(12,12,1,0,100)
x0 = 0.13; y0 = 0.12; dy = 0.46; xw = 0.85; yw = 0.37;
ax{1} = [x0 y0+1*dy xw yw];
ax{2} = [x0 y0+0*dy xw yw];


axes('position', ax{1})
[C, hp] = contour(squeeze(zvec), squeeze(yvec), Phi_z', 31);
%set(hp, 'lineColor', 'k')
axis equal
hold on
  quiver(Y, X, Bznew, Bxnew)
hold off
mkplotnice('-1', 'y (mm)', 12, '0', '-30');


% plotcontour(squeeze(zvec), squeeze(yvec), Phi_z',20,'z (cm)','r (cm)', 12);
axes('position', ax{2})
[C, hp] = contour(squeeze(zvec), squeeze(yvec), Phi_y', 31);
%set(hp, 'lineColor', 'k')
axis equal
hold on
  quiver(Y, X, Bznew, Bxnew)
hold off
mkplotnice('z (mm)', 'y (mm)', 12, '-30', '-30');

print('-depsc2', 'Bfield-lines_Bz(top)_Bx(bottom).eps')



return



Bxvec = Bz(:,1);
int1 = cumtrapz(xvec, Bxvec);

figure(1)
plot(xvec, Bxvec)

figure(2)
plot(xvec, int1)

Blines = [];
end