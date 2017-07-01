function []= cou_monitor(basedir, tint, bad_ch)
%function []= cou_monitor_kf(basedir, tint, bad_ch)
%20070111 Ullrich, Brandt
%
% Show the spatiotemporal plot of incoming Couronne-measurements. 
% Wait automatically until 8 new mdf-files came into the directory 
% "basedir".
%
% input:    basedir     directory containing the mdf-files
%           tint(opt)   time intervall to show (amount of shown samples)
%           bad_ch(opt) 1dim vector which contains the bad channels
% output:   a spatiotemporal pcolor plot
%
% EXPAMPLE: bd=pwd;
%           cou_monitor(bd, 5000, [3 34 45:47])

    if basedir(end) ~= '\', basedir= [basedir, '\']; end
    if nargin < 3
        bad_ch = [];
    end
    if nargin < 2
        tint = 5000;
    end    
    
    files= dir([basedir, '*.MDF']);
    lauf= false;
    fprintf(1, '.');
    while 1==1
        lauf= ~lauf;
        files_cur= dir([basedir, '*.MDF']);
        newfiles= size(files_cur, 1) - size(files, 1);
        %--------------------------------check if 8 new files arrived
        if newfiles == 8
            fsize= 0;
            for i1= 0:7
                namevec{i1 + 1}= files_cur(end-i1, 1).name;
                fsize= fsize + files_cur(end-i1, 1).bytes;
            end
            % whole filesize: fsize (8 mdf-files) = bytes of first mdf-file
            eq_size= ( (fsize / 8) == files_cur(end-7).bytes );
            %-----------------------------check for equal size of files
            if eq_size
                fprintf(1, '\bload and process ...');
                [mat, tvec]= cou_moni_loadmdf(basedir, namevec, tint);
                figure(1)
                set(gcf, 'position', [010 525 560 420])
                cou_moni_zebraplot(mat, tvec, bad_ch);
                drawnow;
                files = files_cur;
                fprintf(1, ' \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
            end        
        end
        
        if lauf
            fprintf(1, '\b.');
        else
            fprintf(1, '\b ');
        end
        
    end
end