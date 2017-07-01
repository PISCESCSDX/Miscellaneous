function []= cou_subplotzebra_load_data(time, phi, mat, fs, labelsonoff, zebra_colorbar)
%
%
%function []= cou_subplotzebra_load_data(time, phi, mat, fs, labelsonoff,
%zebra_colorbar)
%
% plots mat over time and phi as density plot, assuming 
% it is data from the couronne. it needs the ready calculated data.
%
% input     time        vector [n x 1] time in s
%           phi         interpolated phi vector
%           mat         matrix [n x 64] n sample, 64 channels (2pi)
%           fs          (optional) font size
%           labelsonoff switch labels on or off (0 off, 1 on)
%           zebra_colorbar 0: colorbar off 1: colorbar on
%
% EXAMPLE: ... cou_subplotzebra_load_data(time, phi, mat, fs, labelsonoff,
% zebra_colorbar)

   if nargin < 6
       zebra_colorbar= 1;
   end
   if nargin < 5
       labelsonoff= 1;
   end
   if nargin < 4
       fs= 18;
   end

   
   %plot couronne
   %clf()
   colormap(pastell);      
   pcolor(time, phi, mat);
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
        yh= ylabel('\phi /\pi', 'Fontsize', fs+4);
        y_pos= get(yh, 'position');
        dt = time(end) - time(1);
        y_pos= [dt, y_pos(2:3)] .* [-0.02, 1, 1] + [y_pos(1), 0, 0];
        set(yh, 'position', y_pos);
       
%    %----------------------------------------------colormap
%    our_colorbar('norm. density', fs, 0.2);
%    %  colormap(pastell(128));       

        colmin =-2.5; colmax = 2.5;
        caxis([colmin colmax]);        
    if zebra_colorbar==1
        % create a good colorbar
%         c=your_colorbar(0.97, 0.99, 0.2, '', 12);
%         set(c, 'yticklabel', {'-1', ' 0', ' 1'});   
        c=our_colorbar('\delta n /a.u.', 12, 1.2);
        set(c, 'ylim', [-1 1]);           
    end;
   end;

end