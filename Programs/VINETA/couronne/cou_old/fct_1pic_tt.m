function [] = fct_1pic_tt(tx, ty, limy, lbl, fs, ff)
%function [] = fct_1pic_tt(tx, ty, limy, lbl, fs, ff)
%
% Plots the time trace of a couronne measurement.
%
% m-files NEEDED:   cou_subplot_fft64
%                   fct_dirfinder
%                   save_pic
%
% input tx          time axis
%       ty          amplitude
%       limy        [limy1 limy2]
%       lbl         0 off, 1 on
%       fs          (opt) fontsize
%       ff          (opt) fileformat: 'jpg', 'eps', 'png'
%
% output            graph, and graphic file in ff-format
%
% EXAMPLE: fct_1pic_tt(tt, fsample, [], 1, 14, 'eps');

if nargin < 6
    ff='jpg'
end;

if nargin < 5
    fs=12
end;


% +++ MAIN +++
    set(gcf,'PaperUnits','centimeters','PaperType','a4letter',...
        'PaperPosition',[1 200 32 8]);

%-- make pictures look the same on printer and on screen
    wysiwyg;

% calculate in tx ms    
    tx=tx*1000;
% plot timetrace    
    axes('Position', [0.08 0.15 0.88 0.77]);
    plot(tx, ty, 'k');
    if lbl == 1
        xlabel('time /ms', 'FontSize', fs+2);
        ylabel('voltage /V', 'FontSize', fs+2);
        set(gca, 'FontSize', fs);
    end;
    
    % set the limits
    if isempty(limy)
        max_ty = max(abs(ty));
        ylim([-max_ty max_ty]);
    else
        ylim(limy);
    end;
    xlim([tx(1) tx(end)]);    
        
    % find out wether a file of this type already exists
    [num, ndg] = find_lastfile('tt', ff);
    % create now a filename
    fn = my_filename(num, ndg, 'tt', '');
    % save picture
    save_pic([0], ff, 300, fn);
    
% +++ END MAIN +++
end