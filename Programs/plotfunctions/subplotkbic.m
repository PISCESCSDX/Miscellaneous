function [] = subplotkbic(pon, k1, k2, b)
%function [] = subplotkbic(pon, k1, k2, b);
%IN: pon (integer): hide jagged edges y/n (0 or 1)
%    k1 (1d-vec): k-axis 1
%    k2 (1d-vec): k-axis 2
%    bv (2d-mat): k-bicohernence matrix
%OUT:plot of k-bicoherence spectrum
%EX: subplotkbic(pon, k1, k2, b);

if nargin<4; error('Input arguments are missing!'); end;

% Fontsize
  fs = 16;

% color of plot (good: cool, winter, autumn, hot, cbhot)
  colormap jet;

  [k1v,k2v,bv] = vertex(k1,k2,b);	% correct for missing vertices	
  
% pcolor plot
  pcolor(k1v, k2v, bv);
  set(gca, 'tickdir', 'out');
  shading interp;
  caxis([0 1]);
  set(gca, 'Fontsize', fs);
% labels
  xlabel('m_1', 'Fontsize', fs);
  ylb = ylabel('m_2', 'Fontsize', fs);

% colorbar
  cb = our_colorbar('k-auto-bicoherence', fs-2, 6.0, 0.015, 0.015);

% hide the due to Nyquist double areas
if pon
% get the points for the edge-lines (look-improvement for graph)
  [ln] = bicmattool(k1, k2, b);
  line([ln(1,1) ln(1,2)], [ln(1,3) ln(1,4)], 'LineWidth', 3, 'Color', 'w');
  line([ln(2,1) ln(2,2)], [ln(2,3) ln(2,4)], 'LineWidth', 3, 'Color', 'w');
  line([ln(3,1) ln(3,2)], [ln(3,3) ln(3,4)], 'LineWidth', 3, 'Color', 'w');
end;
  
end