function lm_rtb(toolbox,number);
% LM_RTB(TOOLBOX_NAME) let licence manager releases a blocked toolbox.
% Valid names for TOOLBOX_NAME are:
%   curve, spline, image, signal, symbol, extsym, statistic and wavelet.
%
% LM_RTB(TOOLBOX_NAME,NUMBER) kills the license with number that is used.
% Use eg lm_rtb('signal',2) to kill the second toolbox in use. To find out 
% who is using which toolbox type "lm_rtb" hat confirm 'show toolboxes'.

% last change: 16.01.06 astark

% Handle input parameters
if nargin == 0
    help lm_rtb
    key = input('Show used toolboxes [y/n]? ','s');
    if lower(key) == 'y'
        eval(['!' matlabroot '/etc/lmstat -a']);
    end;
    return
elseif nargin == 1
    number = 1;
end;
   
% Define Toolbox search strings
switch lower(toolbox)
    case 'curve'
        tb = 'Curve_Fitting_Toolbox';
    case 'spline'
        tb = 'Spline_Toolbox';
    case 'image'
        tb = 'Image_Toolbox'
    case 'symbol'
        tb = 'Symbolic_Toolbox';
    case 'extsym'
        tb = 'Extend_Symbolic_Toolbox';
    case 'signal'
        tb = 'Signal_Toolbox';
    case 'wavelet'
        tb = 'Wavelet_Toolbox';
    case 'statistic'
        tb = 'Statistics_Toolbox';
    otherwise
        eval(['!' matlabroot '/etc/lmstat -a']);
        disp(['   Warning: ' toolbox 'unknown!'])
        help rel_tb
        return
end;

% Get Toolboxes that are currently in use
eval(['!' matlabroot '/etc/lmstat -a >/tmp/lm.out']);

% Scan used toolboxes for the requested toolbox
fid = fopen('/tmp/lm.out');
tmp = '';
while ischar(tmp)
    tmp = fgetl(fid);
    if ~isempty(findstr(tmp,['"' tb '"']))
        break
    end;
end;
if ~ischar(tmp)                         % Toolbox not used
    disp('   Warning: License seem to be not in use!')
    return
else                                    % Toolbox is used
    for i = 1:number
        fgetl(fid);                     % Go to requested number
    end;
    fgetl(fid);
    tmp = fgetl(fid);                   % Get user information
    usr = sscanf(tmp,'%s%c%s%c%s',5);
    lms = [matlabroot '/etc/lmremove'];
    lis = [' -c ' matlabroot '/etc/license.dat '];
    eval(['!' lms lis tb ' ' usr ' >/tmp/lmr.out']);
end;

% Diagnose operation output
fid2 = fopen('/tmp/lmr.out');
tmp = '';i=0;
while ischar(tmp)
    i = i+1;
    tmp = fgetl(fid2);
    if ~isempty(findstr(tmp,'usage'))
        disp(['   Warning: Could not release' tb '. Run "lmremove manualy"!'])
    elseif ~isempty(findstr(tmp,'minimum lmremove interval'))
        disp(['   Warning: ' tb ' is still blocked. Try later.'])
    elseif ~isempty(findstr(tmp,'Connection reset by'))
        disp(['   Warning: ' tb ' is still blocked. Try later.'])    
    end;
end;
if ~ischar(tmp) &  i == 4
    disp([tb ' is released!'])
end;

% Close and remove temporary files
fclose(fid);
fclose(fid2);
delete('/tmp/lm.out')
delete('/tmp/lmr.out')