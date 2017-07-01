% Fundamental physical constants in SI-units taken from:
% P. Mohr et al., Rev. Mod. Phys., 77(1):1-107, 2005.
% 30. January 2012 C. Brandt, UCSD, San Diego

% Gravitational Constants
g   = 9.80665;          % acceleration of gravity [m/s^2]
% Electromagnetic Constants
c0  = 299792458;        % speed of light in vacuum [m/s]
mu0	= 4.*pi.*1e-7;		  % vacuum permeability [V*s/A*m]
eps0	= 1/(mu0*c0^2);   % vacuum permittivity [A*s/V*m]
e0	= 1.6021765314e-19;	% electron charge [C = A*s]
% Gas Constants
N_A	= 6.022141510e23;   % Avogado number [1/mol]
R	  = 8.31447215;       % gas constant [J/(K*mol)]
k_B	= R/N_A;            % Boltzmann constant [J/K]
% Quantum constants
h_Pl= 6.6260755e-34;    % Planck constant (J*s)
% Atomic Constants
u0  = 1.6605388628e-27;	% atomic mass unit [kg]
m_e	= 9.10938261697e-31;% electron mass [kg]
m_p	= 1.6726217129e-27;	% proton mass [kg]
% Atomic Masses
m_H  =  1.00794   .*u0;	% hydrogen mass [kg]
m_D  =  2.01410187.*u0;	% hydrogen mass [kg]
m_T  =  3.0160492 .*u0;	% hydrogen mass [kg]
m_He =  4.002602  .*u0;	% helium mass [kg]
m_Ne = 20.1797    .*u0;	% neon mass [kg]
m_Ar = 39.9481    .*u0;	% argon mass [kg]
m_Xe = 131.293    .*u0;	% xenon mass [kg]
% Atomic Radii
R_He =  28e-12;         % neon covalent atomic radius [m] (wikipedia)
R_Ne =  58e-12;         % neon covalent atomic radius [m] (wikipedia)
R_Ar = 106e-12;         % argon covalent atomic radius [m] (wikipedia)