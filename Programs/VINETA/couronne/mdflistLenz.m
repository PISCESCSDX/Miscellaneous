function [fn em es] = mdflistLenz;
%function [fn em es] = mdflistLenz;
%
% input
% output    fn  filename list
%           em  error matrix - number distance of each 2 measurements
%           es  error status: 1-if an error occured; 0-no error
% EXAMPLE: [fnL emL esL] = mdflistLenz;
%
% continue with mdfzipLenz

    % assignment of mdf-files of each card
    cards=['B1'; 'B2'];

    % load filenames into the cell-structure filenamelist{i, j}
    la=0; es=0;
    for i=1:2
        a = dir([cards(i,:) '*MDF']);
        for j=1:length(a)
            fn{i, j} = a(j).name;
            em(i,j)=str2num(fn{i, j}(3:8));
        end;        
        % test wether lengths are equal
        if i>1 & la ~= length(a)
            disp(['ERROR: Namelist length of ' num2str(i-1) ...
                ' is not equal with ' num2str(i) '.']);
            es = 1;
        end;
        % for length test ...
        la=length(a);
    end;

    % calculate relative distance of numbers for error matrix
    for i=2:2
        em(i,:)=em(i,:)-em(1,:);
    end;
end