function [] = plotkspec(tt, kax, kspec);
%function [] = plotkspec(tt, kax, kspec);
% 2d-plot of time evolution of k-spectrum.
% m-files needed:   subplotfspec
% input:    tt      time vector /s
%           kax     k-axis vector
%           kspec   2d tt-kspec matrix
% output:   2d-plot of wavelet analysis
% EXAMPLE:  plotkspec(tt, kax, kspec, ylab);

if nargin<3; error('Input arguments are missing!'); end

figeps(12,7,1)
    axes('Position', [0.15 0.2 0.8 0.75]);
    subplotkspec(tt, kax, kspec);
end