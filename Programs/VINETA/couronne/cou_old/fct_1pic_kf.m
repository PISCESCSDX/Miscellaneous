function [] = fct_1pic_kf(num, labelonoff, ff, fs)
%function [] = fct_1pic_kf(num, labelonoff, ff, fs)
%
% Plots the kf-spectrum of a couronne measurement.
%
% m-files NEEDED:   cou_subplotzebra_load_data
%                   fct_dirfinder
%
% input num         which measurement should be taken...from the mat-file
%       labelonoff  0 off, 1 on
%       ff          fileformat: 'jpg' or 'eps' or 'png'
%       fs          fontsize
%
% output            jpg- or eps-file of the plot
%
% EXAMPLE: fct_1pic_kf(1, 1, 'eps', 12)

if nargin<3
    ff='jpg'
end;

if nargin<4
    fs=12
end;

% load calculation file
    load fft_kf_calc.mat

set(gcf,'PaperUnits','centimeters','PaperType','a4letter',...
        'PaperPosition',[1 200 14 10]);
%-- make pictures look the same on printer and on screen
wysiwyg;
%-- usual colormap used for spatiotemporal couronne pictures
%-- get relative figure positions; a(1:4) a1 xleft, a2 ybottom, 
%   a3 xwidth, a4 ywidth
% a=get(gcf, 'Position');

jj=num;
    disp(['plot kf ' num2str(jj)]);
    % zebra-plot (ca. 25s one pic (PC: 3 GHz); epsc2 133 MB)
    %======================================================================
    axes('Position', [(6/50) (8/50) (40/50) (40/50)]);
    cou_subplotkf(kf_freq, kf_mode_vec, kfspectrum{num}, 18, kfmax);
    % last row should show labels

% save picture
%==============================
[mdir cdir] = fct_dirfinder;
fname = my_filename(num, 3, [mdir cdir '_kf'], ['.' ff]);
switch ff
    case {'jpg'}
        print('-djpeg', '-r300', fname);
    case {'eps'}
        disp('print eps-file');
        print('-depsc2', fname);
    case {'png'}
        print('-dpng', '-r300', fname);
end;