function [sname, snum] = detectsong2(fn, firstsmall, inp_str)
%==========================================================================
%function [sname, snum] = detectsong2(fn, firstsmall, inp_str)
%--------------------------------------------------------------------------
% DETECTSONG detects the songname and the number. It gives sname='-1' if
% the songname couldn't be detected. It yields snum=-1 if the song number
% couldn't be detected.
%--------------------------------------------------------------------------
% sname: string with the song name
% snum: number of the song
% fn: filename of the song
% firstsmall: 1 mkfirstletters small, 0 no
% inp_str: structure of song names
%--------------------------------------------------------------------------
% EX:
%==========================================================================

snum = -1;
sname = '-1';

% Semi-Automatic
%==========================================================================


pos_minus = findstr(inp_str, '#');
pos_gf    = findstr(inp_str, '"');
lpos_minus = length(pos_minus);

% Find the song name and the song number

% Adele -10- Hello world.mp3
% #ar "Adele" #de " -" #nu "11" #de "- " #sn " " #en ".mp3"

ctr = 1;
for i=1:lpos_minus
  currstr = inp_str(pos_minus(i)+1:pos_minus(i)+2);
  switch currstr
    case 'ar'
      ind1 = pos_gf(2*i-1)+1;
      ind2 = pos_gf(2*i)-1;
      ctr = ctr + ind2 - ind1 + 1;
    case 'nu'
      ind1 = pos_gf(2*i-1)+1;
      ind2 = pos_gf(2*i)-1;
      lnu = ind2-ind1+1;
      snum = str2double(fn(ctr:ctr+lnu-1));
      ctr = ctr + lnu;
    case 'de'
      ind1 = pos_gf(2*i-1)+1;
      ind2 = pos_gf(2*i)-1;
      ctr = ctr + ind2 - ind1 + 1;
    case 'sn'
      % del = inp_str(ind1:ind2);
      j = i+1;
      nextstr = inp_str(pos_minus(j)+1:pos_minus(j)+2);
      if strcmp(nextstr,'en');
        ind1 = pos_gf(2*j-1)+1;
        ind2 = pos_gf(2*j)-1;
        str_en = inp_str(ind1:ind2);
        pos_en = findstr(fn, str_en);
        sname = fn(ctr:pos_en-1);
      end

  end
end


% Make first letters small in sname
%==========================================================================
if firstsmall==1 && ~strcmp(sname,'-1')
  sname = mkfirstbigrestsmall(sname);
end

end