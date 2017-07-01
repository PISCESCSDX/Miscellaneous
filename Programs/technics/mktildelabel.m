function htilde = mktildelabel(ax, ht, str, itilde, topchar)
%==========================================================================
%function htilde = mktildelabel(ax, ht, str, itilde, topchar)
%--------------------------------------------------------------------------
% MKTILDELABEL sets a tilde over a character in a text string.
% If the character is a latex-command (e.g. \phi), set the position of the
% backslash \.
%--------------------------------------------------------------------------
% EX: 
%   xlb = 'n [m^{-3}]';
%   mktilde(ax, hx, xlb, 1)
% htilde = mktilde(ax, hy, '\phi [m^{-3}]', 1)
%==========================================================================

if nargin < 5; topchar = '~'; end

set(ht, 'str', str)

%==========================================================================
% Get the character over which the tilde should be placed
%==========================================================================
if strcmp(str(itilde), '\')
  ctr=0; status = 0;
  while status == 0
    ctr=ctr+1;
    if ~isempty(findstr(str(itilde+ctr),'abcdefghijklmnopqrstuvwxyz'))
      status = 0;
    else
      status = 1;
      stri = str(itilde:itilde+ctr-1);
    end
  end
else
  stri = str(itilde);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the position and the extent of the original label string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ro0 = get(ht, 'rotation');
ex0 = get(ht, 'extent');
fo0 = get(ht, 'fontsize');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET THE WIDTH & HEIGHT STRING, SPACE, ~, and BEGIN OF STRING -> Character
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin position of the string
if itilde>=1
  char_str = str(1:itilde-1);
else  char_str = ' ';
end
set(ht, 'str', char_str);
ex1 = get(ht, 'extent');

% CHARACTER
set(ht, 'str', stri);
exi = get(ht, 'extent');

set(ht, 'str', topchar);
exchar = get(ht, 'extent');

set(ht, 'str', str);

%==========================================================================
% ***
%
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SWITCH BETWEEN ROTATION OF STRING (up to now: only 0° and +90°)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch ro0
  case 0
    set(gcf, 'CurrentAxes', ax)
%     htilde = text(ex0(1)+ex1(3)+(exi(3)-exchar(3))/2, ex0(2)+ex1(4), '~', 'fontsize', 10);
    htilde = text(ex0(1)+ex1(3)+(exi(3)-exchar(3))/2, ex0(2)+ex1(4), '$\tilde{\text{a}}$', 'interpreter', 'latex', 'fontsize', 10);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % IF NECESSARY decrease the distance between tilde and character
    % because: letters differ in height (e.g. a & f)
    % WORKS ONLY WELL FOR ARABIC LETTERS, FOR GREEK (e.g. \alpha) 
    % THE SPACE BETWEEN CHARACTER AND TILDE IS THE SAME
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(findstr(stri,'acegijmnopqrsuvwxyz'))
        diff = 1.00*0.40;
    else
      if strcmp(stri,'\phi')
        diff = 0.40*0.54;
      else
        diff = 0.75*0.54;
      end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DIFFERENCE BETWEEN WIDTH OF THE TILDE AND THE CHARACTER
    % + PLACE TILDE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rat_i_space = ex_space(3)/exi(3);
    htilde = text(ex0(1) + ex1(3) - 0.85*rat_i_space*ex_space(3), ...
                  ex_space(2) + exi(4)*(1-diff), ...
                  topchar, 'fontsize', fo0);
    
  case 90
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % IF NECESSARY decrease the distance between tilde and character
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    a= 0.15;
    if ~isempty(findstr(stri,'acegijmnopqrsuvwxyz'))
        diff = 1.80*a;
    else
      if strcmp(stri,'\phi')
        diff = 1.00*a;
      else
        diff = 1.00*a;
      end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DIFFERENCE BETWEEN WIDTH OF THE TILDE AND THE CHARACTER
    % + PLACE TILDE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xlabel
    rat_i_space = ex_space(4)/exi(4);
%     htilde = text(ex0(1) + ex1(3) - 0.85*rat_i_space*ex_space(3), ...
%                   ex_space(2) + exi(4)*(1-diff), ...
%                   topchar, 'fontsize', fo0, 'rotation', 90);

    htilde = text(ex_space(1) + exi(3)*diff, ...
                  ex0(2) + ex1(4) - 0.60*rat_i_space*ex_space(4), ...
                  topchar, 'fontsize', fo0, 'rotation', 90);
% old
%     htilde = text(exi(1) + exi(3)*diff, ex0(2)+ ex1(4) + 0.3*exi(4), ...
%       topchar, 'fontsize', fo0, 'rotation', 90);
end

end

