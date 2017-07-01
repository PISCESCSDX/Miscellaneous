function [XI, YI, mat_I]= interp_matrix(x_org, y_org, mat, res)
% function [XI, YI, mat_I]= interp_matrix(x_org, y_org, mat, n)
%
% resample matrix to [res x res] matrix together with x- and y-vector
%
% input             x_org       x values as [1 x m] or [m x 1] vec
%                   y_org       y values as [1 x n] or [n x 1] vec
%                   mat         matrix of dim [n x m]
% output            XI          resampled x values, [res x 1] vec
%                   YI          resampled y values, [res x 1] vec
%
   x_st= x_org(1);
   x_en= x_org(end);
   y_st= y_org(1);
   y_en= y_org(end);
   
   if size(x_org, 2) ~= 1, x_org= x_org'; end
   if size(y_org, 2) ~= 1, y_org= y_org'; end
   
   [XI, YI]= meshgrid( linspace(x_st, x_en, res), ...
                       linspace(y_st, y_en, res) );
   [x_grd, y_grd]= meshgrid(x_org, y_org);
   
   mat_I= interp2(x_org, y_org, mat, XI, YI, 'linear');
   XI= XI(1, :)';
   YI= YI(:, 1);
   
end