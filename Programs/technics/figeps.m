function [hf] = figeps(xsize,ysize,i,xpos,ypos)
%==========================================================================
%function [hf] = figeps(xsize,ysize,i,xpos,ypos)
%--------------------------------------------------------------------------
% Create figure with given size. Positions the figure on screen.
%--------------------------------------------------------------------------
% IN: xsize: cm
%     ysize: cm
%     i = figure number
%     (opt) xpos: [%] of screensize
%     (opt) ypos: [%] of screensize
%OUT: hf: handle of figure
%--------------------------------------------------------------------------
% EX: figeps(8,6,1,0,100)
%==========================================================================


if nargin < 5; ypos=100; end	
if nargin < 4; xpos=0; end	
if nargin < 3; i=1; end	
if nargin < 2; error('Input parameters are missing!'); end

hf = figure(i);
set(gcf,'PaperUnits','centimeters','PaperType','a4letter', ...
  'PaperPosition', [1 1 xsize ysize],'Color','w');
wysiwyg;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLACE FIGURE LEFT UPPER CORNER ON SCREEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GET SCREEN SIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screensize = get(0, 'screensize');
scrx = screensize(3);
scry = screensize(4);

% GET SCREEN SIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fpos = get(hf, 'OuterPosition');

os = getenv('os');
if strcmp(os, 'Windows_NT')
  taskbar = 29;
else
  taskbar = 0;
end
  
  
nx = floor( xpos/100 * (scrx-fpos(3)) );
ny = floor((ypos/100)*(scry - fpos(4) - taskbar));
set(gcf, 'outerposition', [nx ny+taskbar fpos(3) fpos(4)]);

end