function [] = plotzebra(tt, phi, A);
%function [hyl] = plotzebra(tt, phi, A);
%
% m-files needed:   subplotzebra
% input:    tt      time trace
%           phi     angle vector
%           A       2d phi-t-data
% output: hyl: handle ylabel  
%         spatio temporal plot
% EXAMPLE:  plotzebra(tt, phi, A);

if nargin<3
  error('Input arguments are missing!');
end;

fig(9,6,1);
  axes('Position', [0.17 0.22 0.72 0.7]);
  subplotzebra(tt, phi, A);

end