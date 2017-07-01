function make_xy_axisequal(x,y)
%function make_xy_axisequal
%

  dx = (max(x)-min(x));
  dy = (max(y)-min(y));
  diagratio = dy/dx;

  fsz = get(gcf, 'position');
  asz = get(gca, 'position');

  % CALC REAL DIAG SIZE
  dsx = asz(3) * fsz(3);
  dsy = asz(4) * fsz(4);

  if dsx <= dsy
    asz(4) = diagratio * asz(3)*fsz(3)/fsz(4);
  else
    asz(3) = diagratio * asz(4)*fsz(4)/fsz(3);
  end

  set(gca, 'position', [asz(1) asz(2) asz(3) asz(4)])

end