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
By = B.By; % is zero
Bz = B.Bz;



Phi_x = cumtrapz(Bx,2); % size = 161 x 381
Phi_z = cumtrapz(Bz,1); % size = 161 x 381
Phi_sum  = Phi_z  + 0*Phi_x;

diff = Phi_sum(1,1) * ones(161,1)*ones(1,381);
Phi_sum2 = Phi_sum - diff;

diffz = Phi_z(81,:)'*ones(1,size(Phi_z,1)); %***
Phi_zd= (Phi_z - diffz');
Phi_sumd = Phi_zd + Phi_x;

% Calculate Vector field: Change Grid Size
res = 30;
[~,   ~, Bznew] = interp_matrix(yvec, zvec, Bz', res*[1 1]);
[xn, yn, Bxnew] = interp_matrix(yvec, zvec, Bx', res*[1 1]);
[X,Y] = meshgrid(xn, yn);
  
  
figeps(13,17,1,0,100)
x0 = 0.13; y0 = 0.06; dy = 0.31; xw = 0.85; yw = 0.255;
ax{1} = [x0 y0+2*dy xw yw];
ax{2} = [x0 y0+1*dy xw yw];
ax{3} = [x0 y0+0*dy xw yw];

xlim = [400 1000];
ylim = [0 300];

axes('position', ax{1})
%[C, hp] = contour(squeeze(zvec), squeeze(yvec), Phi_sum, 41);
[C, hp] = contourf(squeeze(zvec), squeeze(yvec), Phi_sum, 0:50:6000);
colorbar
%plotcontour(squeeze(zvec), squeeze(yvec), Phi_abs',40,'z (cm)','r (cm)', 12);
%set(hp, 'lineColor', 'k')
axis equal
hold on
  quiver(Y, X, Bznew, Bxnew)
hold off
% set(gca, 'xlim', xlim, 'ylim', ylim)
mkplotnice('-1', 'y (mm)', 12, '-30', '-30');
title('\phi_{sum}')

axes('position', ax{2})
%plotcontour(squeeze(zvec), squeeze(yvec), Phi_sum',40,'z (cm)','r (cm)', 12);
[C, hp] = contour(squeeze(zvec), squeeze(yvec), Phi_z, 41);
colorbar
%set(hp, 'lineColor', 'k')
axis equal
hold on
  quiver(Y, X, Bznew, Bxnew)
hold off
% set(gca, 'xlim', xlim, 'ylim', ylim)
mkplotnice('-1', 'y (mm)', 12, '-30', '-30');
title('\phi_{z}')

axes('position', ax{3})
[C, hp] = contour(squeeze(zvec), squeeze(yvec), Phi_sumd, 41);
colorbar
%plotcontour(squeeze(zvec), squeeze(yvec), Phi_y'+Phi_z',40,'z (cm)','r (cm)', 12);
%set(hp, 'lineColor', 'k')
axis equal
hold on
  quiver(Y, X, Bznew, Bxnew)
hold off
% set(gca, 'xlim', xlim, 'ylim', ylim)
mkplotnice('x (mm)', 'y (mm)', 12, '-30', '-30');
title('\phi_{sum,diff}')

% print('-depsc2', 'Bfield-lines_PhiY+PhiZ(top)_PhiAbs(bottom).eps')

% plotcontour(squeeze(zvec), squeeze(yvec), Phi_z',20,'z (cm)','r (cm)', 12);



return



Bxvec = Bz(:,1);
int1 = cumtrapz(xvec, Bxvec);

figure(1)
plot(xvec, Bxvec)

figure(2)
plot(xvec, int1)

Blines = [];
end