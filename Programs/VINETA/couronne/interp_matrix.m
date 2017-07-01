function [XI, YI, mat_I]= interp_matrix(x_org, y_org, mat, pnt)
%function [XI, YI, mat_I]= interp_matrix(x_org, y_org, mat, n)
% Resample matrix to [res x res] matrix together with x- and y-vector.
%
% IN: x_org: x values as [1 x m] or [m x 1] vec
%     y_org: y values as [1 x n] or [n x 1] vec
%     mat: matrix of dim [n x m]
%     pnt: vector of resolution [m_new n_new]; e.g. [2^16 64]
% OUT: XI: resampled x values, [res x 1] vec
%      YI: resampled y values, [res x 1] vec
% EX:

   xa = x_org(1);
   xb = x_org(end);
   ya = y_org(1);
   yb = y_org(end);

   if size(x_org, 2) ~= 1, x_org= x_org'; end
   if size(y_org, 2) ~= 1, y_org= y_org'; end

   [XI, YI] = meshgrid( linspace(xa, xb, pnt(1)), ...
                       linspace(ya, yb, pnt(2)) );
   [x_grd, y_grd] = meshgrid(x_org, y_org);

   mat_I = interp2(x_org, y_org, mat, XI, YI, 'linear');
   XI = XI(1, :)';
   YI = YI(:, 1);
end