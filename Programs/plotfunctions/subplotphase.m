function [ha hp] = subplotphase(frq, phase, phstd, xlb, ylb, xlim, fonts)
%==========================================================================
% function [ha hp] = subplotphase(frq, phase, phstd, xlb, ylb, xlim, fonts)
%--------------------------------------------------------------------------
% Subplot of phase of CPSD cross power spectral density.
%--------------------------------------------------------------------------
% IN: frq: freq axis [kHz]
%     phase: CPSD phase (in pi)
%     phstd: standard deviation of the phase
%OUT: subplot of the phase spectrum
% EX: function [ha hp] = subplotphase(frq, phase, phstd, xlb, ylb, xlim)
%==========================================================================

if nargin<7; fonts=12; end;
if nargin<6 || isempty(xlim); xlim=[min(frq) max(frq)]; end;
if nargin<5 || isempty(ylb);  ylb='phase (\pi)'; end
if nargin<4 || isempty(xlb);  xlb='f (kHz)'; end
if nargin<3; phstd=[]; end
if nargin<2; error('Input arguments are missing!'); end;

%	frequency axis in kHz
  frq = frq/1e3;
%   plot phase-spectrum

%  hp = semilogx(frq, phase, 'k');
%  hp = errorbar(frq, phase, phstd, zeros(size(phstd,1),1), 'k-'); 

% LINE PROCEDURE
%lincolor = 1*[1 0.5 0.5]; % light red
%minph = min(phstd);
%maxph = max(phstd);
%phstdcol = (phstd-minph)./(maxph-minph);

for i=1:length(frq)
%  lincolor = col(round(((1-phstdcol(i)).^4)*127+1), :);
  lincolor = 0.8*[1 1 1];
  line([frq(i) frq(i)], [phase(i)-2*phstd(i) phase(i)+2*phstd(i)], ...
    'Color', lincolor, 'LineWidth', 1);
end

hold on;
  hp = plot(frq, phase, 'r-', 'LineWidth', 1, 'Color', [0 0 0]);
hold off;
  set(gca, 'xlim', [xlim(1) xlim(2)]);
  set(gca, 'ylim', [-1.1 1.1]);
  set(gca, 'xscale', 'log');

  set(gca, 'xtick', [1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100]);
  set(gca, 'xticklabel', ...
  {'1','2','','','5','','','','','10','20','','','50','','','','','100'});
  ha = gca;
  set(gca, 'ytick', [-1 0 +1]);

% MAKE PLOT NICE
  mkplotnice(xlb, ylb, fonts, '-20', '-30');

end