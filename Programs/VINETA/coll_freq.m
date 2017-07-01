function [f_ee,f_ei,f_ii,f_ne,f_ni,f_cx] = ...
  coll_freq(m_i,n_e,t_e,t_i,t_g,p_g)
%==========================================================================
% Calculation of the collision frequencies for following collisions:
% 1: electron <-> electron
% 2: electron <-> ion
% 3: ion <-> ion
% 4: neutral <-> electron
% 5: neutral <-> ion
% 6: charge exchange (valid only for argon ground state)
%--------------------------------------------------------------------------
% [f_ee,f_ei,f_ii,f_ne,f_ni,f_cx] = coll_freq(m_i,n_e,t_e,t_i,t_g,p_g)
%--------------------------------------------------------------------------
% m_i   : ion mass in units of [u]
% n_e   : electron density in [m^{-3}]
% t_t   : electron tmperature in [eV]
% t_i   : ion temperature in [eV]
% t_g   : neutral gas temperature in [k]
% p_g   : neutral gas pressure in [Pa]
%
% f_ee  : electon-electron collision-frequency [1/s]
% f_ei  : electon-ion collision-frequency [1/s]
% f_ii  : ion-ion collision-frequency [1/s]
% f_ne  : electon-neutral collision-frequency [1/s]
% f_ni  : ion-neutral collision-frequency [1/s]
% f_cx  : charge exchange (only for ground states argon ions)
%--------------------------------------------------------------------------
% Last modification: 020923 by Albrecht Stark
%==========================================================================

% Initialisation: load constants + define paramters for 
% electron-neutral damping
natconst;
switch round(m_i)
case {4}				% helium
  m_i = m_He;
  if (t_e < 3.2)
    kq = 19.7; q = -0.044;
  elseif (3.2 < t_e) && (t_e < 13)
    kq = 25.6; q = -0.27;
  else
    kq = 46.2; q = -0.5;
  end;
case {40}
  m_i = m_Ar;				% argon
  if (t_e < 10)
    kq = 4.3; q = 1.28;
  elseif (10 < t_e) && (t_e < 13)
    kq = 82; q = 0;
  else
    kq = 638; q = -0.8;
  end;
case {131}
  m_i = m_Xe;				% xenon
  if (t_e < 4.5)
    kq = 11; q = 1.69;
  elseif (4.5 < t_e) && (t_e < 8.1)
    kq = 140; q = 0;
  elseif (8.1 < t_e) && (t_e < 15)
    kq = 316; q = -0.39;   
  else
    kq = 1013; q = -0.82; 
  end;
end;
  
% Coulomb-logarithm
c_log = log((1./(4.*pi.*eps0)).^(-3/2).*3/2 * (t_e .* e0).^(3/2) ./ ...
	(sqrt(pi.*n_e) .* e0^3));

% electon-ion collision-frequency
f_ei  = 4/3 / (4*pi * eps0)^2 * sqrt(2*pi) * e0^4 .* n_e .* c_log ./ ...
	(sqrt(m_e) .* (e0 .* t_e).^(3/2));

% electon-electon collision-frequency
f_ee  = 4/3 / (4*pi * eps0)^2 * sqrt(pi) * e0^4 .* n_e .* c_log ./ ...
	(sqrt(m_e) .* (e0 .* t_e).^(3/2));

% ion-ion collision-frequency
f_ii  = 4/3 / (4*pi * eps0)^2 * sqrt(pi) * e0^4 .* n_e .* c_log ./ ...
	(sqrt(m_i) .* (e0 .* t_i).^(3/2));

% electron-neutral collision-frequency
f_ne = 1.37E8 * p_g / t_g * kq .* t_e.^(q+0.5);

% ion-neutral collision-frequency
f_ni  = (p_g/(k_B * t_g)) .* 6E-19 .* sqrt(t_i.*e0./m_i);

% charge exchange frequency
f_cx = (p_g/(k_B * t_g)) .* 4.8e-19 * (1 + 0.14*log(1/t_i))^2 * ...
  sqrt(t_i.*e0./m_i);

end




