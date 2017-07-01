%==========================================================================
% This m-file calculates the magnetic field lines of any given field
% structure.
%
% Mar 20 2012, C. Brandt, San Diego
%==========================================================================

% # INPUT: parameters (length in mm)
  rmax =  400;   % Cylindrical geometry with maximum radius rmax
  dd   =    5;   % Step size between points
% # INPUT: Boundaries
  xmin = -rmax; xmax = rmax;
  ymin =     0; ymax =    0;   % Define a x-z plane at y=0
  zmin =  -200; zmax = 1700;
% Delta for each direction
  dx = dd; dy = dd; dz = dd;   % Equal distances along x, y and z
% Coordinate grid
  x = xmin:dx:xmax;
  y = ymin:dy:ymax;
  z = zmin:dz:zmax;

[P.x,P.y,P.z] = meshgrid(x,y,z);

% # INPUT: Number of wire elements
  N = 128;

% Source coil parameters (taken from L. Chousals CAD file pas-1000_asm.stp)
  % # INPUT: Coil z-positions (mm)
  cs.z1 =    0.0;
  cs.z2 =   63.5;
  cs.zpos =     [cs.z1 cs.z2];
  % # INPUT: Coil currents
  cs.curr = 1  *[    1     1];
  
  cm.z1 =  667.0;
  cm.z2 =  914.5;
  cm.z3 = 1159.0;
  cm.z4 = 1410.0;
  cm.zpos =     [cm.z1 cm.z2 cm.z3 cm.z4];
  % # INPUT: Coil currents
  cm.curr = 1  *[    1     1     1     1];

% Trim coil parameters (measured in the Lab (Brandt, Mar 5 2012))
  % Axial width of coil (mm)
  dz = 34;
  % # INPUT: z-position trim coils relative to end of the 2nd main coil
     % (measured Mar 5 2012, Brandt)
    zposrel = [106 205];
  % z-positions of coils (mm), calculated with reference to the LaB6-source
  % + half of 1st main coil + diameter of 2nd main coil + half of trim coil
  ct.zpos = 62/2 + 63 + dz/2 + zposrel;
  % # INPUT: Coil currents
  ct.curr = 1 *[ 1  1];

  
%=====================================================================
% Calculate or Load the magnetic fields of Source, Main and Trim Coils
%---------------------------------------------------------------------
% % (A) Calculate data
% [BSour, BMain, BTrim] = fct_bfield_PISCES(P, cs, cm, ct, N);
%---------------------------------------------------------------------
% (B) Load calculated data
load Bfield_PiscesA_Sour1A_Main1A_Trim1A_N128.mat
%=====================================================================


%===============================================================
% Calculate wire matrices
%---------------------------------------------------------------
% 2.1: Calculate wire structure of: Main Coils (cm)
ws = fct_PISCES_CoilMainElements(cs.zpos, cs.curr, N);
% 2.2: Calculate wire structure of: Main Coils (cm)
wm = fct_PISCES_CoilMainElements(cm.zpos, cm.curr, N);
% 2.3: Calculate wire structure of: Trim Coils (ct)
wt = fct_PISCES_CoilTrimElements(ct.zpos, ct.curr, N);
%===============================================================


%=====================================================
% Plot Bfield
%-----------------------------------------------------
fonts = 12;

x0 = squeeze(BSour.Bx);
x1 = squeeze(BMain.Bx);
x2 = squeeze(BTrim.Bx);

y0 = squeeze(BSour.By);
y1 = squeeze(BMain.By);
y2 = squeeze(BTrim.By);

z0 = squeeze(BSour.Bz);
z1 = squeeze(BMain.Bz);
z2 = squeeze(BTrim.Bz);

[m,n]=size(z1);

zmat = squeeze(P.z);
 ice = round(size(zmat,1)/2);
zvec = zmat(ice, :) /1e3;

xmat = squeeze(P.x);
rvec = xmat(:, 1)' /1e3;

% # INPUT: Current through Source, Main and Trim Coils (A)
CuS = 100;
CuT =   0;
CuM = 250;

% Initialization of coil positions
xc0 = zeros(m,n); xc1 = zeros(m,n); xc2 = zeros(m,n);
zc0 = zeros(m,n); zc1 = zeros(m,n); zc2 = zeros(m,n);

%--------------------------------------------------------------------------
% Calculate coil positions (NaN where coils are)
helpx = xmat(:, 1)';    helpz = zmat(1, :)';
for k= 1:length(ws.rminmax)
  indxle = find(helpx <= -ws.rminmax{k}(1) & helpx>= -ws.rminmax{k}(2) );
  indxri = find(helpx >= +ws.rminmax{k}(1) & helpx<= +ws.rminmax{k}(2) );
  indz   = find(helpz >=  ws.zminmax{k}(1) & helpz <= ws.zminmax{k}(2) );
  xc0([indxle indxri], indz) = NaN;
  zc0([indxle indxri], indz) = NaN;
end

for k= 1:length(wm.rminmax)
  indxle = find(helpx <= -wm.rminmax{k}(1) & helpx>= -wm.rminmax{k}(2) );
  indxri = find(helpx >= +wm.rminmax{k}(1) & helpx<= +wm.rminmax{k}(2) );
  indz   = find(helpz >=  wm.zminmax{k}(1) & helpz <= wm.zminmax{k}(2) );
  xc1([indxle indxri], indz) = NaN;
  zc1([indxle indxri], indz) = NaN;
end

for k= 1:length(wt.rminmax)
  indxle = find(helpx <= -wt.rminmax{k}(1) & helpx>= -wt.rminmax{k}(2) );
  indxri = find(helpx >= +wt.rminmax{k}(1) & helpx<= +wt.rminmax{k}(2) );
  indz   = find(helpz >=  wt.zminmax{k}(1) & helpz <= wt.zminmax{k}(2) );
  xc2([indxle indxri], indz) = NaN;
  zc2([indxle indxri], indz) = NaN;
end
%--------------------------------------------------------------------------



% XXX 
% Bfield.Bx = 1e3*(CuS*x0 + CuM*x1 + CuT*x2 + xc0 + xc1 + xc2);
% Bfield.By = 1e3*(CuS*y0 + CuM*y1 + CuT*y2 + xc0 + xc1 + xc2);
% Bfield.Bz = 1e3*(CuS*z0 + CuM*z1 + CuT*z2 + zc0 + zc1 + zc2);

Bfield.Bx = 1e3*(CuS*x0 + CuM*x1 + CuT*x2);
Bfield.By = 1e3*(CuS*y0 + CuM*y1 + CuT*y2);
Bfield.Bz = 1e3*(CuS*z0 + CuM*z1 + CuT*z2);

dPhi = 10;
Blines = fct_bfield_lines_v1b(P, Bfield, dPhi);

return

figeps(2*11,2*5,1,0,100); clf;
axes('position', [0.15 0.20 0.70 0.65])
plotcontour(zvec*100, rvec*100, Bfield.Bz, 40, 'z (cm)', 'r (cm)', fonts);
% axis equal
colormap jet
set(gca, 'clim' ,[0 64])
cb = our_colorbar('B_z (mT)', 10, 12, 0.018, 0.017, 'EastOutside');
set(cb, 'ylim', [0 64])
puttextonplot(gca, [0 1], 5, -15, '(b)', 0, 12, 'w');




% % Print plot
% fn = ['B_lines.eps' ''];
% print('-depsc2', fn)

% % Print plot
% fn = ['Bxz_PISCES_Sour' num2str(CuS) '_Main' num2str(CuM) ...
%   '_Trim' num2str(CuT) '_N' num2str(N) '_Cont40.eps'];
% print('-depsc2', fn)
%=====================================================