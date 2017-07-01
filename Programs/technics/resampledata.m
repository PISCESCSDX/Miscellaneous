function [yn] = resampledata(x,y,xn)
%function [yn] = resampledata(x,y,xn)
% RESAMPLEDATA creates a new vector yn from the series (x, y) according
% the new x-vector xn.
% IN: x: original x-vector
%     y: original y-vector
%     xn: new x-vector (can have more or less points)
%OUT: yn: new y-vector

cs = spline(x, y);
yn = ppval(cs, xn);

end