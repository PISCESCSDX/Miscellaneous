function [] = subplotsumkbic(kax, sumb, sumerr)
%function [] = subplotsumkbic(kax, sumb, sumerr)
% SUBPLOTSUMKBIC creates a subplot of the summed k-bicoherence.
%IN: kax (1d-vec): wavenumber-axis
%    sumb (1d-vec): summed bicoherence
%    sumerr (1d-vec): error of the summed bicoherence
%OUT:subplot of summed bicoherence spectrum
%EX: subplotsumkbic(kax, sumb, sumerr);

if nargin<3; error('Input arguments are missing!'); end;

% fontsize
  fs = 16;

% PLOT
  hold on;
  plot(kax, sumb, 'k');
  plot(kax, sumerr, 'r-');  
  hold off;
  box on;
% Fontsize
  set(gca, 'Fontsize', fs);
  set(gca, 'tickdir', 'out');
% labels
  xlabel('mode number', 'fontsize', fs);
  ylb = ylabel('summed k-bicoherence', 'fontsize', fs);

end