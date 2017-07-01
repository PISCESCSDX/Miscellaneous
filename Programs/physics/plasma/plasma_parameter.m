function [par] = plasma_parameter(T_e, T_i, B0, n_e, p_g, el, T_g, show)
%==========================================================================
%function [par] = plasma_parameter(T_e, T_i, B0, n_e, p_g, el, T_g, show)
%--------------------------------------------------------------------------
% PLASMA_PARAMETER uses the library 'natconst' and calculates important
% the plasma parmeters.
%--------------------------------------------------------------------------
% 1: T_e : electron temperature [eV]                         T_e = 3.0
% 2: T_i : ion temperature [eV]                              T_i = 0.2
% 3: B0  : magnetic field [T]                                B0  = 0.07
% 4: n_e : density [m^-3]                                    n_e  = 1e17
% 5: p_g : neutral gas pressure [Pa]                         p_g = 0.2
% 6: el  : element, e.g. 'H', 'D', 'He', 'Ne', 'Ar', 'Xe'    el  = 'Ar'
% 7: T_g : gas temperature [K]                               T_g = 300
%--------------------------------------------------------------------------
% EX: VINETA: [par] = plasma_parameter( 3, 0.2, 0.1, 5e18, 0.2, 'Ar');
% EX: PISCESA:[par] = plasma_parameter(10, 0.2, 0.1, 1e18, 0.04, 'He');
% EX: GLOW:[par] = plasma_parameter(2, 0.2, 25e-6, 5e15, 89, 'Ne');%B_earth
% EX: CSDX: [par] = plasma_parameter( 4, 0.2, 0.1, 5e18, 0.4, 'Ar');
%==========================================================================
if nargin<8
  show = 0;
end

if nargin<7
  T_g = 293.15;
end

if nargin<6, error('input argument missing!'); end

% LOAD natural constants
natconst;

% Check existence of element mass
q = exist(['m_' el], 'var');
  % If mass is not assigned assign it manually
if q==0
  inp = input(['Enter the mass number of ' el ...
    ' in u_0 (e.g. He m=4.002): '],'s');
  eval(['m_' el '=' inp]);
end
% Assign ion mass
eval(['m_i=m_' el ';']);  

% Check existence of element radius
q = exist(['R_' el], 'var');
  % If Radius is not assigned assign it manually
if q==0
  inp = input(['Enter the radius of ' el ' in [m]: '], 's');
  eval(['m_' el '=' inp]);
end
% Assign atom radius
eval(['R_atom=R_' el ';']);

% Neutral gas density (assume ideal gas: p_g=n_g k_B T_g)
n_g = p_g ./ (k_B .* T_g);
  

disp('   ');
%==========================================================================
% SOME BASIC PLASMA PARAMETERS
%==========================================================================
if show
disp('==================================================================');
disp('-------------------------------------------Basic Plasma Parameters');
end

% PLASMA BETA (checked -> ok)
beta = (n_e*T_e*e0)/(B0^2/(2*mu0));
if show
disp(['plasma beta                     : ' num2str(beta,3)]);
end

% MASS RATIO (checked -> ok)
mass_ratio = m_e/m_i;
if show
disp(['mass ratio                      : ' num2str(mass_ratio,3)]);
end

% BETA TO MASS RATIO (checked ->ok)
if show
disp(['beta to mass ratio              : ' num2str(beta/mass_ratio,3)]);
end


%==========================================================================
% COLLISIONS
%==========================================================================
% Neutral gas temperature [K] (20 C)
if show
disp('---------------------------------------------Collision Frequencies');
end

[f_ee,f_ei,f_ii,f_ne,f_ni,f_ne_inel,f_cx] = ...
  coll_freq(m_i/u0,n_e,T_e,T_i,T_g,p_g);
if show
disp(['e-e collision frequency         : ' num2str(f_ee,3) ' 1/s']);
disp(['e-i collision frequency         : ' num2str(f_ei,3) ' 1/s']);
disp(['i-i collision frequency         : ' num2str(f_ii,3) ' 1/s']);
disp(['n-e collision frequency (elast) : ' num2str(f_ne,3) ' 1/s']);
disp(['n-i collision frequency         : ' num2str(f_ni,3) ' 1/s']);
disp(['charge exchange frequency       : ' num2str(f_cx,3) ' 1/s']);
end
%==========================================================================
% VELOCITIES
%==========================================================================
if show
disp('--------------------------------------------------------Velocities');
end

% ELECTRON THERMAL VELOCITY (checked -> ok)
% (the most probable Maxwell velocity)
v_the = sqrt((2*e0*T_e)/m_e);
% ION THERMAL VELOCITY (checked -> ok)
% (the most probable Maxwell velocity)
v_thi = sqrt((2*e0*T_i)/m_i);
% ION SOUND SPEED (checked -> ok)
c_s = sqrt(T_e*e0/m_i);
% Alfven SPEED
v_A = B0/sqrt(mu0*m_i*n_e);

if show
disp(['electron thermal velocity       : ' num2str(v_the,3) ' m/s']);
disp(['ion thermal velocity            : ' num2str(v_thi,3) ' m/s']);
disp(['ion sound speed                 : ' num2str(c_s,3) ' m/s']);
disp(['Alfven speed                    : ' num2str(v_A,3) ' m/s']);
end

%==========================================================================
% LENGTHS
%==========================================================================
if show
disp('-----------------------------------------------------------Lengths');
end

% Temperature Ratio: electron temperature / ion temperature
alpha = T_e/T_i;
lambda_D2 = sqrt( eps0 .* e0*T_e./(n_e.*(e0^2) .*(alpha+1)) ); % (Anders1990)

% DEBYE LENGTH (checked -> ok)
lambda_D = sqrt( eps0*T_e*e0/(n_e*e0^2) );

% DRIFT SCALE (checked -> ok)
rho_s = sqrt( T_e*e0*m_i/(e0^2*B0^2) );

% COLLISIONLESS SKIN DEPTH (checked -> ok)
cl_skin = c0/sqrt((n_e*e0^2)/(eps0*m_e));

if show
disp(['Plasma Debye length (Ti<>Te)    : ' num2str(lambda_D2*1e3,3) ' mm']);
disp(['Electron Debye length (Ti>>Te)  : ' num2str(lambda_D*1e3,3) ' mm']);
disp(['rho_s                           : ' num2str(rho_s,3) ' m']);
disp(['collisonless skin depth         : ' num2str(cl_skin,3) ' m']);
end

%==========================================================================
% DIFFERENT MEAN FREE PATH LENGTHS
%==========================================================================
if show
disp('--------------------------------------------Mean Free Path Lengths');
end

% Mean Free Path, electrons (hard ball)
  % electron-neutral cross-section (hard ball interaction)
  sigma_e = pi*(R_Ne^2);
lambda_mfpehb = 1./(n_g * sigma_e);
if show
disp(['mean free path, e (hard ball)   : ' ...
  num2str(1e3*lambda_mfpehb,3) ' mm']);
end

% Mean Free Path, ions (hard ball)
  % electron-neutral cross-section (hard ball interaction)
  sigma_i = pi*((R_Ne+R_Ne)^2);
lambda_mfpihb = 1./(n_g * sigma_i);
if show
disp(['mean free path, i (hard ball)   : ' ...
  num2str(1e3*lambda_mfpihb,3) ' mm']);
end

% Mean Free Path, electrons (collisional cross section)
lambda_mfpe = v_the ./ f_ne;
if show
disp(['mean free path, e (T_e)         : ' ...
  num2str(1e3*lambda_mfpe,3) ' mm']);
end

% Mean Free Path, ions (collisional cross section)
lambda_mfpi = v_thi ./ f_ni;
if show
disp(['mean free path, i (T_i)         : ' ...
  num2str(1e3*lambda_mfpi,3) ' mm']);
end

% Coulomb-logarithm (precise: Callen, Stroth)
% Temperature Ratio: electron temperature / ion temperature
  % Charge of the ions:
  Zi = 1;
  bclmin   = Zi*(e0^2)./(4*pi*eps0*3*(e0*T_e) ); % Callen (Script)
c_log = log( sqrt( ((lambda_D2/bclmin).^2) -1 ) );

% Path between e-e-Coulomb collisions (Stroth S.217)
lambda_fpee = 9*((e0*T_e)^2)/( (((e0^2)/(4*pi*eps0))^2) *8*pi*n_e*c_log);
if show
disp(['path e-e-coll. (Ti=Te, Maxwell) : ' num2str(lambda_fpee,3) ' m'])
end

% Path between i-i-Coulomb collisions (Stroth S.217)
lambda_fpi = 9*((e0*T_i)^2)/( (((e0^2)/(4*pi*eps0))^2) *8*pi*n_e*c_log);
if show
disp(['path i-i-coll. (Ti=Te, Maxwell) : ' num2str(10^3*lambda_fpi,3) ' mm'])
end


%==========================================================================
% GYRORADII (Attention: Te and Ti in eV used)
%==========================================================================
if show
disp('--------------------------------------------------------Gyro Radii');
end

% ELECTRON GYRORADIUS (checked -> ok)
% (most probable Maxwell-velocity)
r_ce =sqrt((2*e0*T_e)/m_e)/(e0*B0/m_e);
if show
disp(['electron gyroradius             : ' num2str(r_ce*1000,3) ' mm']);
end

% ION GYRORADIUS (checked -> ok)
% (most probable Maxwell-velocity)
r_ci = sqrt((2*e0*T_i)/m_i)/(e0*B0/m_i);
if show
disp(['ion gyroradius                  : ' num2str(r_ci*1000,3) ' mm']);
end


%==========================================================================
% FREQUENCIES
%==========================================================================
if show
disp('-------------------------------------------------------Frequencies');
end

% ELECTRON CYCLOTRON FREQUENCY (checked -> ok)
Oce = e0*B0/m_e;
if show
disp(['electron cyclotron frequency    : ' num2str(Oce,3) ' rad/s  ==> ' ...
  num2str((Oce/(2*pi))/1e09,3) ' GHz']);
end

% ION CYCLOTRON FREQUENCY (checked -> ok)
Oci = e0*B0/m_i;
if show
disp(['ion cyclotron frequency         : ' num2str(Oci,3) ' rad/s  ==> ' ...
  num2str((Oci/(2*pi))/1e03,3) ' kHz']);
end

% ELECTRON PLASMA FREQUENCY (checked -> ok)
Ope = sqrt((n_e*e0^2)/(eps0*m_e));
if show
disp(['electron plasma frequency       : ' num2str(Ope,3) ' rad/s  ==> ' ...
  num2str((Ope/(2*pi))/1e09,3) ' GHz']);
end

% ION PLASMA FREQUENCY
Opi = sqrt((n_e*e0^2)/(eps0*m_i));
if show
disp(['ion plasma frequency            : ' num2str(Opi,3) ' rad/s  ==> ' ...
  num2str((Opi/(2*pi))/1e06,3) ' MHz']);
end


%==========================================================================
% PROBE THEORYs
%==========================================================================
if show
disp('----------------------------------------------------Probe Theories');
end

% Sheath Thickness (at -50V probe potential) Stroth: Einf. i. d. Plasmaph.
U=50; lambda_s = 1.02*(U/T_e)^(3/4)*lambda_D;
if show
disp(['sheath thickness at -50V        : ' num2str(1e3*lambda_s,3) ' mm'])
disp('----------------------------------------');
disp('LANGMUIR probe theory (B=0; R << lambda_fp,e)');
disp('---------------------------------------');
disp('DEMIDOV probe theory (B>0; R >> r_L,e Larmor radius)');
disp('Kinetic probe theory: d < lambda_er; assume: R=0.5mm, L=2mm');
end
% Demidov1999 (p351): (A) The kinetic probe theory:
  % R: probe radius;  L: probe length
  R = 0.0005;         L = 0.002;
  % d (probe disturbed region) < electron energy relaxation length, l_er
  d = R*log(L/R);
  % Diffusion coefficient of electrons, D_e
    % electron collision free path length, lambda_e (*** f_ee ???)
    lambda_e = v_the/f_ne;    %=XXX
  D_e = 1/3*lambda_e*v_the; 
  % a coefficient for including perpendicular magnetic field influence
  eta = (1+Oce^2/(f_ee+f_ne)^2)^(0.5);
  f_ex = f_ne_inel;   % 0 since not known: frequency of excitation of neutrals 
% *** l_er = 2*sqrt(D_e/(f_ee + 2*f_ne*m_e/m_i + f_ex));
if show
disp(['probe disturbed region, d       : ' num2str(1e3*d,3)        ' mm']);
%*** disp(['energy relaxation length, par   : ' num2str(1e3*l_er,3)     ' mm']);
%*** disp(['energy relaxation length, perp  : ' num2str(1e3*l_er/eta,3) ' mm']);
disp('---------------------------------------');
end




%==========================================================================
% Assign Output variables
%==========================================================================
par.m_i = m_i;         % ion mass [kg]
par.beta = beta;       % plasma beta [arb.u.]
% distances
par.lambda_D=lambda_D; % Debye-length [m]
par.rho_s= rho_s;      % drift-scale [m]
par.cl_skin = cl_skin; % collisional skin depth [m]
% gyro radii
par.r_ce = r_ce;       % electron gyro radius [m]
par.r_ci = r_ci;       % ion gyro radius [m]
% gyro frequencies
par.Oce = Oce;         % electron cyclotron frequency [s^-1]
par.Oci = Oci;         % ion cyclotron frequency [s^-1]
par.Ope = Ope;         % electron plasma frequency [s^-1]
par.Opi = Opi;         % ion plasma frequency [s^-1]
% velocities
par.v_the= v_the;      % thermal velocity of electrons [m/s]
par.v_thi= v_thi;      % thermal velocity of ions [m/s]
par.c_s = c_s;         % ion sound speed [m/s]
par.v_A = v_A;         % Alfv�n velocity [m/s]
par.T_g = T_g;         % gas temperature [K]
% collision frequencies
par.f_ee = f_ee;       % collision frequency electron-electron [s^-1]
par.f_ei = f_ei;       % collision frequency electron-ion [s^-1]
par.f_ii = f_ii;       % collision frequency ion-ion [s^-1]
par.f_ne = f_ne;       % collision frequency neutral-electron [s^-1]
par.f_ni = f_ni;       % collision frequency neutral-ion [s^-1]

end