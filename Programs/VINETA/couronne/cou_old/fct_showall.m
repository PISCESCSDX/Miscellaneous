function [] = fct_showall(frame_seq, ff)

%
%function [] = fct_cball(frame_seq, ff)
%
% Plots the calculated fft-spectrum, zebra and kf-spectrum of a couronne
% measurement.
%
% m-files NEEDED:   load_raw_data
%                   cou_load_sr780
%                   cou_subplotsr780
%                   cou_subplot_fft64
%                   cou_subplotzebra_load_data
%                   cou_subplotkf
%                   print_adv
%                   
% input frame_seq   define which pictures should be shown, in which order
%                       e.g. [1 2 4] or [1 2 3 4]
%                   [] assumes no/co/counter and plots all measurements
%                       of current folder
%       ff          fileformat: 'jpg' or 'eps'
%
% output            jpg- or eps-file of the plot
%
% EXAMPLE:  fct_showall([1 2 3], 'eps')
%       OR  fct_showall;

% load calculation file
    load fft_kf_calc.mat

if nargin < 1
    frame_seq = [];
end;

if isempty(frame_seq)
    im = size(fft_ampl, 2)/3;
else
    im = 1;
end;

if nargin<2
    ff='eps'
end;

    
% ** set fft-plot limits
    yfft=[fftlimits(1) fftlimits(2)];

% avoid aliasing effects
    set(gcf, 'Renderer', 'painters');
% fontsize of all axis
    fs=12;

    
if isempty(frame_seq)
    vall = 1;
else
    vall = 0;
end;
    
for ipic = 1:im;
    if vall == 1
        frame_seq = (ipic-1)*3.+[1 2 3];
    end;
    pics_y=size(frame_seq, 2);
    %-- define size of figure
    set(gcf,'PaperUnits','centimeters','PaperType','a4letter',...
            'PaperPosition',[1 200 22 4.25*pics_y]);
    %-- make pictures look the same on printer and on screen
    wysiwyg;
    %-- usual colormap used for spatiotemporal couronne pictures
    colormap pastell;
    %-- get relative figure positions; a(1:4) a1 xleft, a2 ybottom, 
    %   a3 xwidth, a4 ywidth
    % a=get(gcf, 'Position');

    for i=1:pics_y
        jj=frame_seq(i);
        % fft-spectrum
        %======================================================================
        disp(['plot fft-spectrum ' num2str(i)]);
        axes('Position', [4/50 ((pics_y-i)/pics_y+(i+1)/50) (1/3-4/50) (1/pics_y-3/50)]);
        %-- show fft from couronne data or sr780-spectrum?
        % *10 because: signal is reduced to 1/10 in the couronne-box
        cou_subplot_fft64(fft_freq{jj}, fft_ampl{jj}, fs, xfft, yfft);
        set(gca,'ytick',(fftlimits(1)+10:fftlimits(3):fftlimits(2)-10));
        %-- last row should show labels
        if i<pics_y        
            set(gca,'xtick',[0 5 10 15 20]);
            set(gca,'XTickLabel',{'';'';''});
            xlabel('');
        else
            %-- show ticks but no labels
            set(gca,'xtick',[0 5 10 15 20]);
            set(gca,'XTickLabel',{'0';'';'10';'';'20'});
            xlabel('f /kHz');
        end;

        disp(['plot zebra ' num2str(i)]);
        % zebra-plot (ca. 25s one pic (PC: 3 GHz); epsc2 133 MB)
        %======================================================================
        axes('Position', [(1/3+4/50) ((pics_y-i)/pics_y+(i+1)/50) (1/3-3/50) (1/pics_y-3/50)]);
        cou_subplotzebra_load_data(zebra_time{jj}, zebra_phi{jj}, zebra_mat{jj}, fs , 1, 0);
        %-- last row should show labels    
        if i<pics_y
            xlabel('');
    %        set(gca, 'xtick', []);
            set(gca,'XTickLabel',{'';'';'';'';''});
        end;
    end;

    for i=1:pics_y
        jj=frame_seq(i);    
        disp(['plot kf-spectra']);
        % kf-spectrum (one pic: png 0.033 MB; eps 0.033 MB)
        %======================================================================
        axes('Position', [(2/3+4/50) ((pics_y-i)/pics_y+(i+2)/50) (1/3-6/50) (1/pics_y-4/50)]);
        cou_subplotkf(kf_freq, kf_mode_vec, kfspectrum{jj}, fs, kfmax, 0);
    end; %for


    % save picture
    %==============================
    fname = my_filename(ipic, 3, 'pic_', ['.' ff]);
    switch ff
        case {'jpg'}
            print('-djpeg', '-r300', fname);
        case {'eps'}
            disp('jpeg-compression of image to eps-file: print_adv');
            % inverse order of graph creation (plots to compress - usually zebraplots:
            % 1!)
            switch pics_y
              case 1
                pic_pos=[0 1 0];
              case 2        
                pic_pos=[0 0 1 0 1 0];
              case 3
                pic_pos=[0 0 0 1 0 1 0 1 0];
              case 4
                pic_pos=[0 0 0 0 1 0 1 0 1 0 1 0];
              otherwise
                disp('Unknown method.')
            end
            % end eps is 'axes??.eps'; ??=sum(pic_pos) *** print_adv must be
            % improved: bounding box is wrong
            print_adv(pic_pos, 100, fname);
        case {'png'}
            print('-dpng', '-r300', fname);
        end; 
end; % for ip
close all; clear all;

end