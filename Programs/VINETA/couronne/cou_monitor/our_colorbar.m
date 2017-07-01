function varnargout = our_colorbar(ylbl, fs, xdist)
% [cb_hdl]= our_colorbar( [ylabel, FontSize, xdist] )
%
% MY_COLORBAR generates a colorbar without resizing the current
% axes and sets the distance to the axes to 0.03 (of 1) and the
% width of the colorbar to 0.05 (of 1). 
%
% function initialy written by Albrecht, but now changed to work
% with absolute values, ranging from 0..1
%

    xpos = 0.008;
    wdth = 0.015;
    if nargin < 1
        ylbl = '';
    end
    if nargin < 2
        fs = 14;
    end
    if nargin < 3
        xdist = 1;
    end

    % Get current axis positions
    ah = gca();
    ax_pos = get(ah,'position');

    % Create colorbar and reset axes
    cb = colorbar;

    % Reshape colorbar (closer to axes and thinner) and
    % reset axes
    cb_pos = get(cb,'position');
    cb_pos = [ ax_pos(1) + ax_pos(3) + xpos, ...
               ax_pos(2), ...
               wdth, ...
               ax_pos(4) ...
              ];
    set(cb,'position', cb_pos, ...
           'Fontsize', fs ...
           );
    set(ah,'position',ax_pos)
       
    % Ylabel
    yh= ylabel(cb, ylbl); 
    pos= get(yh, 'position');
    pos(1)= 10 .* xdist;
    set(yh, 'position', pos);

    if nargout == 1
        varnargout = cb;
    end;
end