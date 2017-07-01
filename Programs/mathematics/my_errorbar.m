function my_errorbar(X, Y, dx, dy, Lwidth, Lcolor)
%==========================================================================
%function my_errorbar(X, Y, dx, dy, Lwidth, Lcolor)
%--------------------------------------------------------------------------
% MY_ERRORBAR plots horizontal and vertical errorars at data vectors (X,Y)
% the color can be different.
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% dx: [le ri]
% dy: [lo up]
% Lwidth = 1;
% Lcolor = [1 0 0; 0 1 0];
%--------------------------------------------------------------------------
% EX: my_errorbar(X,Y,dx,dy,Lwidth,Lcolor)
%==========================================================================

lX = length(X);

if size(Lcolor,1) == 1
  hcol = Lcolor;
  vcol = Lcolor;
else
  hcol = Lcolor(1,:);
  vcol = Lcolor(2,:);
end

% Horizontal errorbars
if ~isempty(dx)
  % If all points have the same errorbars
  if size(dx, 1) == 1
    dx(1:lX,1) = dx(1,1);
    dx(1:lX,2) = dx(1,2);
  end

  for i=1:lX
    h=line([X(i)-dx(i,1) X(i)+dx(i,2)], [Y(i) Y(i)], ...
      'LineWidth', Lwidth, 'Color', hcol);
    set(h, 'ZData', [-1 -1]);
  end
end

% Vertical errorbars
if ~isempty(dy)
  % If all points have the same errorbars
  if size(dy, 1) == 1
    dy(1:lX,1) = dy(1,1);
    dy(1:lX,2) = dy(1,2);
  end

  for i=1:lX
    h=line([X(i) X(i)], [Y(i)-dy(i,1) Y(i)+dy(i,2)], ...
      'LineWidth', Lwidth, 'Color', vcol);
    set(h, 'ZData', [-1 -1]);
  end
end
  
end