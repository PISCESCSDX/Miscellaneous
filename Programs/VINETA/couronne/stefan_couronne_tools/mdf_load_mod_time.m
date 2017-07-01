function [modtime]= mdf_load_mod_time(basedir)
%function mdf_load_mod_time looks up file names and
%associated modification times in 
%[basedir, 'preprocess/file_info.dat']
%works only with list of filenames with the
%same number of characters
%
%input:     basedir         string containing folder to look in 
%
%output:    modtime         structure containing fields
%                           names(string) and time (number)

   if basedir(end) ~= '/', basedir= [basedir, '/']; end
   info= [];
   fid= fopen([basedir, 'preprocess/file_time.dat']);
   while 1
     tline = fgetl(fid);
     if ~ischar(tline),   break,   end
     info= strvcat(info, tline);
   end
   fclose(fid);

   space_vec= char(32.* ones(size(info,1),1));

   %find space as delimiter and copy names and time
   %to appropriate vectors
   i= 1;
   while 1
      if info(:,i) == space_vec
         names= info(:,1:i-1);
         time = info(:,i+2:end);
         break
      else
         i= i + 1;
      end
   end

   time= datenum(time);

   modtime.names= names;
   modtime.time = time;
end