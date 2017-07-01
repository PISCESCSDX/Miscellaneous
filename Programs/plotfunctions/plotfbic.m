function [] = plotfbic(i, f1v, f2v, bv, pon);
%function [] = plotfbic(f1v, f2v, bv, pon);
% Create a plot of the bicoherence spectrum.
% EXPORT-TIPP: use high resolution: print_adv([0 1],'-r600','abic.eps');
%IN:  i     figure number
%     f1v   frequency axis 1
%     f2v   frequency axis 2
%     bv    bicohernence matrix
%     pon   patch: on 1(default) / off 0
%OUT: plot of bicoherence spectrum (patch on)
%EXAMPLE: plotfbic(1,f1v, f2v, bv, 1);

if nargin<4; error('Input arguments are missing!'); end;
if nargin<5; pon = 1; end; % default patch on

  figeps(9, 10, i);
  axes('Position', [0.20 0.15 0.61 0.82]);
  subplotfbic(pon, f1v, f2v, bv);
    
end