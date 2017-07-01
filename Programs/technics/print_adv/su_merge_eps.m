function [] = cb_merge_eps(epsfile, jpegepsname, endepsfile_name, axnum)
%function [] = cb_merge_eps(epsfile, jpegepsname, endepsfile_name, axnum)
% merge the generated postscript output of empty axes and
% matrix (as raster image) and save the resulting eps
% as filename
%
% input     epsfile     name of the resulting eps-file
%           jpegepsname jpeg_eps_filename
%           endepsfile_name name of the resulting epsfile
%           axnum       number of axis where to put the jpegeps into
% output    merged eps-file

    %axnum= axnum + 1;

% read the empty axes and look for dimensions
   fid1 = fopen(epsfile, 'rt'); 
   lnr = 0;
   lines_0sg=[];
   lines_translate= [];

   %------------------------------------read line after line while
   while feof(fid1) == 0
      tline = fgetl(fid1);
      lnr= lnr + 1;
      text(lnr).line= tline;
   end
   
   %----------------------------------look for keys and check them
   for i1= 1:lnr
      tline= text(i1).line;
      matches = findstr(tline, '0 sg');
      if ~isempty(matches)
          line_list= [min(i1+1,lnr):min(i1+8,lnr)];
          for i2= 1:length(line_list);
              tst_line= text(line_list(i2)).line;
              if length(tst_line) >= 3
                  test_chars(i2)= tst_line(3);
              else
                  test_chars(i2)= 'z';
              end
          end
          if all(ismember(test_chars, '1234567890')) && ...
             length(test_chars)==8
              lines_0sg= [lines_0sg, i1];
          end
      end

   end
   fclose(fid1); 
   
% begin with the biggest lines_0sg than the upper position stays the same
   str= text(lines_0sg(axnum)+ 1).line;
   line_down= sscanf(str, '%d %d mt %d %d L');
  
   str= text(lines_0sg(axnum)+ 2).line;
   line_up= sscanf(str, '%d %d mt %d %d L');
   
   delta_pic(1)= ( line_down(1) );
   delta_pic(2)= ( line_down(2) );
   scale_pic(1)= ( line_down(3) - line_down(1) );
   scale_pic(2)= ( line_up(2)   - line_down(2) );
   %-----------------------------------------end of read in axes
   
   
   
   %-- read image file
   
   fid2 = fopen(jpegepsname, 'rt'); 
   
   lnr = 0;
   lines_save= [];
   lines_translate=[];
   lines_showpage= [];
   while feof(fid2) == 0
      tline = fgetl(fid2);
      lnr= lnr + 1;
      text_mat(lnr).line= tline;

      %look for save
      matches = findstr(tline, 'save');
      if ~isempty(matches)
          lines_save= [lines_save, lnr];
      end
      
      %look for translate
      matches = findstr(tline, 'translate');
      if ~isempty(matches)
          lines_translate= [lines_translate, lnr];
      end
      
      %look for showpage
      matches = findstr(tline, 'showpage');
      if ~isempty(matches)
          lines_showpage= [lines_showpage, lnr];
      end

   end
   fclose(fid2);
   
   text_mat(lines_translate(1)    ).line = ...
      sprintf('%.3f %.3f translate', delta_pic);

   text_mat(lines_translate(1) + 1).line = ...
      sprintf('%.3f %.3f scale', scale_pic);
  
   for i= lines_showpage(2) - 2: lines_showpage(2)
       text_mat(i).line= ['% ', text_mat(i).line];
   end
   %-----------------------------------end of read in image file
   
   
   %--------------------------------------write destination file
   fid3 = fopen(endepsfile_name, 'wt');
   for i= 1:lines_0sg(axnum)-1
       fprintf(fid3, '%s\n', text(i).line );
   end
   for i= lines_save(1):size(text_mat,2) - 1
       fprintf(fid3, '%s\n', text_mat(i).line );
   end
   for i= lines_0sg(axnum): size(text, 2)
       fprintf(fid3, '%s\n', text(i).line );
   end
   fclose(fid3);

end