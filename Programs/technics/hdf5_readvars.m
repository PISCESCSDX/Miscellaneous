function []= hdf5_readvars(fname, showtf)
%
% This function reads all variables in fname and 
% creates them in the workspace of the caller
%
  
    if nargin < 2, showtf= false; end    
 
    evalin('caller', 'global uebergabe_hdf5read;')
    global uebergabe_hdf5read

     
    %------------------------------------look in file
    info = hdf5info(fname);
    grp_str= info.GroupHierarchy.Groups(1);
    grp_name= grp_str.Name;
    dsn_ind = size(grp_name, 2) + 2;
    varnum= size(grp_str.Datasets, 2);
    
    %------------------------------------load all vars
    for i1= 1: varnum
        varname= grp_str.Datasets(i1).Name(1, dsn_ind:end);
        space_pos= strfind(varname, ' ');
        if space_pos
           varname= varname(1:(space_pos - 1));
        end
        content= hdf5read(grp_str.Datasets(i1));
        
        %---------------------------------type casting
        if strcmp(class(content), 'hdf5.h5string')
            uebergabe_hdf5read= content.Data;
        else
            uebergabe_hdf5read= content;
        end
        
        %---------------------rotate vectors if needed
        if strfind(varname, '_h5standing#')
            uebergabe_hdf5read= uebergabe_hdf5read';
            varname= varname(1:(end-12));
        end
        if strfind(varname, '_h5lying####')
            varname= varname(1:(end-12));
        end

        %-----------------------------------monitoring
        if showtf
            fprintf(1, '%15s  ', varname);
            fprintf(1, ['size: [', ...
                        num2str(size(uebergabe_hdf5read), '%02d x %02d'),...
                        ']\n' ]);
        end
        
        %-----------------transfer to callers workspace
        evalin('caller', [varname, '= uebergabe_hdf5read;']);
        uebergabe_hdf5read= [];
        
    end

    clear global uebergabe_hdf5read
    
end