function [] = subplotfbicpsd(f1v, f2v, bv, fspec, spec, pon);
%function [] = subplotfbicpsd(f1v, f2v, bv, fspec, spec, pon);
% Create a plot of the bicoherence spectrum and a power spectrum.
%IN: i     figure number
%    f1v   frequency axis 1
%    f2v   frequency axis 2
%    bv    bicohernence matrix
%    fspec frequency axis for psd-spectrum
%    spec  spectrum matrix
%    pon (opt): hide jagged boundaries 1/0 (yes/no) (default 1)
%OUT: plot of bicoherence spectrum + power spectrum
%EXAMPLE: subplotfbicpsd(f1v, f2v, bv, fspec, spec, pon);

if nargin<5; error('Input arguments are missing!'); end;
if nargin<6; pon=1; end;

% Fontsize
  fs = 14;

% color plot
  colormap jet;
    
% pcolor plot
  subplot('position',[0.15 0.47 0.70 0.48]);
  pcolor(f1v/1e3, f2v/1e3, bv);
  shading interp;  
  set(gca, 'fontsize', fs);
  set(gca, 'tickdir', 'out');
    xlabel('f_1 [kHz]','fontsize', fs);
    ylabel('f_2 [kHz]','fontsize', fs);
  our_colorbar('f-auto-bicoherence', fs, 6.0, 0.015);
  % Hide the due to Nyquist double areas.
  if pon
  % get the points for the edge-lines (look-improvement for graph)
    [ln] = bicmattool(f1v/1e3, f2v/1e3, bv);
    line([ln(1,1) ln(1,2)], [ln(1,3) ln(1,4)], 'LineWidth', 3, 'Color', 'w');
    line([ln(2,1) ln(2,2)], [ln(2,3) ln(2,4)], 'LineWidth', 3, 'Color', 'w');
    line([ln(3,1) ln(3,2)], [ln(3,3) ln(3,4)], 'LineWidth', 3, 'Color', 'w');
  end;  
    
  subplot('position',[0.15 0.1 0.70 0.25]);
	graph2=semilogy(fspec/1e3, spec, '-k');
    xlabel('frequency [kHz]','fontsize', fs)
    ylabel('power spectrum [a.u]','fontsize', fs)
 
  set(gca, 'fontsize', fs);
   
end