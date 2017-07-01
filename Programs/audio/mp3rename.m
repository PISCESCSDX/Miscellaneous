function mp3rename(an, ext, fext, quest, mfb)
%==========================================================================
%function mp3rename(an, ext, fext, quest, mfb)
%--------------------------------------------------------------------------
% MP3RENAME renames semi-automatically all mp3 files in the current 
% directory. From every mp3-file the filename will be read, the song name
% is detected, and if possible the number will be detected. If any problem
% occurs the program ask everything to be entered manually.
% If quest is set to "1" (default), the user has to confirm every change.
%--------------------------------------------------------------------------
% an: string of artist name
% ext: string with the new file extension (default: 'mp3')
% fext: string of mp3-file extension in curr. directory (default: 'mp3')
% quest: 0 - change without confirmation, 1: ask before change (default)
% mfb: 1 make the first letters big rest small, 0 no
%--------------------------------------------------------------------------
% EX: mp3rename('Lifehouse', 'mp3', 'mp3', 1, 1);
%==========================================================================

disp(' ')
if nargin<5; mfb=0; end
if nargin<4; quest=1; end
if nargin<3; fext='mp3'; end

% read the files in the directory
a = dir(['*' fext]);
la= length(a);


  disp('For the artist use: #ar "Rammstein".')
  disp('For the number use #nu "111" for 001.')
  disp('For the delimiter use #de " " for simple space.')
  disp('For the songname use #sn "_".')
  disp('For the end use #en ".mp3".')
  disp('-- Keep the order like it is in the files. --')
  disp(['Example: "Adele -21- Hello world.MP3" use #ar "Adele" ' ...
    '#de " -" #nu "11" #sn " " #en ".MP3"'])
  % # Input:
  inp_str = input('Enter the structure of the song name:\n', 's');


for i=1:la
  currfn = a(i).name;
  disp(['old: "' currfn '"']);
  % detect song name
  [song, snum] = detectsong2(currfn, mfb, inp_str);
  % song name not detected
  if strcmp(song, '-1')
    song = input('Song name not detected, enter: ');
  end
  if isnan(snum)
    snum = input('Song number not detected, enter: ');
  end
  
  % make snum string
  numstr = mkstring('', '0', snum, la, '');
  
  newfn = [an ' -' numstr '- ' song '.' ext];
  % confirmation
  if quest==1
    confnewfn = input(['new: "' newfn '"?      yes:Enter  no:Other'], 's');
  else
    disp(['new: "' newfn '"'])
    confnewfn = 1;
  end
  if confnewfn==0
    newfn = input('New file name manually: ');
  end
  
  if ~strcmp(currfn,newfn)
    movefile(currfn, newfn);
  else
    disp('Old and new equal ----> No change!')
  end
  disp('--')
end

% end
disp('All files in this directory have been renamed!')
disp(' ')
end