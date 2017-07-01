function [cyto] = CYTO_calcpara(T_e,T_i,B0,n0,p_g,el,dn,dx,L,R,jd)
%==========================================================================
%function [cyto] = CYTO_calcpara(T_e,T_i,B0,n0,p_g,el,dn,dx,L,R,jd)
%--------------------------------------------------------------------------
% CYTO_CALCPARA calculates the normalized parameter like they are used
% in the self-consistent 3D drift-wave code CYTO.
%--------------------------------------------------------------------------
%INPUT
% 1: T_e [eV]
% 2: T_i [eV]
% 3: B0  [T]
% 4: n0  [m^-3]
% 5: p_g [Pa]
% 6: el  element (e.g. 'Ar', 'He', 'Xe')
% 7: dn  delta n in gradient region [m^-3]
% 8: dx  delta x in gradient region [m]
% 9: L   axial length of the device [m]
%10: R   radius of the device [m]
%11: jd  discharge current density [A/m^2]
%OUTPUT
% par.
%--------------------------------------------------------------------------
% EX: [cyto] = CYTO_calcpara(3, 0.2, 0.07, 5e15, 0.02, 'Ar', 5e15,...
%              0.013, 1.4, 0.075, 7350)
%==========================================================================

if nargin<7; error('Need more input parameters!'); end
vin = vineta_parameter(T_e, T_i, B0, n0, p_g, el);

% calculate the density gradient length L = n / grad(n)
cyto.L_grad = n0 / (dn/dx);
cyto.L_gradperp = 1/cyto.L_grad;
cyto.rho_s = vin.rho_s;

% gradient length / rho_s
cyto.p.L_grad = cyto.L_grad / vin.rho_s;

% length of the device [m]
cyto.p.L = L;

% radius of the device [m]
cyto.p.R = R;

% discharge current density [A/m^2]
cyto.p.jd = jd;


% electron-electron collisions
cyto.p.f_ee = vin.f_ee / vin.Oci;

% ion-ion collisions
cyto.p.f_ii = vin.f_ii / vin.Oci;

% electron-ion collisions
cyto.p.f_ei = vin.f_ei / vin.Oci;

% ion-neutral collisions
cyto.p.f_ni = vin.f_ni / vin.Oci;

% electron-neutral collisions
cyto.p.f_ne = vin.f_ne / vin.Oci;


end