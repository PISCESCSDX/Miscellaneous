function []= cou_subplotzebra(mat, time, t_ind_st, delta_t, fs, labelsonoff, zebra_colorbar)
%
%
%function []= cou_subplotzebra(mat, time, t_ind_st, delta_t, fs,
%labelsonoff, zebra_colorbar)
%
% plots mat over time and 2pi as density plot, assuming 
% it is data from the couronne
%
% input     mat         matrix [n x 64] n sample, 64 channels (2pi)
%           time        vector [n x 1] time in s
%           t_ind_st    start point of tseries (between 0 and 65000)
%           delta_t     amount of regarded time points
%           fs          (optional) font size
%           labelsonoff switch labels on or off (0 off, 1 on)
%           zebra_colorbar 0: colorbar off 1: colorbar on

   if nargin < 7
       zebra_colorbar= 1;
   end
   if nargin < 6
       labelsonoff= 1;
   end
   if nargin < 5
       fs= 18;
   end
   if nargin < 4
       delta_t= 7500; % 6ms
   end   
   if nargin < 3
       t_ind_st= 30000;
   end      
   t_ind_en= t_ind_st + delta_t;   
   pnt = 300;      
   
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
   colormap(pastell);      
   pcolor(time_I, phi_I, mat_I);
   caxis([-1.5, 1.5]);
   shading interp
   

   %   fpos=get(fh, 'Position');
   set(gca, 'fontsize', fs);
   set(gca,'ticklength',[0.02 0.02]);   
   if labelsonoff == 1
       xh= xlabel('t /ms', 'Fontsize', fs);
       x_pos= get(xh, 'position');
       x_pos= x_pos .* [1, 1, 1];
       set(xh, 'position', x_pos);
       yh= ylabel('\phi /\pi', 'Fontsize', fs + 4);
       y_pos= get(yh, 'position');
       y_pos= [dt, y_pos(2:3)] .* [0.02, 1, 1] + [y_pos(1), 0, 0];
       set(yh, 'position', y_pos);
       
%    %----------------------------------------------colormap
%    our_colorbar('norm. density', fs, 0.2);
%    %  colormap(pastell(128));       

        colmin =-2.5; colmax = 2.5;
        caxis([colmin colmax]);        
    if zebra_colorbar==1
        % create a good colorbar
        c=your_colorbar(0.97, 0.99, 0.2, '', 12);
        set(c, 'yticklabel', {'-1', ' 0', ' 1'});   
    end;
   end;

end