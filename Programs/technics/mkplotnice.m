function [hxl hyl] = mkplotnice(xlb, ylb, fs, xly, ylx)
%==========================================================================
%function [hxl hyl] = mkplotnice(xlb, ylb, fs, xly, ylx)
%--------------------------------------------------------------------------
% MKPLOTNICE standardizes plots, ticks, labels, fontsize.
% If xlb or ylb are '-1' no labels or ticklabels will be printed, '-2' 
% even no ticks will be set.
%--------------------------------------------------------------------------
% IN: xlb: string with the xlabel e.g. 'frequency (kHz)'
%     ylb: string with the xlabel e.g. 'CPSD (dB)'
%      fs: fontsize
%     xly: shift xlabel along y-direction
%     ylx: shift ylabel along x-direction
%--------------------------------------------------------------------------
% EX: mkplotnice('-1', 'y (cm)', fonts, '', '-30');
%     mkplotnice('r (cm)','n_e (10^{18} m^{-3})',fonts,'-20','-30');
%==========================================================================

if nargin<5; ylx=0; end
if nargin<4; xly=0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FONTSIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gca, 'fontsize', fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X-LABEL BUSINESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = whos('xlb');
if strcmp(a.class,'cell')
  xlb = cell2mat(xlb);
end

if ~isempty(xlb)
  switch xlb
    case '-1'
      set(gca, 'xticklabel', []);
      hxl = [];
    case '-2'
      set(gca, 'xtick', []);
      hxl = [];
  end
  if ~strcmp(xlb, '-1') && ~strcmp(xlb, '-2')
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Test wether first sign is '$' -> latex interpreter ON
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(xlb(1) , '$')
      xlb = xlb(2:length(xlb));
      hxl = xlabel(xlb,'interpreter', 'latex', 'fontsize', fs);
      %OLDhxl = xlabel(xlb,'interpreter', 'latex', 'fontsize', 1.1*(fs+dfs));
    else
      hxl = xlabel(xlb, 'fontsize', fs);
      xlbdist(hxl, 'AbsolutePosition', {'x', xly});
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y-LABEL BUSINESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = whos('ylb');
if strcmp(a.class,'cell')
  ylb = cell2mat(ylb);
end

if ~isempty(ylb)
  switch ylb
    case '-1'
      set(gca, 'yticklabel', []);
      hyl = [];
    case '-2'
      set(gca, 'ytick', []);
      hyl = [];
  end
  if ~strcmp(ylb, '-1') && ~strcmp(ylb, '-2')
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Test wether first sign is '$' -> latex interpreter ON
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(ylb(1), '$')
      ylb = ylb(1:length(ylb));
      hyl = ylabel(ylb,'interpreter', 'latex', 'fontsize', fs);
      %OLDhyl = ylabel(ylb,'interpreter', 'latex', 'fontsize', 1.1*(fs+dfs));
    else
      hyl = ylabel(ylb, 'fontsize', fs);
      ylbdist(hyl, 'AbsolutePosition', {ylx, 'x'});
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOME OPTICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
box on
set(gca, 'tickdir', 'out');

% Define ticklength in pixels
tlpix = 3;
% Get sizes of figure and axes
 figpos = get(gcf, 'position');
 axpos  = get(gca, 'position');
 axpix = [figpos(3)*axpos(3) figpos(4)*axpos(4)];
 max_axpix = max(axpix);
 tlnew = tlpix/max_axpix;
% Get ticklength: [2D-length 3D-length]
tl = get(gca, 'TickLength');
set(gca, 'ticklength', [tlnew tl(2)]);
set(gca, 'Layer', 'top')


end