function [] = plotfbicpsd(i, f1v, f2v, bv, fspec, spec);
%function [] = plotfbicpsd(i, f1v, f2v, bv, fspec, spec);
% Create a plot of the bicoherence spectrum and a power spectrum.
%
%IN:  i     figure number
%     f1v   frequency axis 1
%     f2v   frequency axis 2
%     bv    bicohernence matrix
%     fspec frequency axis for psd-spectrum
%     spec  spectrum matrix
%OUT: plot of bicoherence spectrum + power spectrum
%EXAMPLE: plotfbicpsd(1, f1v, f2v, bv, fspec, spec);

if nargin<5
  error('Input arguments are missing!');
end;


  fig(14,15,i);

  subplotfbicpsd(f1v, f2v, bv, fspec, spec);
end