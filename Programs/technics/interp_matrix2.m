function [xnew, ynew, matnew]= interp_matrix2(x, y, matold, pnt)
%==========================================================================
%function [xnew, ynew, matnew]= interp_matrix2(x, y, matold, pnt)
% 09.05.2012, C. Brandt, San Diego
%--------------------------------------------------------------------------
% Resample matrix to [res x res] matrix together with x- and y-vector.
%--------------------------------------------------------------------------
% IN: xold: x values as [1 x m] or [m x 1] vec
%     yold: y values as [1 x n] or [n x 1] vec
%     matold: matrix of dim [n x m]
%     pnt: vector of resolution [m_new n_new]; e.g. [2^16 64]
% OUT: xnew: resampled x values, [res x 1] vec
%      ynew: resampled y values, [res x 1] vec
%--------------------------------------------------------------------------
% EX: [xn, yn, An] = interp_matrix2(x, y, A, [200 200])
%==========================================================================

xa = matmin(x);  xb = matmax(x);  xnew = linspace(xa, xb, pnt(1));
ya = matmin(y);  yb = matmax(y);  ynew = linspace(ya, yb, pnt(2));

[xnew, ynew] = meshgrid(xnew, ynew);

matnew = interp2(x, y, matold, xnew, ynew, 'linear');

end