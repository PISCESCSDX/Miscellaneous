function [] = cb_merge_eps(epsfile, jpegepsname, endepsfile_name, ...
  axnum, epsname, pic_pos)
%==========================================================================
%function [] = cb_merge_eps(epsfile, jpegepsname, endepsfile_name, axnum)
%--------------------------------------------------------------------------
% Merges the generated postscript output of axes*.eps and
% matrix (as raster image) and save the resulting eps
% as 'endepsfile_name'.
%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------
% input     epsfile     name of the resulting eps-file
%           jpegepsname jpeg_eps_filename
%           endepsfile_name name of the resulting epsfile
%           axnum       number of axis where to put the jpegeps into
% output    merged eps-file
%--------------------------------------------------------------------------
% last change: on Linux, picture does not need to be flipped, 11.03.2011
% last change: flip ImageMatrix to have non flipped pic, 01.03.2011 Brandt
% last change: 1.2 look for "stroke", 08.09.2008 Brandt
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ "axes*.eps" and look for axes dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid1 = fopen(epsfile, 'rt');
lnr = 0;
lines_1sg =[];
lines_0sg =[];
lines_translate = [];

lines_6w =[];
lines_stroke =[];
lines_PP =[];

%==================================================
% Test on which operating system matlab is running
%==================================================
compinfo = computer;

c_windows = [];
c_linux = strfind(compinfo, 'LNX');
if ~isempty(c_linux)
  slstr = '/';
else
  c_windows = strfind(compinfo, 'WIN');
  if ~isempty(c_windows)
    slstr = '\';    
  else
    error('Can not detect the operating system!')
  end
end
%==================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.1 LOOKING FOR KEYS "1 sg" and "0 sg"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while feof(fid1) == 0
  tline = fgetl(fid1);
  
  disp(tline)
  
  lnr = lnr + 1;
  text(lnr).line = tline;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "1 sg"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '1 sg');
  if ~isempty(matches)
    lines_1sg= [lines_1sg, lnr];
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "0 sg"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '0 sg');
  if ~isempty(matches)
    lines_0sg = [lines_0sg, lnr];
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "Title"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, ['Title: .' slstr]);
  if ~isempty(matches)
    lines_title = lnr;
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "6 w"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '6 w');
  if ~isempty(matches)
    lines_6w = [lines_6w, lnr];
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "stroke"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, 'stroke');
  if ~isempty(matches)
    lines_stroke = [lines_stroke, lnr];
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "PP"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, 'PP');
  if ~isempty(matches)
    lines_PP = [lines_PP, lnr];
  end

end
fclose(fid1); 

% figure
% hold on
%   plot(lines_stroke, 1:length(lines_stroke), 'bo')
%   plot(lines_6w, 1:length(lines_6w), 'ro')
%   plot(lines_1sg, 1:length(lines_1sg), 'ko')
%   plot(lines_0sg, 1:length(lines_0sg), 'mx')
% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USE lines_6w as KEY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lines_0sg = [];

% newl = [];
% for j=1:length(lines_6w(2:end))
%   i_0 = find( lines_1sg<lines_6w(j+1) );
%   newl = [newl lines_1sg( i_0(end) )];
% end
% 
% lines_0sg = newl;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USE lines_PP as KEY: 'PP' AND at the end in previous line 'MP'
% .... MP
% PP
% ... stroke
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lines_0sg = []; ctr = 0;
for j=1:length(lines_PP)
  str = text( lines_PP(j)-1 ).line;
  k = strfind(str, 'MP');
  % 
  if k==length(str)-1
    str = text( lines_PP(j)+1 ).line;
    k = strfind(str, 'stroke');
      if k==length(str)-5
        ctr = ctr + 1;
        lines_0sg(ctr) = lines_PP(j)+2;
      end
  end
end

if length(pic_pos) ~= length(lines_0sg)
  disp('WARNING: length pic_pos not equal with lines_0sg (# axes)');
end


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
lines_ImageMatrix= [];
while feof(fid2) == 0
  tline = fgetl(fid2);
  lnr= lnr + 1;
  text_mat(lnr).line= tline;

  %look for "ImageMatrix"
  matches = findstr(tline, 'ImageMatrix');
  if ~isempty(matches)
      lines_ImageMatrix = [lines_ImageMatrix, lnr];
  end
  
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
   

% Flip jpeg data upside down (otherwise it is wong up down)
if ~isempty(c_windows)
  T = text_mat(lines_ImageMatrix(1)).line;
  T1 = findstr(T,'[');
  T2 = findstr(T,']');
  TN = str2num(T(T1:T2)); %#ok<ST2NM>
    TN(4) = TN(4)*(-1);
    TN(6) = 0;
  T = [T(1:T1-1) '[ ' num2str(TN) ' ]'];
  text_mat(lines_ImageMatrix(1)).line = T;
end

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
      fprintf(fid3, '%s\n', ['%%Title: .' slstr epsname] );
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