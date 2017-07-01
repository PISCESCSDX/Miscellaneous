function [matnew]=interp_matrix_xynew(xold, yold, matold, xnew, ynew)
%==========================================================================
%function [xnew, ynew, matnew]= interp_matrix_xynew(xold, yold, matold, pnt)
%--------------------------------------------------------------------------
% Interpolate matrix.
% Aug-25-2013, Christian Brandt, San Diego
%--------------------------------------------------------------------------
% IN: xold: x values as [1 x m] or [m x 1] vec
%     yold: y values as [1 x n] or [n x 1] vec
%     matold: matrix of dim [n x m]
%     xnew: resampled x values, [res x 1] vec
%     ynew: resampled y values, [res x 1] vec
%--------------------------------------------------------------------------
% EX: [xn, yn, An] = interp_matrix(x, y, A, xn, yn)
%==========================================================================

[xn,yn] = meshgrid(xnew,ynew);
matnew = interp2(xold, yold, matold, xn, yn, 'linear');

end