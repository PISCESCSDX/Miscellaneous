function []= mdf_filebundle_list(basedir)
% function []= mdf_filebundle_list(basedir)
% create list of files which belong to the same
% measurement and save it to 
% [basedir, 'preprocess/meas_filebundle.dat']
%
% basedir           string containing dir of *.MDF to be examined
%

    if basedir(end) ~= '/', basedir= [basedir, '/']; end
    
    % loading/creating file matching
    f= dir([basedir, 'preprocess/map_number.dat']);
    if size(f, 1)== 0
        fprintf(1, ['creating preprocess/map_number.dat', ...
                   ' with mdf_match_brd.m\n']);
        mdf_match_brd(basedir);
    end
    [ln, ln_string]= find_ascii_token(...
                      [basedir, 'preprocess/map_number.dat'], ...
                      'file mapping: ' );
    fileorder= sscanf(ln_string, strrepeat('%d', 8));
    [ln, ln_string]= find_ascii_token(...
                      [basedir, 'preprocess/map_number.dat'], ...
                      'board mapping: ' );
    brd_order= sscanf(ln_string, strrepeat('%d', 8));
    
    % loading namevec, creating index
    modtime= mdf_load_mod_time(basedir);
    namevec= modtime.names;
    index= mdf_make_index(namevec);
    
    %generate list
    list_8brd= NaN(1,9);
       % content: ch1_nr  lfd_nr  lfd_nr  ...
    fprintf(1, '                ');
    for i= 1: size(index, 1)
        fprintf(1, ['\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b', ...
                    'file ', num2str(i, '%05d'), ...
                        '/', num2str(size(index, 1), '%05d')]);
        row_ch1= index(i, 2) - fileorder(index(i,1));
        list_8brd_ind= list_8brd(:, 1) == row_ch1;
        if any(list_8brd_ind)
           list_8brd(list_8brd_ind, index(i, 1) + 1) = i;
        else
           list_8brd= [list_8brd; NaN(1, 9)];
           list_8brd(end,  index(i, 1) + 1) = i;
           list_8brd(end, 1)= row_ch1;
        end
    end
    list_8brd= list_8brd(2:end, :);
    [a, sort_ind]= sort(list_8brd(:, 1));
    list_8brd= list_8brd(sort_ind, :);
    fprintf(1, '\n');
    
    
    %save list
    fid= fopen([basedir, 'preprocess/filebundle.dat'], 'wt');
    brd_vec= ['    name_brd1'; ...
              '    name_brd2'; ...
              '    name_brd3'; ...
              '    name_brd4'; ...
              '    name_brd5'; ...
              '    name_brd6'; ...
              '    name_brd7'; ...
              '    name_brd8'...
              ];
    fprintf(fid, '%% created by mdf_filebundle_list.m\n');
    fprintf(fid, ['%%', strrepeat('-', 134), '\n']);
    fprintf(fid, ['%% num_brd1         time_brd1', ...
                 reshape(brd_vec(brd_order, :)', 1, 104), '\n'] ...
            );
    fprintf(fid, ['%%', strrepeat('-', 134), '\n']);
       for i= 1:size(list_8brd, 1)
           % get time
           red_line= list_8brd(i ,[false, ~isnan(list_8brd(i, 2:end))]);
           time= modtime.time(red_line(1));
           
           fprintf(fid, '%6d', list_8brd(i, 1));
           fprintf(fid, '  %s   ', datestr(time, 'dd.mmm yyyy HH:MM:SS'));
           
           % print filenames of one measurement
           for i2= 1:size(list_8brd, 2) - 1
               name_ind= list_8brd(i,brd_order(i2) + 1);
               if isnan(name_ind)
                   fprintf(fid, '      []     ');
               else
                   fprintf(fid, ' %s', modtime.names(name_ind,:));
               end
           end
           
           fprintf(fid, ' \n');
           
       end
    fclose(fid);
    
end