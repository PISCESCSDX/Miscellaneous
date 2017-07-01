function [] = plotsumfbic(i, freq, sumb, sumerr)
%function [] = plotsumfbic(freq, sumb, sumerr)
% PLOTSUMFBIC creates a plot of the summed f-bicoherence.
%IN: i (int num): figure number
%    freq (1d-vec): frequency axis
%    sumb (1d-vec): summed bicoherence
%    sumerr (1d-vec): error of the summed bicoherence
%OUT:plot of the summed bicoherence and error
%EX: plotsumfbic(1, freq, sumb, sumerr);

if nargin<4; error('Input arguments are missing!'); end;

  fig(12, 10, i);

  axes('Position', [0.20 0.15 0.75 0.82]);
  subplotsumfbic(freq, sumb, sumerr);
    
end