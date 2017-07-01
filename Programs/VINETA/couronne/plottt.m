function [] = plottt(tt, sig);
%function [] = plottt(tt, sig);
% m-files needed:   subplottt
% input:    tt    time trace /s
%           sig     signal of floating potential
% output:   plot of the time trace
% EXAMPLE:  plottt(tint, sig);

fonts = 14;

if nargin<2
    error('Input arguments are missing!');
end;


set(gcf,'PaperUnits','centimeters','PaperType','a4letter',...
        'PaperPosition',[1 200 11 8], 'Color', [1.0 1.0 1.0]);
%-- make pictures look the same on printer and on screen
    wysiwyg;

    axes('Position', [0.20 0.18 0.7 0.75]);
    
    subplottt(tt, sig, 1, 4);

end