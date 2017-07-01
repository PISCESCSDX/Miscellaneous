function []= mdf_plot_allzebras(basedir)
% function []= mdf_plot_allzebras(basedir)
%
% loads all measurements in basedir, plots a
% zebra-diagram and saves it (with print_adv)
% under [basedir, 'diag/zebra_MDFxxxxxx_datetime.eps']
%
% input        basedir          string containing dir to act on
%
 
    if basedir(end) ~= '/', basedir= [basedir, '/']; end
    [a, timevec, idx_vec]= mdf_load_filebundle_list(basedir);
    
    make_folder([basedir, '/diag']);
    
    fprintf(1, '              ');
    for i= 53:size(idx_vec, 1)
        
        fprintf(1, ['\b\b\b\b\b\b\b\b\b\b\b\b\b\b', ...
                    'file ', num2str(i, '%04d'), ...
                        '/', num2str(size(idx_vec, 1), '%04d')]);

        [mat, time]= mdf_load_64ch(basedir, idx_vec(i));
        cou_zebraplot(mat, time);
        epsname= [basedir, '/diag/zebra_MDF', ...
                  num2str(idx_vec(i), '%06d'), '_', ...
                  datestr(timevec(i), 'ddmmmyy_HHMMSS'), ...
                  '.eps'];
        print_adv(epsname, 30);
    end
    fprintf(1, '\n');


end