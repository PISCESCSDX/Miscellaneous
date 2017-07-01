function [] = fct_1pic_fft(num, lbl, ff, fs, cb)
%function [] = fct_1pic_fft(num, lbl, ff, fs, cb)
%
% Plots the fft-spectrum of a couronne measurement.
%
% m-files NEEDED:   cou_subplot_fft64
%                   fct_dirfinder
%
% input num         which measurement should be taken...from the mat-file
%       lbl         0 off, 1 on
%       ff          fileformat: 'jpg' or 'eps' or 'png'
%       fs          fontsize
%       cb          colorbar on/off
%
% output            jpg- or eps-file of the plot
%
% EXAMPLE: fct_1pic_fft(1, 1, 'eps', 16, 0)

if nargin<3
    ff='jpg'
end;

if nargin<4
    fs=12
end;

% load fft_kf_calc.mat
    load fft_kf_calc.mat

set(gcf,'PaperUnits','centimeters','PaperType','a4letter',...
        'PaperPosition',[1 200 14 8]);

%-- make pictures look the same on printer and on screen
    wysiwyg;

%-- usual colormap used for spatiotemporal couronne pictures
    colormap pastell;

jj=num;
    disp(['plot fft ' num2str(i)]);
    cou_subplot_fft64(fft_freq{jj}, fft_ampl{jj}, fs, xfft, [-160 10]);

% save picture
%==============================
[mdir cdir] = fct_dirfinder;
fname = my_filename(num, 3, [mdir cdir '_fft64'], ['.' ff]);
switch ff
    case {'jpg'}
        print('-djpeg', '-r300', fname);
    case {'eps'}
        disp('print eps-file');
        print('-depsc2', fname);
    case {'png'}
        print('-dpng', '-r300', fname);
end;