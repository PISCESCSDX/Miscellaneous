function [] = subplotfbic(pon, f1v, f2v, bv);
%function [] = subplotfbic(f1v, f2v, bv);
%IN:  pon   hide jagged boundaries
%     f1v   frequency axis 1 (Hz)
%     f2v   frequency axis 2 (Hz)
%     bv    bicohernence matrix
%OUT: plot of bicoherence spectrum
%EXAMPLE: subplotfbic(pon, f1v, f2v, bv);
%
% PROBLEM during EXPORT: f-axis is different

fonts = 12;

if nargin<4; error('Input arguments are missing!'); end;

% color of plot (good: cool, winter, autumn, hot, cbhot)
  colormap jet;

% pcolor plot
%  pcolor(f1v/1e3, f2v/1e3, bv);
  [c, h] = contourf(f1v/1e3, f2v/1e3, bv, 40);
  % Matlab will draw both the shading and annoying contours.
  % The following little loop will turn off the contours
  % by setting their color to "none."
  for icnt = 1: length(h)
    set( h(icnt), 'EdgeColor', 'none' )
  end

% labels
% % without the next 2 lines the yticks are set wrong
%     yax = get(gca, 'YTick');
%     set(gca, 'YTick', yax);
%   set(gca, 'YTickLabel',{'-20','-10','0','10'});
  mkplotnice('f_1 [kHz]', 'f_2 [kHz]', fonts);
% colorbar business
  cb = our_colorbar('auto bicoherence', fonts, 6.0, 0.015, 0.015);

% % Hide the due to Nyquist double areas.
% if pon
% % get the points for the edge-lines (look-improvement for graph)
%   [ln] = bicmattool(f1v/1e3, f2v/1e3, bv);
%    line([ln(1,1) ln(1,2)], [ln(1,3) ln(1,4)], [-0.1 -0.1], 'LineWidth', 3, 'Color', 'w');
%    line([ln(2,1) ln(2,2)], [ln(2,3) ln(2,4)], [-0.1 -0.1], 'LineWidth', 3, 'Color', 'w');
%    line([ln(3,1) ln(3,2)], [ln(3,3) ln(3,4)], [-0.1 -0.1], 'LineWidth', 3, 'Color', 'w');
% end;

end