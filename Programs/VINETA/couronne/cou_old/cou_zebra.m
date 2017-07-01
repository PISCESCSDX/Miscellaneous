function []= cou_zebra(mat, time, fs)
% function []= cou_zebra(mat, time, fs)
%
% plots mat over time and 2pi as density plot, assuming 
% it is data from the couronne
%
% input     mat         matrix [n x 64] n sample, 64 channels (2pi)
%           time        vector [n x 1] time in s
%           fs          (optional) font size
    
   t_ind_st= 30000;
   t_ind_en= 35000;
   pnt = 300;
   
   if nargin < 3
       fs= 18;
   end
   
   phivec= linspace(0, 2, 64)';

   %kill not sampled/bad channels
   kill_ind= isnan(mat);
   phivec= phivec(~kill_ind(1, :));
   time  = time(~kill_ind(:, 1));
   mat= reshape(mat(~kill_ind), ...
                size(time, 1),  ...
                size(phivec, 1));
   
   %raw reduction of data
   mat = mat(t_ind_st:t_ind_en, :);
   time= time(t_ind_st:t_ind_en) .* 1000;
   dt= time(end) - time(1);
   
   %normalize data not called by cou_plot_zebrakf
   [S,I] = dbstack;
   [path,c_name] = fileparts(S(min(I+1,length(S))).name);
   if ~strcmp(c_name, 'cou_plot_zebrakf')
       mat= normmat_std(mat);
       [U,S,V]= svds(mat, 5);
       mat= U*S*V';
   end
   
   %interpolation to grid [pnt x pnt]
   [time_I, phi_I, mat_I]= interp_matrix(time, phivec, mat', 500);
   time_I = time_I(20:(end-20)) - time_I(20);
   mat_I= mat_I(:, 20:(end-20));
   
   %remove offset
   mat_I= mat_I - mean(mean(mat_I));
   
   %plot couronne
   %clf()
   pcolor(time_I, phi_I, mat_I);
   caxis([-1.5, 1.5]);
   shading flat
   
   ah= gca();
   %set(ah, 'position', [0.12, 0.17, 0.72, 0.7]);
   set(ah, 'fontsize', fs);
   xh= xlabel('t in ms', 'Fontsize', fs);
   x_pos= get(xh, 'position');
   x_pos= x_pos .* [1, 1, 1];
   set(xh, 'position', x_pos);
   yh= ylabel('\phi / \pi', 'Fontsize', fs + 4);
   y_pos= get(yh, 'position');
   y_pos= [dt, y_pos(2:3)] .* [0.08, 1, 1] + [y_pos(1), 0, 0];
   set(yh, 'position', y_pos);

   %----------------------------------------------colormap
   our_colorbar('norm. density', fs, 1.35);
   colormap(pastell);
   caxis([-3,3]);
   
end