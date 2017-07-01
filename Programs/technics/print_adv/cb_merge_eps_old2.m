function [] = cb_merge_eps(epsfile, jpegepsname, endepsfile_name, ...
  axnum, epsname, pic_pos)
%function [] = cb_merge_eps(epsfile, jpegepsname, endepsfile_name, axnum)
% Merges the generated postscript output of axes*.eps and
% matrix (as raster image) and save the resulting eps
% as filename.
% Procedure:
% 1   Find the position of all axes in the eps-file, and decide where to
%     put the raster-image (jpeg) data.
% 1.1 An axes always starts with "1 sg" and some lines later "0 sg". 
%     This procedure is only a few times tested.
%     Look for axes keys in the eps-file. "1 sg" followed some lines later
%     by "0 sg" is a hint for a axes. But it can also be someting different
%     like a position of a string.
% 1.2 Test all axis candidates if it is an axis.
%     This procedure is only a few times tested. So far it worked.
%     Up to now: In comparison to a text-box, an axes always(?) contains 
%     the word "stroke" between the keys "1 sg" and "0 sg".
%     So --> search for all "1 sg"-"0 sg" which contain the word stroke.
%
% input     epsfile     name of the resulting eps-file
%           jpegepsname jpeg_eps_filename
%           endepsfile_name name of the resulting epsfile
%           axnum       number of axis where to put the jpegeps into
% output    merged eps-file
%
% last change: 1.2 look for "stroke", 08.09.2008 Brandt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ "axes*.eps" and look for axes dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid1 = fopen(epsfile, 'rt'); 
lnr = 0;
lines_1sg =[];
lines_0sg =[];
lines_translate = [];

lines_6w =[];
lines_60w =[];
lines_stroke =[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.1 LOOKING FOR KEYS "1 sg" and "0 sg"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while feof(fid1) == 0
  tline = fgetl(fid1);
  lnr = lnr + 1;
  text(lnr).line = tline;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "1 sg"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '1 sg');
  if length(matches) > 0
    lines_1sg= [lines_1sg, lnr];
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "0 sg"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '0 sg');
  if length(matches) > 0
    lines_0sg = [lines_0sg, lnr];
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "Title"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, 'Title: ./');
  if length(matches) > 0
    lines_title = lnr;
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "6 w"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '6 w');
  if length(matches) > 0
    lines_6w = [lines_6w, lnr];
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "stroke"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, 'stroke');
  if length(matches) > 0
    lines_stroke = [lines_stroke, lnr];
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "stroke"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '60 w');
  if length(matches) > 0
    lines_60w = [lines_60w, lnr];
  end

end
fclose(fid1); 


% DIFFERENCE TO OLD cb-merge_eps
% NEW: PROCEDURE
% SIMPLY LOOK FOR '6 w' as a key and neglect the first value
% Anscheinend taucht der Parameter "6 w" n+1 mal auf, bei n Anzahl der
% Achsen (incl. colorbars natürlich).

% 20081020-01:11 *würg* =)
% Das hier klappte, aber Labels auf dem PColorPlot werden dahintergedruckt.
% jpg früher positionieren hinter letztem stroke half. (siehe unterhalb)
% lines_0sg = lines_6w(2:end);

for i=1:length(lines_6w)-1
  i_a = find( lines_stroke < lines_6w(i+1) );
  new0(i) = lines_stroke( i_a(end) ) + 2;
end


% % *** Sometimes this works, sometimes this:
% lines_0sg = new0;
% *** Sometimes this works, sometimes this:
lines_0sg = lines_60w;

% figure
% hold on
%   plot(lines_stroke, 1:length(lines_stroke), 'bo')
%   plot(lines_6w, 1:length(lines_6w),         'ro')
%   plot(lines_1sg, 1:length(lines_1sg),       'ko')
%   plot(lines_0sg, 1:length(lines_0sg),       'mx')
%   plot(lines_0sg, 1:length(lines_60w),       'b*')
% hold off

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 1.1.1 LOOK WHETHER KEYS "1 sg" appears as often as"0 sg"
% % INFO: added 12.09.2008 by Brandt (cause problem with overlayed pcolor,
% % quiver-plots)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % PROCEDURE A:  If "0 sg" appears more than 1 time after "1 sg", take only
% % the first one after each "1 sg"
% % BEGIN PROCEDURE A
% if length(lines_1sg)<length(lines_0sg)
%   % SEARCH for first "0 sg" after each "1 sg"
%   for r0 = 1:length(lines_1sg)
%     i0sg = find( lines_0sg>lines_1sg(r0) );
%     new_l0sg(r0) = lines_0sg( i0sg(1) );
%   end
%   % REPLACE OLD lines_0sg with new_l0sg  
%   lines_0sg = new_l0sg;
% else
%   if length(lines_1sg)>length(lines_0sg)  
%   % PROCEDURE:  If "1 sg" appears more than 1 time after "0 sg", take only
%   % the first one after each "0 sg"
%     for r0 = 1:length(lines_0sg)
%       i0sg = find( lines_0sg>lines_1sg(r0) );
%     new_l0sg(r0) = lines_0sg( i0sg(1) );
%     end
%   end
% end
% % END PROCEDURE A
% 
% % % TEST-PHASE OF PROCEDURE B INSTEAD OF A:
% % % BEGIN PROCEDURE B
% % % NEW ALGORITHM ZICK-ZACK: egal ob lines_0sg und lines_1g 
% % % gleich oder unterschiedlich: fang mit Kleinstem an, dann immer wechseln,
% % % wobei die Bedingung
% % merge_lines = mergemat(lines_1sg', lines_0sg');
% % min1 = min(lines_1sg);
% % min0 = min(lines_0sg);
% % ctr0 = 1; ctr1 = 1; new0 = []; new1 = [];
% % if min1<min0
% %   prevmin = 1;
% %   new1 = lines_1sg(ctr1);
% %   ctr1 = ctr1+1;
% % else
% %   prevmin = 0;  
% %   new0 = lines_0sg(ctr0);
% %   ctr0 = ctr0+1;
% % end
% % 
% % status = 0;
% % while status==0
% %   switch prevmin
% %   case 1
% %       a = find( lines_0sg > new1(end) );
% %       new0(ctr0) = lines_0sg( a(1) );
% %       ctr0 = ctr0 + 1;
% %       prevmin = 0;
% %       % TESTEN OB NOCH EIN GRÖßERER lines_1sg vorhanden ist
% %       b = find( lines_1sg > new0(end) );
% %       if length(b)==0
% %         status = 1;
% %       end
% %   case 0
% %       a = find( lines_1sg > new0(end) );
% %       new1(ctr1) = lines_1sg( a(1) );
% %       ctr1 = ctr1 + 1;
% %       prevmin = 1;
% %       % TESTEN OB NOCH EIN GRÖßERER lines_0sg vorhanden ist
% %       b = find( lines_0sg > new1(end) );
% %       if length(b)==0
% %         status = 1;
% %       end
% %   end
% % end
% % 
% % lines_1sg = new1;
% % lines_0sg = new0;
% % % END PROCEDURE B
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 1.2 LOOK BETWEEN THE KEYS PAIRS "1 sg"-"0 sg" for the word "stroke"
% % INFO: added 08.09.2008 by Brandt
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % lines_1sg: vector of line numbers with "1 sg"
% % lines_0sg: vector of line numbers with "0 sg"
% l1 = lines_1sg; lines_1sg = [];
% l0 = lines_0sg; lines_0sg = [];
% % FOR i: AMOUNT OF "1 sg"  (SHOULD BE EQUAL WITH "0 sg")
% new_i = 0;
% for i = 1:length(l1)
%   ctr = 0;
%   % FOR j: LINES BETWEEN "1 sg" and "0 sg"
%   for j = 1:( l0(i)-l1(i) )
%     matches = findstr( text( l1(i)+j ).line , 'stroke');
%     if length(matches) > 0
%       ctr = ctr + 1;
%     end
%   end
% %
% % IF STROKE WAS FOUND 1 TIME : TAKE THIS AS AXES: lines_1sg(i) and lines_0sg(i)
%   if ctr == 1
%     new_i = new_i + 1;
%     lines_1sg(new_i) = l1(i);
%     lines_0sg(new_i) = l0(i);
%     % IF STROKE WAS FOUND MORE THAN 1 TIME, its possibly a kf-plot
%     % KF-PLOT: USUALLY THE NEXT INTERVALS BETWEEN 1sg and 0sg
%     % correspond to the several waterfall lines in the kf-plot
%     % THEY MAY NOT CONTAIN THE WORD "STROKE"
%     % BUT TAKE AS ONE AXIS if ctr>1 !!!
%     if ctr > 1
%       new_i = new_i + 1;
%       lines_1sg(new_i) = l1(i);
%       lines_0sg(new_i) = l0(i);
%     end
%   end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% begin with the biggest lines_0sg than the upper position stays the same
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the position and width of the axis, to include here the jpg-data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this procedure made a lot of trouble
% last update 28.08.2008
% Brandt: the "key" '0 sg' is not enough, also check whether
%   the line contains the 4 numbers (therefore the while loop)
line_down = ''; ctr = 0;
while length(line_down) ~= 4
  str= text(lines_0sg(axnum)+ 1 + ctr).line;
  line_down= sscanf(str, '%d %d mt %d %d L');
  ctr = ctr+1;
end
ctr=ctr-1;

str= text(lines_0sg(axnum)+ 2 + ctr).line;
line_up= sscanf(str, '%d %d mt %d %d L');
   
delta_pic(1)= ( line_down(1) );
delta_pic(2)= ( line_down(2) );
scale_pic(1)= ( line_down(3) - line_down(1) );
scale_pic(2)= ( line_up(2)   - line_down(2) );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.1 READ IMAGE FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
  if length(matches) > 0
      lines_save= [lines_save, lnr];
  end

  %look for translate
  matches = findstr(tline, 'translate');
  if length(matches) > 0
      lines_translate= [lines_translate, lnr];
  end

  %look for showpage
  matches = findstr(tline, 'showpage');
  if length(matches) > 0
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
    % ADD CORRECT EPS-TITLE (10.09.2008)
    if i==lines_title
      fprintf(fid3, '%s\n', ['%%Title: ./' epsname] );
    else
      fprintf(fid3, '%s\n', text(i).line );
    end
  end
  for i= lines_save(1):size(text_mat,2) - 1
     fprintf(fid3, '%s\n', text_mat(i).line );
  end
  for i= lines_0sg(axnum): size(text, 2)
     fprintf(fid3, '%s\n', text(i).line );
  end
fclose(fid3);

end