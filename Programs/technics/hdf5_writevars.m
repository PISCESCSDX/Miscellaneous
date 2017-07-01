function []= hdf5_writevars(fname, varargin)
%function []= hdf5_writevars(filename, var1, var2, ... )
%
% this function writes all given vars to the specified file
% naming them with their orignal names
%

    if nargin== 0
        help hdf5_writevars;
        return;
    end

    %----------------------------modify filename to .h5
    ppos= strfind(fname, '.');
    if size(ppos) == [0,0]
        ppos= size(fname + 1);
    end
    fname= [fname(1:ppos-1), '.h5'];
    
    %-----------------------------loop for writing vars
    wm= 'overwrite';
    var_runnum= 1;
    %varnum= size(varargin, 2) - 1;
    varnum= size(varargin, 2);
    for i1= 1: varnum

        dset= varargin{i1};
        name= inputname(i1 + 1);
        if size(dset, 1) == 1
            name= [name, '_h5lying####'];
        end
        if size(dset, 2) == 1
            name= [name, '_h5standing#'];
        end
        
        if strcmp(name, '')
            name= ['var', num2str(var_runnum)];
            varnum= var_runnum + 1;
        end
        dset_details.Location = ['/matlab'];
        dset_details.Name = name;

        hdf5write(fname, dset_details, dset, ...
                  'WriteMode', wm);
        wm= 'append';
    end
end