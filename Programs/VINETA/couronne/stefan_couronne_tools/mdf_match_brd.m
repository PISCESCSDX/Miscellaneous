function []= mdf_match_brd(basedir)
% function []= mdf_match_brd= (basedir)
%
% looks in basedir for MDF-files which are assumed to result from 
% a 64ch measurement - 8 files with 8 channels. The modification time
% of each file is loaded from 'file_info.dat' and then the files are
% matched together based on the closest files in time. The result is
% saved in 'map_number.dat' in basedir
%
% basedir           string containing dir of *.MDF to be examined
%

    if basedir(end) ~= '/', basedir= [basedir, '/']; end

    %create / load modification time
    f= dir([basedir, 'preprocess/file_time.dat']);
    if size(f, 1)== 0
        fprintf(1, 'creating time index with mdf_save_mod_time.m\n');
        mdf_save_mod_time(basedir);
    end
    modtime= mdf_load_mod_time(basedir);
    
    %we want seconds relative to the first measurement
    modtime.time= ( modtime.time - modtime.time(1) );
    modtime.time= modtime.time .* 86400;
    
    %sort files as they were created
    [modtime.time, ind]= sort(modtime.time);
    modtime.names= modtime.names(ind, :);
    
    [index, prefs]= mdf_make_index(modtime.names);
    brd_num= size(prefs, 2);
    
    
    threshold= 5; % 5s vorher und hinterher Ruhe = eine Messung
    %dtime enthält Abstände zw. Messungen + Pause vorne und hinten
    dtime= modtime.time(2:end) - modtime.time(1:end-1);
    dtime= [threshold; dtime; threshold];
    ind_thres= [1:size(dtime,1)]';
    ind_thres= ind_thres(dtime >= threshold);
    
    %finde alle 8ter Messungen mit jeweils zwei Pausen länger
    %als threshold davor und danach
    fileorder= [];
    found= false;
    for i1= 2:size(ind_thres)
        if (ind_thres(i1) - ind_thres(i1 - 1)) == brd_num
            st= ind_thres(i1 - 1);
            en= ind_thres(i1) - 1;
            var1= index(st: en, 1)';
            [var1, ind]= sort(var1);
            part_index= index(st - 1 + ind, 2);
            fileorder= [fileorder; ...
                        part_index' - part_index(1)];
            found= true;
        else
            part_index=index(1:8,2)-index(1,2);
            fileorder= [fileorder; part_index'];
            found= true;            
        end
    end
    
    pref_names= [];
    for i2= 1:brd_num
        pref_names= [pref_names, ...
                      cell2mat(prefs(i2)), '  ' ...
                     ]; 
    end
    
    outstr= {'%% mapping of the filenumbers \n'; ...
             '%% produced by mdf_match_brd.m \n'; ...
             '%% \n'; ...
             ['%% Board        ', pref_names, '\n']; ...
             '%% ---------------------------------------------\n' ...
             };
         
% make mapping
        if found     
        make_folder([basedir, 'preprocess']);
        fid= fopen([basedir, 'preprocess/map_number.dat'], 'wt');
            for i= 1:size(outstr, 1)
                fprintf( fid, cell2mat(outstr(i)) );
            end
            fprintf(fid, ['file mapping:', strrepeat('%4d', brd_num), '\n'], ...
                    fileorder(end, :));
            fprintf(fid, '%% ---------------------------------------------\n');
            fprintf(fid, 'board mapping: 1 2 3 4 5 6 7 8\n');
            fprintf(fid, '%% ---------------------------------------------\n');
        fclose(fid);
    
        if sum(std(fileorder)) ~= 0
            fprintf(1, 'Warning: found different mappings for MDF-files\n');
        end
    else
        error('Could not find any mapping!');
    end
    
end