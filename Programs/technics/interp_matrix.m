function [xnew, ynew, matnew]= interp_matrix(xold, yold, matold, pnt)
%==========================================================================
%function [xnew, ynew, matnew]= interp_matrix(xold, yold, matold, pnt)
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
% EX: [xn, yn, An] = interp_matrix(x, y, A, [200 200])
%==========================================================================

xa = xold(1);
xb = xold(end);

ya = yold(1);
yb = yold(end);

if size(xold, 2) ~= 1, xold= xold'; end
if size(yold, 2) ~= 1, yold= yold'; end

[xnew, ynew] = meshgrid( linspace(xa, xb, pnt(1)), ...
                     linspace(ya, yb, pnt(2)) );

matnew = interp2(xold, yold, matold, xnew, ynew, 'linear');
xnew = xnew(1, :)';
ynew = ynew(:, 1);
end