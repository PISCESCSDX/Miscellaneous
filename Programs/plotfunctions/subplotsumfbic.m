function [] = subplotsumfbic(freq, sumb, sumerr)
%function [] = subplotsumfbic(freq, sumb, sumerr)
% SUBPLOTSUMFBIC creates a subplot of the summed f-bicoherence.
%IN: freq (1d-vec): frequency axis (Hz)
%    sumb (1d-vec): summed bicoherence
%    sumerr (1d-vec): error of the summed bicoherence
%OUT:subplot of summed bicoherence spectrum
%EX: subplotsumfbic(freq, sumb, sumerr);

if nargin<3; error('Input arguments are missing!'); end;

% fontsize
  fs = 16;

% PLOT
  hold on;
  plot(freq/1e3, sumb, 'k');
  plot(freq/1e3, sumerr, 'r-');  
  hold off;
  box on;
% Fontsize
  set(gca, 'Fontsize', fs);
  set(gca, 'tickdir', 'out');
% labels
  xlabel('f [kHz]', 'fontsize', fs);
  ylb = ylabel('summed f-bicoherence', 'fontsize', fs);

end