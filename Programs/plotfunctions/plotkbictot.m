function [] = plotkbictot(i, tt, kbictot, kbictoterr)
%function [] = plotkbictot(i, tt, kbictot, kbicerrtot)
% PLOTKBICTOT creates a plot of the totel k-bicoherence.
%IN: i (int num): figure number
%    tt (1d-vec): t-scale
%    kbictot (1d-vec): total bicoherence
%    kbictoterr (1d-vec): error of k-bicoherence
%OUT:plot of the total bicoherence
%EX: plotkbictot(i,tscale,bictot,errtot);

if nargin<4; error('Input arguments are missing!'); end;

  fig(12, 10, i);

  axes('Position', [0.20 0.15 0.75 0.72]);
  subplotkbictot(tt, kbictot, kbictoterr);
    
end