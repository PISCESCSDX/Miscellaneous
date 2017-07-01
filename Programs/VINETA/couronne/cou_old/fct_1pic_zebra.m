function [] = fct_1pic_zebra(num, labelsonoff, ff, fs, cbonoff)
%function [] = fct_1pic_zebra(num, labelsonoff, ff, fs, cbonoff)
%
% Zebra-plot of a couronne measurement.
%
% m-files NEEDED:   cou_subplotzebra_load_data
%                   fct_dirfinder
%                   save_pic
%
% input num         which measurement should be taken...from the mat-file
%       labelonoff  0 off, 1 on
%       ff          fileformat: 'jpg' or 'eps' or 'png'
%       fs          fontsize
%       cbonoff     colorbar on/off
%
% output            jpg- or eps-file of the plot
%
% EXAMPLE: fct_1pic_zebra(1, 1, 'eps', 18, 0)

if nargin<3
    ff='jpg'
end;

if nargin<4
    fs=12
end;

% load calculation file
    load fft_kf_calc.mat

set(gcf,'PaperUnits','centimeters','PaperType','a4letter',...
        'PaperPosition',[1 200 14 8]);
%-- make pictures look the same on printer and on screen
wysiwyg;

%-- usual colormap used for spatiotemporal couronne pictures
    colormap pastell;
%-- get relative figure positions; a(1:4) a1 xleft, a2 ybottom, 
%   a3 xwidth, a4 ywidth
% a=get(gcf, 'Position');

jj=num;
    disp(['plot zebra ' num2str(i)]);
    % zebra-plot (ca. 25s one pic (PC: 3 GHz); epsc2 133 MB)
    %======================================================================
%    axes('Position', [(1/3+4/50) ((pics_y-i)/pics_y+(i+1)/50) (1/3-3/50) (1/pics_y-3/50)]);
%        cou_subplotzebra(zebra_mat{jj}, zebra_time{jj}, 30000, 2500, fs, ...
%        labelonoff, cbonoff)

     cou_subplotzebra_load_data(zebra_time{jj}, zebra_phi{jj}, ...
         zebra_mat{jj}, fs, labelsonoff, cbonoff);

% save picture
[mdir cdir] = fct_dirfinder;
fname = my_filename(num, 3, [mdir cdir '_zebra'], ['.' ff]);
save_pic([1], ff, 300, fname);

% +++ END MAIN +++
end