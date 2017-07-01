function pos = xlbdist(hxl, modus, pix_xy)
%==========================================================================
%function pos = xlbdist(hxl, modus, pix_xy)
%--------------------------------------------------------------------------
% XLBDIST moves the xlabel in horizontal and vertical direction.
% 'modus' determines whether the label should be moved from the current
% position (modus = 'RelativePosition'), or in absolut pixel measures
% (modus='AbsolutePosition').
% 'pix_xy' is a vector of the type [x y], pixel in horizontal direction.
%--------------------------------------------------------------------------
% IN: hxl: handle of xlabel
%     modus: 'RelativePosition' or 'AbsolutePosition'
%     pix_xy: cell vector {xstring, ystring}: x-shift and y-shift
%OUT: pos: position of label after positioning
%--------------------------------------------------------------------------
% EX: xlbdist(h, 'AbsolutePosition', {'', '-10'})
%     will not effect the xlabel's x-position, but set the y-position
% (C. Brandt, 23.03.2011)
%==========================================================================

if nargin<3; disp('Error: XLBDIST: input is missing'); return; end

% Set units to pixels and get position of label
un = get(hxl, 'units');
set(hxl, 'units', 'pixels');
pos = get(hxl, 'position');

switch modus
  case 'RelativePosition'
    
    if ~strcmp(pix_xy(1), 'x')
      newposx = pos(1) + str2double( cell2mat(pix_xy(1)) );
    else
      newposx = pos(1);
    end
    
    if ~strcmp(pix_xy(2), 'x')
      newposy = pos(2) + str2double( cell2mat(pix_xy(2)) );
    else
      newposy = pos(2);
    end

  case 'AbsolutePosition'
    
    if ~strcmp(pix_xy(1), 'x')
      newposx = str2double( cell2mat(pix_xy(1)) );
    else
      newposx = pos(1);
    end
    
    if ~strcmp(pix_xy(2), 'x')
      newposy = str2double( cell2mat(pix_xy(2)) );
    else
      newposy = pos(2);
    end
end

set(hxl, 'position', [newposx newposy pos(3)]);
    
% Reset units as before
set(hxl, 'units', un);
pos = get(hxl, 'position');

end