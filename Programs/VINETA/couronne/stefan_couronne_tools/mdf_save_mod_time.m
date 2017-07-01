function []= mdf_save_mod_time(basedir)
% mdf_modfication_time generates a list of files in basedir
% together with the accociated modification time
%
% usage:
% mdf_save_mod_time(pwd)      (for current dir)
%
   if basedir(end) ~= '/', basedir= [basedir, '/']; end
   info= dir([basedir,'*.MDF']);
   
   name_vec= [];
   date_vec= [];
   delimiter_vec= char(32.*ones(size(info,1),3));
   fprintf(1, '                  ');
   for i= 1:size(info,1)
       fprintf(1, ['\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b', ...
                   'file ', num2str(i, '%06d'), ...
                   '/', num2str(size(info, 1), '%06d')]);

       name_vec= strvcat(name_vec, info(i).name);
       date_vec= strvcat(date_vec, ...
                 datestr(info(i).date, 'dd-mmm-yyyy HH:MM:SS.FFF'));
   end
   fprintf(1, '\n');   
   result= [name_vec, delimiter_vec, date_vec];
   make_folder([basedir, 'preprocess']);
   filename= [basedir, 'preprocess/file_time.dat'];
   dlmwrite(filename, result, '');
  
end