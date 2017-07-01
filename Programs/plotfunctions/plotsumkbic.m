function [] = plotsumkbic(i, kax, sumb, sumerr)
%function [] = plotsumkbic(i, kax, sumb, sumerr)
% PLOTSUMKBIC creates a subplot of the summed k-bicoherence.
%IN: kax (1d-vec): wavenumber-axis
%    sumb (1d-vec): summed bicoherence
%    sumerr (1d-vec): error of the summed bicoherence
%OUT:subplot of summed bicoherence spectrum
%EX: plotsumkbic(kax, sumb, sumerr);

if nargin<4; error('Input arguments are missing!'); end;

  fig(12, 10, i);

  axes('Position', [0.20 0.15 0.75 0.72]);
  subplotsumkbic(kax, sumb, sumerr);
    
end