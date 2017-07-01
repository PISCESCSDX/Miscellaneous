function rho_s = rho_s(B, T_e, M_i)
%==========================================================================
%function rho_s = rho_s(B, T_e, M_i)
%--------------------------------------------------------------------------
% IN: B: magnetic field strength (T)
%   T_e: electron temperature (eV)
%   M_i: ion mass (in u0)!
%OUT: rho_s: drift scale - ion gyro radius at electron temperature [m]
%--------------------------------------------------------------------------
% EXAMPLE:  r = rho_s(0.099, 3, 40);         % for Argon
%           ==> r=1.13e-2
%==========================================================================

natconst;
M_i = M_i * u0;

% % formula for drift scale
% rho_s = sqrt(k_B*T_e*M_i/(e0^2*B^2));

% formula for drift scale (checked -> OK)
rho_s = sqrt( T_e*M_i/(e0*B^2) );

end