function [jex] = mexjcurr(p, currB, pow, currex, fex)
%function jex = mexjcurr(p, currB, pow, currex, fex)
% Calculates the induced current density of the magnetic exciter.
%
% IN: p: Vineta pressure [Pa]
%     currB: Vineta-Bfield current [A]
%     pow: Vineta plasma power [W]
%     currex: exciter current amplitude [A] (through one wire!) 
%     fex: exciter frequency [Hz]
%OUT: jex [mA/cm^2]
% EX: mexjcurr(0.213, 205, 3000, 3, 3000)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die 2 Ausgangspunkte sind:
% (A) B_xy_fluc Messung einer Driftwelle bei r=2.5cm, fdw=3260Hz
%     Die Amplituden der x- und y-Richtung werden gemittelt.
%     Eine würde auch reichen, aber da eine Mittelung möglich ist
%     wird dies getan. Bdwx3, Bdwy4  (20080218-23)
  Bdwx3 = 0.02924; % [T] ???
  Bdwy4 = 0.03464; % [T] ???
  jdw   = 100;     % [mA/cm^2] (aus Messung bei r=2.5cm)
%  
% (B) B_xy_fluc Messung des Exciters im ruhigen Plasma mit (20080218-21)
  p_0     = 0.3;  % [Pa]
  currB_0 = 140;  % [A]
  pow_0   = 2000; % [W]
  % Aex_0   = 0.2;% [V] nicht gebraucht, da currex_0 bekannt
  currex_0= 5.9;  % [A]
  fex_0   = 3000; % [Hz]
% Annamme das die Fluktuationsamplitude der Stromdichte direkt proportional
% zu den Magnetfeld-Fluktuationsamplituden sind.
% B_xy_fluc des Exciters
  Bexx3 = 0.009512; % [T] ???
  Bexy4 = 0.007919; % [T] ???
% Daraus ergibt sich jex_0
  jex_0 = jdw*( (Bexx3/Bdwx3 + Bexy4/Bdwy4)/2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nun ist jex_0 bei den oben genannten Plasma-Parametern und
% Exciter-Parametern bekannt.
% Unter der Annahme
% n ~ p currB^(-1) pow   und mit der Resonanzkurve des Exciters
% Iex(fex)
%
% jex berechnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jex = jex_0.*(p/p_0).*(currB_0./currB).*(pow./pow_0).*...
      (fex./fex_0).*(currex./currex_0);

end