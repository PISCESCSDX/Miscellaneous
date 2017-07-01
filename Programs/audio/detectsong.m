function [sname, snum] = detectsong(fn, firstsmall)
%==========================================================================
%function [sname, snum] = detectsong(fn, firstsmall)
%--------------------------------------------------------------------------
% DETECTSONG detects the songname and the number. It gives sname='-1' if
% the songname couldn't be detected. It yields snum=-1 if the song number
% couldn't be detected.
%--------------------------------------------------------------------------
% sname: string with the song name
% snum: number of the song
% fn: filename of the song
% firstsmall: 1 mkfirstletters small, 0 no
%--------------------------------------------------------------------------
% EX:
%==========================================================================

snum = -1;
sname = '-1';
% Detect the song number (between two "-")
%==========================================================================
lf = length(fn);

% Detect positions of '-'
%------------------------
pos_minus = findstr(fn, '-');
pos_spmin = findstr(fn, ' -');
pos_minsp = findstr(fn, '- ');
pos_spmsp = findstr(fn, ' - ');
pos_space = findstr(fn, ' ');
pos_point = findstr(fn, '.');

% 1: '* - 01 - Title.*', '* -01- Title.*'
%==========================================================================
if (~isempty(pos_spmin) && ~isempty(pos_minsp)) && ...
    ( isnumeric(str2num(fn(pos_spmin(1)+2:pos_minsp(end)-1))) ...
     && ~isempty( fn(pos_spmin(1)+2:pos_minsp(end)-1)) )
  % song number
  indnum = pos_spmin(1)+2:pos_minsp(end)-1;
  snum = str2num(fn(indnum));
  % song name
  if pos_point(end)>pos_minsp(end)+1
    indnam = pos_minsp(end)+2:pos_point(end)-1;
    sname = fn(indnam);
  end
end

% 2: '01 - Title.mp3', '01 - '
%==========================================================================
if length(pos_spmsp)==1 && isnumeric( str2num(fn(1:pos_spmsp-1)) )
  % song number
  indnum = 1:pos_spmsp-1;
  snum = str2num(fn(indnum));
  % song name
  indnam = pos_spmsp+3:pos_point(end)-1;
  sname = fn(indnam);
end
    
% Remove first spaces in sname
%==========================================================================
if ~strcmp(sname,'-1')
  pos_space = findstr(sname, ' ');
  % at least one space
  if ~isempty(pos_space)
    % first character is a space
    if pos_space(1)==1
      status = 0; ctr = 0;
      while status==0
        ctr=ctr+1;
        if ~strcmp(sname(ctr),' ')
          sname = sname(ctr:end);
          break
        end
        if ctr+1>length(sname)
          status=1;
          sname='';
        end
      end
    end
  end
end


% Semi-Automatic
%==========================================================================
if ~strcmp(sname,'-1')
disp('The song names could not be detected. Now do it semi-manually:')
disp('For the artist use: -ar "Rammstein".')
disp('For the number use -nu "111" for 001.')
disp('For the delimiter use -de " " for simple space.')
disp('For the songname use -sn.')
disp('For the songname delimiters use -sd.')
disp('For the end use -en ".mp3".')
disp('-- Keep the order like it is in the files. --')
disp(['Example: "Adele -21- Hello world.MP3" use -a Adele ' ...
  '-d " -" -n "11" -sn -e ".MP3"'])
% # Input:
inp_str = input('Enter the structure of the song name:\n');

pos_minus = findstr(inp_str, '-');
pos_gf    = findstr(inp_str, '"');
pos_en    = findstr(inp_str, '-en "');
lpos_minus = length(pos_minus);

% Find the song name and the song number
disp('For the artist use: -ar "Rammstein".')
disp('For the number use -nu "111" for 001.')
disp('For the delimiter use -de " " for simple space.')
disp('For the songname use -sn "_".')
disp('For the end use -en ".mp3".')

ctr = 0;
for i=1:lpos_minus
  currstr = inp_str(pos_minus(i)+1:pos_minus(i)+2);
  switch currstr
    case 'ar'
    case 'nu'
    case 'de'
    case 'sn'
    case 'sd'
    case
  end
end
sname =' ';
snum = ' ';
end


% Make first letters small in sname
%==========================================================================
if firstsmall == 1
if ~strcmp(sname,'-1')
  sname = mkfirstbigrestsmall(sname);
end
end

end