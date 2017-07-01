function [f_ee,f_ei,f_ii,f_ne,f_ni,f_ne_inela,f_cx] = ...
  coll_freq(M,n_e,T_e,T_i,T_g,p_g)
%==========================================================================
% Calculation of the collision frequencies for following collisions:
% 1: electron <-> electron
% 2: electron <-> ion
% 3: ion <-> ion
% 4: neutral <-> electron
% 5: neutral <-> ion
% 6: charge exchange (valid only for argon ground state)
%--------------------------------------------------------------------------
% [f_ee,f_ei,f_ii,f_ne,f_ni,f_cx] = coll_freq(M,n_e,T_e,T_i,T_g,p_g)
%--------------------------------------------------------------------------
% M     : ion mass in units of [u]
% n_e   : electron density in [m^{-3}]
% t_t   : electron tmperature in [eV]
% T_i   : ion temperature in [eV]
% T_g   : neutral gas temperature in [K]
% p_g   : neutral gas pressure in [Pa]
%
% f_ee  : electon-electron collision-frequency [1/s]
% f_ei  : electon-ion collision-frequency [1/s]
% f_ii  : ion-ion collision-frequency [1/s]
% f_ne  : electon-neutral collision-frequency [1/s]
% f_ni  : ion-neutral collision-frequency [1/s]
% f_ne_inela: e-n-excitation collision frequency [1/s]
% f_cx  : charge exchange (only for ground states argon ions)
%--------------------------------------------------------------------------
% Last modification: 05.07.2012 by Christian Brandt
% Last modification: 23.09.2002 by Albrecht Stark
%==========================================================================

% Load paramters for electron-neutral collisions
natconst;
switch round(M)
  % hydrogen *** added 30.01.2012 *** todo: enter values
  case {1}
    error('Parameters for e-n-sollision are not yet included!')
  m_i = m_H;
  
  % helium
  case {4}
  m_i = m_He;
  if (T_e < 3.2)
    kq = 19.7; q = -0.044;
  elseif (3.2 < T_e) && (T_e < 13)
    kq = 25.6; q = -0.27;
  else
    kq = 46.2; q = -0.5;
  end

  % neon
  case {20}
    m_i = m_Ne;
  
  % argon
  case {40}
  m_i = m_Ar;
  if (T_e < 10)
    kq = 4.3; q = 1.28;
  elseif (10 < T_e) && (T_e < 13)
    kq = 82; q = 0;
  else
    kq = 638; q = -0.8;
  end
  
  % xenon
  case {131}
  m_i = m_Xe;
  if (T_e < 4.5)
    kq = 11; q = 1.69;
  elseif (4.5 < T_e) && (T_e < 8.1)
    kq = 140; q = 0;
  elseif (8.1 < T_e) && (T_e < 15)
    kq = 316; q = -0.39;   
  else
    kq = 1013; q = -0.82; 
  end
end


% Coulomb-logarithm, checked: 02.07.2012
% [Source: scripts of Callen and Stroth]
% Temperature ratio: electron temperature / ion temperature
  alpha = T_e/T_i;
  % Plasma Debye length [Source: Anders1990]
  lambda_D = sqrt( eps0.*e0*T_e./(n_e.*(e0^2).*(alpha+1)));
  % Charge of the ions:
  Z_i = 1;
  % Ion density equals electron density
  n_i = n_e;
  % Neutral gas density (assume ideal gas: p_g=n_g k_B T_g)
  n_g = p_g ./ (k_B .* T_g);
  bclmin = Z_i*(e0^2)./(4*pi*eps0*3*(T_e*e0));    % [Script of Callen]
c_log = log( sqrt( ((lambda_D/bclmin).^2) -1 ) ); % [Callen/Stroth equal]
% Define constant (4*pi*eps0)
Keps = 4*pi*eps0;

% Coulomb collision: i-i collision-frequency (Maxwellian plasma)
% [Source: Callen S.73, A. Stark], checked: 02.07.2012
f_ii  = (4/3)*sqrt(pi) *n_i *(Z_i^4) *(e0^4) .*c_log ./ ...
  (Keps^2 *sqrt(m_i) .*((T_i*e0)^(3/2)) );

% Coulomb collision: e-i collision-frequency (Maxwellian plasma)
% [Source: Callen S.64, A. Stark]
f_ei  = (4/3)*sqrt(2*pi) .*n_i *(Z_i^2) *e0^4 .*c_log ./...
  (Keps^2 *sqrt(m_e) .*(T_e*e0)^(3/2));

% Coulomb collision: e-e collision-frequency (Maxwellian plasma)
% [Source: A. Stark, but not found in Callen]
f_ee  = (4/3)*sqrt(pi) *n_e *(e0^4) .*c_log ./ ...
  (Keps^2 *sqrt(m_e) .*((T_e*e0)^(3/2)) );
% [Source: Stroth S.217]
% f_eeStroth = sqrt(3*(T_e*e0)/m_e) *8*pi *n_e * e0^4 *c_log ./ ...
%   (Keps^2 *9*(T_e*e0)^2);

switch round(M)
% electron-neutral collision-frequency
  case {20} % Neon
    load('collisional-cross-sections_Ne.mat'); % Source: Hayashi1992
    % f_ne = v_e / lambda_e; lambda_e = 1/(n_g*sigma_ne)
    % info: chose <v> of Maxwell = sqrt(8*(T_e*e0)./(pi*m_e)), 
    %       because usually the rate coefficient is <v*sigma>
    sigma_ne = pchip(ccs.elast.TeV, ccs.elast.ccs, T_e);
    f_ne = n_g .* sqrt(8*(T_e*e0)./(pi*m_e)) .* sigma_ne;
    % Excitation frequency
    sigma_ne_inela = pchip(ccs.inela.TeV, ccs.inela.ccs, T_e);
    f_ne_inela = n_g .* sqrt(8*(T_e*e0)./(pi*m_e)) .* sigma_ne_inela;
  otherwise
    % [Source: Jansen Plasmaphysik (sagt Albrecht)]
    f_ne = 1.37e8 * p_g / T_g * kq .* T_e.^(q+0.5);
    % Excitation frequency
    f_ne_inela = [];
end


% ion-neutral collision-frequency
% [Source: unknown]
f_ni  = n_g .* 6e-19 .* sqrt(T_i.*e0./m_i);

% charge exchange frequency
% [Source: unknown]
f_cx = (p_g/(k_B * T_g)) .* 4.8e-19 * (1 + 0.14*log(1/T_i))^2 * ...
  sqrt(T_i.*e0./m_i);

end




