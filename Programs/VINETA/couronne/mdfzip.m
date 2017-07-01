function mdfzip
%==========================================================================
%function mdfzip
%--------------------------------------------------------------------------
% 20070213 C.Brandt: Puts 8 MDF-files together to one AND deletes the
% single MDF-files.
%--------------------------------------------------------------------------
% EXAMPLE: mdfzip
%==========================================================================

[fn , ~, es] = mdflist;

if es == 1
    error('In the current folder is something wrong with the mdf-clusters.');
end;

mnum = size(fn, 2);

for fnum=1:mnum
%   display count number
    disp_num(fnum, mnum);

    mdffile = mkstring('cou', '0', fnum, 9999, '.mdf');
    fw = fopen(mdffile, 'w');

    for j=1:8   % 8 cards
        fname = cell2mat(fn(j,fnum));

        fid = fopen(fname);

        % MDF-Header
        file_type = fread(fid,11,'char');
        channel_saved = fread(fid,1,'char');

        % Write the header, neglect the rest
        if j==1
          fwrite(fw, file_type, 'char');
          % the new mdf-file contains all 64 channels!  
          fwrite(fw, 64, 'char');
        end;


        for i=1:8   % 8 channels
            identifier_version = fread(fid,16,'uchar');
            fwrite(fw, identifier_version, 'uchar');

            board_type = fread(fid,1,'ushort');
            fwrite(fw, board_type, 'ushort');

            data_type = fread(fid,1,'ushort');
            fwrite(fw, data_type, 'ushort');

            coupling_type = fread(fid,1,'ushort');
            fwrite(fw, coupling_type, 'ushort');

            trigger_channel = fread(fid,1,'uchar');
            fwrite(fw, trigger_channel, 'uchar');

            master_clock = fread(fid,1,'uchar');
            fwrite(fw, master_clock, 'uchar');

            X_min = fread(fid,1,'long');	%in units of points
            fwrite(fw, X_min, 'long');

            X_max = fread(fid,1,'long');	%in units of points
            fwrite(fw, X_max, 'long');

            X_step = fread(fid,1,'double');
            fwrite(fw, X_step, 'double');

            X_unit = fread(fid,8,'uchar');
            fwrite(fw, X_unit, 'uchar');

            Y_min = fread(fid,1,'long');
            fwrite(fw, Y_min, 'long');

            Y_max = fread(fid,1,'long');
            fwrite(fw, Y_max, 'long');

            Y_step = fread(fid,1,'double');
            fwrite(fw, Y_step, 'double');

            Y_unit = fread(fid,8,'uchar');
            fwrite(fw, Y_unit, 'uchar');

            uplevel = fread(fid,1,'ushort');
            fwrite(fw, uplevel, 'ushort');

            lolevel = fread(fid,1,'ushort');
            fwrite(fw, lolevel, 'ushort');

            counter = fread(fid,1,'ushort');
            fwrite(fw, counter, 'ushort');

            trigger_mode = fread(fid,1,'ushort');
            fwrite(fw, trigger_mode, 'ushort');

            trigger_switch = fread(fid,1,'ushort');
            fwrite(fw, trigger_switch, 'ushort');

            flags = fread(fid,1,'ushort');
            fwrite(fw, flags, 'ushort');

            bus_config = fread(fid,1,'ulong');
            fwrite(fw, bus_config, 'ulong');

            time_slow = fread(fid,1,'ulong');
            fwrite(fw, time_slow, 'ulong');

            time_fast = fread(fid,1,'ulong');
            fwrite(fw, time_fast, 'ulong');

            averages = fread(fid,1,'ulong');
            fwrite(fw, averages, 'ulong');

            comment_present = fread(fid,1,'ulong');
            fwrite(fw, comment_present, 'ulong');

            comment_length = fread(fid,1,'ulong');
            fwrite(fw, comment_length, 'ulong');

            number_of_segments = fread(fid,1,'ulong');
            fwrite(fw, number_of_segments, 'ulong');

            upmask = fread(fid,1,'ushort');
            fwrite(fw, upmask, 'ushort');

            lomask = fread(fid,1,'ushort');
            fwrite(fw, lomask, 'ushort');

            reserved = fread(fid,8,'char');
            fwrite(fw, reserved, 'char');

            data_raw = fread(fid,X_max-X_min+1,'int16');
            fwrite(fw, data_raw, 'int16');

            comment = fread(fid,comment_length,'char');
            fwrite(fw, comment, 'char');
        end;
        fclose(fid);
        
        delete(fname);
    end;
    fclose(fw);
end;

end