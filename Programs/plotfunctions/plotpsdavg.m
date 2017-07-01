function [] = plotpsdavg(i, kax, spec)
%function [] = plotsumkbic(i, kax, sumb, sumerr)
% PLOTPSDAVG creates a plot of the mean power spectrum.
%IN: i (int num): figure number
%    kax (1d-vec): k-axis
%    spec (1d-vec): mean power spectrum
%OUT:plot of the mean power spectrum
%EX: plotpsdavg(1, kax, spec);

if nargin<3; error('Input arguments are missing!'); end;

  fig(12, 10, i);

  axes('Position', [0.20 0.15 0.75 0.72]);
  subplotpsdavg(kax, spec);
    
end