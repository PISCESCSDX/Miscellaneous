function [hp] = subplotkspec(tt, kax, kspec, xlb, ylb)
%20080225-Mo-04:53
%function [] = subplotkspec(tt, kax, kspec, ylab, xlb);
% m-files needed:   
% input:    tt      time vector /s
%           kax     k-axis vector
%           kspec   2d tt-kspec plot
%           xlb     xlabel on/off
% output:   Time evolution plot of the k-spectrum
% EXAMPLE:  subplotkspec(tt, kax, kspec, ylab, xlb);


fonts = 12;

if nargin<5; ylb='mode #'; end;
if nargin<4; xlb='time (ms)'; end;
if nargin<3; error('Input arguments are missing!'); end;

% % t-kspec plot
%   colormap jet;

% create the time intervall
%OLD    tt = tt*1e3;
  tt=1e3*tt;

% pcolor plot
hp = pcolor(tt, kax, kspec');
  shading interp;
  colormap('jet'), view(2);
  axis([tt(1) tt(end)  kax(1) kax(end)]);

% labels
if ~strcmp(xlb,'-3')
  mkplotnice(xlb, ylb, fonts, -30);
end
    
end