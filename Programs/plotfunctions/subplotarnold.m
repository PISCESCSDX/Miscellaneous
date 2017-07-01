function [hxl hyl] = subplotarnold(f1, A1, f2, A2, xlb, ylb, ...
  mcol, mtype, msize)
%==========================================================================
% function [hxl hyl] = subplotarnold(f1, A1, f2, A2, xlb, ylb, ...
%   mcol, mtype, msize)
%--------------------------------------------------------------------------
% IN: f1, f2: frequency vector 1, 2
%     mtype: marker type 'o', 'x', ...
%     msize: marker size
%OUT: A1, A2: amplitude vector
%--------------------------------------------------------------------------
% EX:  subplotzebra(tt, fvec, W, 0);
%==========================================================================

fs = 12;

if nargin<9; msize = 2; end;
if nargin<8; mtype = 'o'; end;
if nargin<7; mcol = 'k'; end;
if nargin<5; error('Input arguments are missing!'); end;

hold on
  plot(f1, A1, [mcol mtype], 'MarkerSize', msize, ... 
    'MarkerEdgeColor', mcol, 'MarkerFaceColor', mcol);
  plot(f2, A2, [mcol mtype], 'MarkerSize', msize, ...
    'MarkerEdgeColor', mcol, 'MarkerFaceColor', mcol);
hold off

if ~strcmp(xlb, '-3')
  [hxl hyl] = mkplotnice(xlb,ylb, fs, -30);
end
   
end