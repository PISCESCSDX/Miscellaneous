function [lines_tilde, lines_pos, posvec] = tildepos(epsfile, change_vec)
%function [lines_tilde, lines_pos, posvec] = tildepos(epsfile, change_vec)
%Finde tilde in eps-file and gives the position-vectors
% typical entrance for tilde in an eps-file
% 4420  825 mt  -90 rotate
% (~) s
% IN: change_vec: if empty no change
%       change_vec(:,1): delta sum to x-positions
%       change_vec(:,2): delta sum to y-positions
%       length of change_vec must be length of posvec!
%OUT: posvec(:,1): x-position (the less, the more left)
%     posvec(:,2): y-position (the less, the higher)
%     posvec(:,3): rotation [deg]
%
% Ex: [lines_tilde, lines_pos, posvec] = tildepos(fn, chv)
%
% chv(1:3,1) = +50;
% chv(1:3,2) = -25;
%
% fn = ['diag-conditional-avg_x' num2str(epsx) '.eps'];
% print_adv([0 1 1], '-r300', fn, 50);
% chv = [80 35 0; 80 35 0];
% [lines_tilde, lines_pos, posvec] = tildepos(fn, chv)


fid1 = fopen(epsfile, 'rt'); 
lnr = 0; ctr = 0;
lines_tilde = [];
lines_pos = [];

if nargin == 2
  if size(change_vec,2) == 2
    change_vec(:,3) = 0
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scan the eps-file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while feof(fid1) == 0
  tline = fgetl(fid1);
  lnr = lnr + 1;
  text(lnr).line = tline;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % LOOK for "(~)"
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  matches = findstr(tline, '(~)');
  if length(matches) > 0
    ctr = ctr + 1;
    lines_tilde = [lines_tilde, lnr];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOOK whether position string is located one line before
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lines_pos = [lines_pos, lnr - 1];  
    str = text(lines_pos(end)).line;
    nums = sscanf(str, '%d %d mt %d');
    switch length(nums)
      case 2
        nums(3) = 0;
        posvec(:, ctr) = nums;
      case 3
        posvec(:, ctr) = nums;
    end
  end
end
fclose(fid1); 
posvec = posvec';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change positions of tildes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 2
  if length(posvec) == length(change_vec)

  ctr = 1;  

  fid3 = fopen(epsfile, 'wt');
  for i= 1:lnr-1
    if i==lines_pos(ctr)
    xn = posvec(ctr, 1) + change_vec(ctr, 1);
    yn = posvec(ctr, 2) + change_vec(ctr, 2);
    pn = posvec(ctr, 3);
    fprintf(fid3, '%s\n', [num2str(xn) ' ' num2str(yn) ' mt ' num2str(pn) ' rotate'] );
      if ctr + 1<=length(lines_pos)
        ctr = ctr + 1;
      end
    else
      fprintf(fid3, '%s\n', text(i).line );
    end

  end
fclose(fid3);

  end
end

end