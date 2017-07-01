function [] = subplotpsdavg(kax, spec)
%function [] = subplotsumkbic(kax, sumb, sumerr)
% SUBPLOTPSDAVG creates a plot of the mean power spectrum.
%IN: kax (1d-vec): k-axis
%    spec (1d-vec): mean power spectrum
%OUT:plot of the mean power spectrum
%EX: subplotpsdavg(1, kax, spec);

if nargin<2; error('Input arguments are missing!'); end;

% fontsize
  fs = 16;

  
  %semilogy(kaxe,spec,'r','linewidth',2)
  %xlabel(lab,'fontsize',14)
  %ylabel('S(k)','fontsize',14)
  %title('Mean Power Spectrum (a.u)')
  %ax2 = axis; axis([0 kmax/2 0.4*specmin 2*specmax]);
  
  
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
  xlabel('wave number', 'fontsize', fs);
  ylb = ylabel('summed k-bicoherence', 'fontsize', fs);

end