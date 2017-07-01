function [] = plotkbic(i, k1, k2, b, pon);
%function [] = plotkbic(i, k1, k2, b, pon);
% Create a plot of the k-autobicoherence spectrum.
% EXPORT-TIPP: use high resolution: print_adv([0 1],'-r600','abic.eps');
% IN:  i     figure number
%      k1    frequency axis 1
%      k2    frequency axis 2
%      b     bicohernence matrix
%      pon   patch: on 1(default) / off 0
% OUT: plot of bicoherence spectrum (patch on)
% EX:  plotkbic(1, k1, k2, b, 1);

if nargin<4
  error('Input arguments are missing!');
end;
if nargin<5; pon = 1; end; % default patch on


  figeps(12, 13, i, 5, 5);

  axes('Position', [0.20 0.15 0.60 0.82]);
  subplotkbic(pon, k1, k2, b);
    
end