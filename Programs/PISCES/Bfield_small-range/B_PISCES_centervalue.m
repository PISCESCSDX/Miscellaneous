%==========================================================================
% This m-file loads 'Bxz_PISCES_fine_Sour1A_Main1A_Trim1A_N128.mat'
% to calculate the Bz-field on the axis for the dependence on the main and
% trim coil current.
%
% Mar 19 2012, C. Brandt, San Diego
%==========================================================================

 
%=====================================================================
% Load calculated data
load Bxz_PISCES_fine_Sour1A_Main1A_Trim1A_N128.mat
%=====================================================================


%=====================================================
% Plot Bfield
%-----------------------------------------------------
fonts = 12;

x0 = squeeze(BSour.Bx);
x1 = squeeze(BMain.Bx);
x2 = squeeze(BTrim.Bx);

z0 = squeeze(BSour.Bz);
z1 = squeeze(BMain.Bz);
z2 = squeeze(BTrim.Bz);

[m,n]=size(z1);

% # INPUT: Current through Source, Main and Trim Coils (A)
CuS = 100;
CuM = 250;
CuT = +30;

zmat = squeeze(P.z);
 ice = round(size(zmat,1)/2);
zvec = zmat(ice, :) /1e3;

xmat = squeeze(P.x);
rvec = xmat(:, 1)' /1e3;

% Extract Bz data of z-axis
BzvecS = z0(ice, :);
BzvecM = z1(ice, :);
BzvecT = z2(ice, :);

% The components BzvecS, BzvecT and BzvecM
% are already the values T/A along zvec on the axis.
% Just chose a certain z-position: 1.00 m is a good value it represents the
% average in the maximum field region.

disp(' ')
disp('- Calculation of the magnetic field component Bz')
disp('- in PISCES-A at a given z-position (seen from the LaB6 disc)')

zpos = input('   z-position (in m) from the source (LaB6 disc)? >>');
if isempty(zpos)
  zpos = 1;
end
izpos = findind(zvec, zpos);

disp(' ')
disp(['   -> The magnetic field is calculated at z=' ...
  sprintf('%.2f', zpos) ' m.'])
disp( '   -> Contributions of the magnetic field coils:')
disp(['      Source Field: ' sprintf('%.3e', 1e3*BzvecS(izpos)) ' mT/A'])
disp(['      Trim Field:   ' sprintf('%.3e', 1e3*BzvecT(izpos)) ' mT/A'])
disp(['      Main Field:   ' sprintf('%.3e', 1e3*BzvecM(izpos)) ' mT/A'])
%=====================================================