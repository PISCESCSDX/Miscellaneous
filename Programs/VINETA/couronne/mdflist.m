function [fn em es] = mdflist
%==========================================================================
%function [fn em es] = mdflist
%--------------------------------------------------------------------------
% MDFLIST yields the list of mdf-files in the current directory, and it
% checks whether the 8-mdf cluster for one couronne measurement is
% complete.
%--------------------------------------------------------------------------
%OUT: fn filename list
%     em error matrix - number distance of each 8 measurements
%     es error status: 1-if an error occured; 0-no error
%--------------------------------------------------------------------------
% EXAMPLE: [fn em es] = mdflist;
%==========================================================================

    % assignment of mdf-files of each card
    %cards=['B1'; 'B2'; 'B3'; 'B4'; 'B5'; 'B6'; 'B7'; 'B8'];
    cards=['BA'; 'BB'; 'BC'; 'BD'; 'BE'; 'BF'; 'BG'; 'BH'];

    % load filenames into the cell-structure filenamelist{i, j}
    la=0; es=0;
    for i=1:8
        a = dir([cards(i,:) '*mdf']);
        if isempty(a)
            a = dir([cards(i,:) '*MDF']);
        end
        for j=1:length(a)
            fn{i, j} = a(j).name;
            em(i,j)=str2double(fn{i, j}(4:length(a(j).name)-4));
        end;        
        % test wether lengths are equal
        if i>1 && la ~= length(a)
            disp(['ERROR: Namelist length of ' num2str(i-1) ...
                ' is not equal with ' num2str(i) '.']);
            es = 1;
        end;
        % for length test ...
        la=length(a);
    end;

    % calculate relative distance of numbers for error matrix
    for i=2:8
        em(i,:)=em(i,:)-em(1,:);
    end;
end