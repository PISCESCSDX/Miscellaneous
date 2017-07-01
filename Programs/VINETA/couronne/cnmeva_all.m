function cnmeva_all(tint, t1, ch, defch);
%function cnmeva_all();
% needs:    findfolders.m
%           mdfzip.m
% input     
% output       
%
% EXAMPLE: cnmeva_all();

    dirlist = findfiles('cnm');
    
% find all folders in the names -> saved in follist{..}
    [follist] = findfollist(dirlist);

% set the start time
    sc = clock_int;

    for i=1:length(follist)
        disp(['evaluation of cnm-files of directory: '  follist{i}]);
        cd(follist{i});
        cnmeva(tint, t1, ch, defch);
    end;
    
    % show calculation time
    ec = clock_int; 
    disp(['DURATION OF EVALUATION OF CNM-FILES']);
    disp(['begin: ' sc]);
    disp(['diff:      ' clockdiff(sc, ec)]);

end