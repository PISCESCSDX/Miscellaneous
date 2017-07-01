function mdfzipLenz();
%function mdfzipLenz();
% 20070814 C.Brandt: Puts 2 MDF-files together to one AND deletes the
% single MDF-files.
%
% NEEDS:    mdflistLenz, my_filename, disp_num
% input     
% output       
%
% EXAMPLE: mdfzipLenz;

[fn em es] = mdflistLenz;

if es == 1
    error('In the current folder is something wrong with the mdf-clusters.');
end;

% get numbers of saved cards
  cnum = size(fn, 1);
% get number of plasma-shots
  mnum = size(fn, 2);

% count the number of all saved channels
allch = 0;
for j=1:cnum
  fnum=1; % read only the first files
  fname = cell2mat(fn(j,fnum));
  fid = fopen(fname);
  % MDF-Header
  file_type = fread(fid,11,'char');
  channel_saved = fread(fid,1,'char');
  allch = allch + channel_saved;
  fclose(fid);
end;
  

% MAIN PROCEDURE: read old mdf-files ==> write it to one mdf-file "mdffile"
for fnum=1:mnum
%   display count number
    disp_num(fnum, mnum);

    mdffile = my_filename(fnum, 4, 'Len', '.MDF');
    fw = fopen(mdffile, 'w');



    for j=1:cnum      
        fname = cell2mat(fn(j,fnum));

        fid = fopen(fname);

        % MDF-Header
        file_type = fread(fid,11,'char');
        channel_saved = fread(fid,1,'char');

        % Write the header, neglect the rest
        if j==1
          fwrite(fw, file_type, 'char');
          % the "one" mdf-file should contain all saved channels "allch"
          fwrite(fw, allch, 'char');
        end;


        for i=1:channel_saved
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