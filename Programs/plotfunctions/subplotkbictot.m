function []=subplotkbictot(tt, kbictot, kbictoterr);
%function []=subplotkbictot(tt, kbictot, kbictoterr);
% SUBPLOTKBICTOT creates a plot of the totel k-bicoherence.
%IN: tt (1d-vec): t-scale
%    kbictot (1d-vec): total bicoherence
%    kbictoterr (1d-vec): error of k-bicoherence
%OUT:subplot of total k-bicoherence
%EX: subplotkbictot(tt, kbictot, kbictoterr);

if nargin<3; error('Input arguments are missing!'); end;

% fontsize
  fs = 16;

% PLOT
  hold on;
  plot(tt, kbictot, 'k');
  plot(tt, kbictoterr, 'r-');  
  hold off;
  box on;
% Fontsize
  set(gca, 'Fontsize', fs);
  set(gca, 'tickdir', 'out');
% labels
  xlabel('time [a.u.]','fontsize',fs);
  ylabel('(b^{k})^{2}','fontsize',fs);
 title(['total k-bicoherence: \Sigma b_{k}^{2} = ', num2str(sum(kbictot))]);
  %OLD from kbictot ax=axis; axis([1 m ax(3) ax(4)]);  
  
end