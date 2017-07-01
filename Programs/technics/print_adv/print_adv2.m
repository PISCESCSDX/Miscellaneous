function print_adv2(ax_cmpr, ax_same, res, epsname, jpgquali, mergemode)
%==========================================================================
%function print_adv(ax_cmpr, ax_same, res, epsname, jpgquali, mergemode)
%--------------------------------------------------------------------------
% Generates an eps-file of the current figure. Plots can be jpg-compressed.
% The vector ax_cmpr gives the necessary information which subplots should 
% be compressed. Usually pcolor plots yield a good file-size/quality ratio.
% The advantage: the axes and any labels are still saved as vector format,
% only the color-coded background is jpg-compressed.
%--------------------------------------------------------------------------
% Installation: 
% (1) print_adv uses and needs this MatLab-external software:
%     Linux, Windows: packages "jpeg2ps", "netpbm".
%     In Windows the path variable must be set to these packages after
%     installation.
%     (i) RMB "My Computer" -> "System Properties" -> "Advanced tab" ->
%         "Environment Variables" -> highlight the "Path" variable 
%         in the Systems Variable section and click the Edit button. 
%         Add or modify the path lines with the paths you wish the 
%         computer to access. Each different directory is separated 
%         with a semicolon as shown below.
%         C:\Program Files;C:\Winnt;C:\Winnt\System32;
%         C:\Program Files (x86)\GnuWin32\bin
% (2) To avoid possible errors, plot waterfall plots at the end.
% IN CASE of ERROR:
% (1) Sometimes a MatLab-restart is was helpful.
% (2) Take a look at the amount of children.
%--------------------------------------------------------------------------
%PROBLEMS:
%   - plots with many lines may make problems
%   - use a certain colorbar (e.g. like hotflipped) may give problems, see
%     function timetrace.m, or Avsrvector.m in
%/home/cumulus/0_positions/...
%               20090201-20100615_Nancy-PostDoc_large/rawdata/20100226/11He
%--------------------------------------------------------------------------
% IN: ax_cmpr: vector containing the correct(!) order of creation
%     ax_same: vector containing in correct(!) order of creation
%              of the axis (0/1: axes plotted into same axis  n/y)
%     ax_cmpr and ax_off need to have the same number of elements
%     res [optional]: resolution in dpi (default: '-r300')
%     epsname: name of resulting pic, e.g. 'eps-file.eps'
%     jpgquali: 0..100, integer-number (default: 95);
%     mergemode: number of version of cb_merge_eps: 1: OLD, 
%               2: NEW, 3: Stefan, 4: newest (default, until now no error)
%OUT: jpeg compressed eps-file with epsname
%----------------------------------------------------------------- EXAMPLES
% (A): A plot with 2 axes, e.g., a pcolor-plot with a colorbar, whereas the
% colorbar is plottet at last. You want only compress the pcolor-plot:
%     print_adv([1 0], [0 0], '-r75', 'picture.eps', 50, 5);
% (B): A plot with 5 axes: 1. pcolor 2. colorbar 3. pcolor 4. plot(x,y)
%                          5. plot(x,y) ... only compress the pcolor:
%     print_adv([1 0 1 0 0], [0 0 0 0 0], '-r300', 'wvl_phase.eps', 50, 5);
%--------------------------------------------------------------------------
% 27.02.2011 C. Brandt: 'WIN', 'LX' options added
% S. Ullrich, C. Brandt (2007)
%==========================================================================



if nargin < 6;
  disp('print_adv2: Error: Please insert all variables!');
  return
end

if numel(ax_same)~=numel(ax_cmpr)
 disp('print_adv2: Error: ax_cmpr and ax_same must have the same length!');
  return
end


% flip ax_compr from correct order to invers order
ax_cmpr = fliplr(ax_cmpr);
ax_same = fliplr(ax_same);

%==================================================
% Test on which operating system matlab is running
%==================================================
compinfo = computer;

c_linux = strfind(compinfo, 'LNX');
if ~isempty(c_linux)
  delete_str = 'rm';
  mv_str = 'mv';
else
  c_windows = strfind(compinfo, 'WIN');
  if ~isempty(c_windows)
    delete_str = 'del';
    mv_str = 'ren';
  else
    error('Can not detect the operating system!')
  end
end
%==================================================

% +++ MAIN +++
% amount of graphs on the plot
picvec_size = size(ax_cmpr, 2);

onoff = 'off';

% GET AXES INFORMATIONS
% get handle of current figure
  fh = gcf();
% get the number of the axes in the figure
  allaxes = get(fh, 'children');
% get only all visible axes of plots
ctr=0;
for i=1:length(allaxes);
  axtype = get( allaxes(i), 'type');
  if strcmp(axtype, 'axes') 
    % 20130814 Do not count invisible axes
    ax_visible = get( allaxes(i), 'visible');
    if strcmp(ax_visible, 'on') 
      ctr = ctr+1;
      axes(ctr) = allaxes(i);
    end
  end
end
% get the amount of the axes  
axes_nr = size(axes, 2);


axes_vis=[];
% only matrix of the last axes
set(axes(end), 'visible', 'off');
% switch off all axes
for i= 1:axes_nr
  axes_vis(i).str= get(axes(i), 'visible');
  % 25.10.2010 added the following line
  % Get all the data of the current axis
  axdata{i} = get(axes(i));
  set(axes(i), 'visible', onoff);
  c1= get(axes(i), 'Children');
  set(c1, 'visible', onoff);
end

% switch on axis to export; save png; switch off axis; next axis
% c1(5) is the pcolor-plot c1(3) is the y-label
for i=1:picvec_size
  if ax_cmpr(i)==1
    axes_vis(i).str= get(axes(i), 'visible');
    c1= get(axes(i), 'Children');
    % DO NOT SWITCH ON TYPE 'TEXT'
    % CHECK c1 for type 'SURFACE'
    for j=1:length(c1)
      typech = get(c1(j), 'type');
      if strcmp(typech,'surface')
        set(c1(j), 'visible', 'on');
%         set(c1, 'visible', 'on');
      end
    end
    % print surface as png
    print('-dpng', res, ['matrix_temp' num2str(i) '.png']);
    set(c1, 'visible', 'off');
%   set(c1(5), 'visible', 'off');                          
  end
end

% switch on everything but not the exported diagrams, only their axes
for i = 1:picvec_size
  if ax_cmpr(i)==1 
    set(axes(i), 'visible', 'on');
    c1= get(axes(i), 'Children');
    for j=1:length(c1)
      typech = get(c1(j), 'type');
      if strcmp(typech,'surface')
        set(c1(j), 'visible', 'off');
%         set(c1, 'visible', 'off');
      else
        set(c1(j), 'visible', 'on');
      end
    end
  else
    set(axes(i), 'visible', 'on');
    % 25.10.2010: activate when colorbar scale makes problems
    pause(1) % I don't know why, but without the scale gets wrong
%     set(axes(i), 'Ylim', axdata{i}.YLim);
    set(axes(i), 'YTick', axdata{i}.YTick);
    c1= get(axes(i), 'Children');
    set(c1, 'visible', 'on');
    % 25.10.2010: activate when colorbar scale makes problems
%     set(c1, 'YData', axdata{i}.YLim)
  end
end   

print('-depsc2', '-painters', 'axes00.eps');

% convert matrix to jpg included in eps and
% overlay axes
ctr=0;
for i=1:picvec_size
  if ax_cmpr(i)==1
    ctr=ctr+1;
    disp(['jpg-eps-inclusion pic-nr. ' num2str(ctr) '/' num2str(sum(ax_cmpr))]);
    fname=['matrix_temp' num2str(i) '.png'];
    eval(['!pngtopnm ' fname ' | pnmcrop > matrix_c_temp.ppm']);
    eval(['!pnmtojpeg -quality=' num2str(jpgquali) ' matrix_c_temp.ppm > matrix_temp.jpg']);
    fname2=['matrix_jpeg' num2str(i) '.eps'];
    eval(['!jpeg2ps -q matrix_temp.jpg > ' fname2]);
    eval(['!' delete_str ' ' fname]);
    eval(['!' delete_str ' matrix_c_temp.ppm']);
    eval(['!' delete_str ' matrix_temp.jpg']);
  end
end


% Merge jpg-eps into empty axes eps!
% ctr counter for new and old eps-file-names

ctr=0; ax_cmpr=fliplr(ax_cmpr); ax_same = fliplr(ax_same);
for i=1:picvec_size    
  if ax_cmpr(i)==1

    ctr=ctr+1;
    %filename_old = my_filename(ctr-1, 2, 'axes', '.eps');
    filename_old = mkstring('axes','0',ctr-1,99,'.eps');
    %filename_new = my_filename(ctr, 2, 'axes', '.eps');
    filename_new = mkstring('axes','0',ctr,99,'.eps');
    jpegepsname=['matrix_jpeg' num2str(picvec_size+1-i) '.eps'];
    
    axnum = i - sum(ax_same(1:i));
    
    switch mergemode
    case 1
      cb_merge_eps_old1(filename_old, jpegepsname, filename_new, axnum, epsname, ax_cmpr);
    case 2
      cb_merge_eps_old2(filename_old, jpegepsname, filename_new, axnum, epsname, ax_cmpr);
    case 3
      su_merge_eps(filename_old, jpegepsname, epsname, axnum);
    case 4
      cb_merge_eps(filename_old, jpegepsname, filename_new, axnum, epsname, ax_cmpr);
    case 5
      cb_merge_eps5(filename_old, jpegepsname, filename_new, axnum, epsname, ax_cmpr, ax_same);
    end
  end
end
%filename_new = my_filename(ctr, 2, 'axes', '.eps');
filename_new = mkstring('axes','0',ctr,99,'.eps');

eval(['!' delete_str ' ' epsname]);
eval(['!' mv_str ' ' filename_new ' ' epsname]);
disp(['eps-file written to: ' epsname]);

% remove no more needed files axes**.eps
for i=1:sum(ax_cmpr)
  if i<sum(ax_cmpr)+1            
    %fname = my_filename(i-1, 2, 'axes', '.eps');
    fname = mkstring('axes','0',i-1,99,'.eps');
    eval(['!' delete_str ' ' fname]);
  end;
end;
% remove no more needed files matrix_jpeg**.eps
ax_cmpr=fliplr(ax_cmpr);
for i=1:picvec_size
  if ax_cmpr(i)==1
    fname=['matrix_jpeg' num2str(i) '.eps'];
    eval(['!' delete_str ' ' fname]);                        
  end
end


% switch ON all axes again
for i= 1:axes_nr
  set(axes(i), 'visible', 'on');
  c1 = get(axes(i), 'Children');
  set(c1, 'visible', 'on');
end

% +++ END MAIN +++
end