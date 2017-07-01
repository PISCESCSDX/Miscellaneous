function cou_timerow(cch, tin, limy);
%function cou_timerow(cch, defch);
%20070123 Brandt: Plots a time row of a Couronne-measurement.
%
% needs:    mdf_list.m
%           mdf_read8.m
%           fct_1pic_tt.m
%
% input     cch (opt, number)   time trace of couronne channel ch
%           tin (opt, vec)      time intervall [t1 t2] /ms
% output    mat             
%
% EXAMPLES: cou_timerow(1, [0 20], [-0.3 0.3]);

if nargin < 1
    cch = 1;
end;

if nargin < 2
    tin = [];
end;

if nargin < 3
    limy = [];
end;


% +++ MAIN +++
[fn em es] = mdf_list;
if es==0
    
    disp(['number of measurements in the current directory: ' num2str(size(fn, 2))]);
    % get number to show
    num = input('show time trace of measurement: ');
    if isempty(num)
        num = 1;
    end;    
    % load matrix of measurement no. num
    [A, tx] = mdf_read8(num, fn);
    tx = tx-tx(1);    
    disp(['length of the time trace: ' num2str(tx(end)*1000) ' ms']);
    
    % calculate tin
    if isempty(tin)
        fct_1pic_tt(tx, A(cch, t1:t2), 1, 14, 'eps');        
    else
        t1 = find(tx*1000>tin(1));
        t2 = find(tx*1000>tin(2));    
        tin = [t1(1) t2(1)];
        % show time trace in graph
        fct_1pic_tt(tx(tin(1):tin(2)), A(cch, tin(1):tin(2)), limy, 1, 14, 'eps');
    end;

else
    disp('One or more mdf-files are missing, or misarranged!');
end;

% add a empty row
disp(' ')

% +++ END MAIN +++
end