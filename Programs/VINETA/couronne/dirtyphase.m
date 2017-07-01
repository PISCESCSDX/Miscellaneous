function [B tt fitdata] = dirtyphase(A, tt, datamanuel)
%function [B tt fitdata] = dirtyphase(A, tt, datamanuel)
% Removes fastly and dirty the ugly phase shifts from couronne
% measurements at low pressures.


if nargin<3
  
% Berechne die Phase jeder Zeitreihe
% Zunächst: Finde den Index für die Haupt-Frequenz
% (muss so kompliziert sein, da es Sprünge! gibt)
  for i=1:64
    [freq ampl pha{i}] = su_fft(tt, A(:,i), 1);
    [inda indvec(i)] = max(ampl);
  end;

  % find the main frequency index via histogram
  [hi hiind] = hist(indvec, 1:max(indvec));
  [maxhi indhi] = max(hi);

  % test wether the most of all indexes are equal (say 80%)
  if maxhi/sum(hi)>=0.4
    indi = indhi;
  else
    error('Dirtyphase correction does not work: too less probe channels show the same main frequency!');
  end

  % DETECT ALL PHASE SHIFTS
  for i=1:64
    phi(i) = pha{i}(indi);
  end;
  % MAIN FREQUENCY
    fmain = freq(indi);
  
  % DEFINE THETA
    theta = 2*pi*(1:64)/64;

  phi(65) = phi(1);
  theta(65) = theta(1);
  % Phasenberichtigung der Vielfachen von Pi
    phi = unwrap(phi);
    theta = unwrap(theta);

  % % Kontrolle des Ergebnisses
  %   plot(theta, phi);

  % Berechne die Abweichung vom Mittelwert
    p=polyfit(theta,phi,3);
  for i=1:64
    nphi(i) = phi(i)-(p(1)*theta(i)^3+p(2)*theta(i)^2+p(3)*theta(i)+p(4));
  end;

  % plot(theta, nphi);

  % Umrechnung der Phi-Abweichung in Zeitschritt-Abweichung
  % zunächst Berechnung der Zeitschritte pro Periode
    dt = tt(2)-tt(1);
    T_steps = 1/fmain / dt;

  % Umrechnen von nphi
    nphi = nphi/(2*pi)*T_steps;
    nphi = ceil( nphi );

  % wegzuschneidender Randbereich
    cutaway = ceil(max(abs(nphi)))+1;

else
  cutaway = datamanuel{1};
  nphi    = datamanuel{2};
end;
  
  for i=1:64
    B(:,i) = A(cutaway-nphi(i):end-cutaway-nphi(i),i);
  end;
  
  sA = size(A);
  sB = size(B);
  
  B(sB+1:sA,:) = 0;
  
  fitdata{1} = cutaway;
  fitdata{2} = nphi;  
end