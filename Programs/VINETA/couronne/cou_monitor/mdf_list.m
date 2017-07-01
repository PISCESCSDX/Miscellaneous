function [fn fsz em es] = mdf_list(bd);
%function [fn fsz em es] = mdflist(bd);
%20070116 C.Brandt: 
%
% creates a list of mdf-files in directory bd
%
% input     bd              directory containing MDF-files
%
% output    fn              filename list
%           fsz             filesize vector
%           em              contains the number distance of each 8
%                           measurements
%           es              1: if an error occured, 0: no error
%
% EXAMPLE: [fn fsz em es] = readmdf_8cards_mkfilenamelist;
%
% continue with "readmdf_8cards"

if nargin < 1
    bd = '';
end;

    % assignment of mdf-files of each card
    cards=['BA'; 'BB'; 'BC'; 'BD'; 'BE'; 'BF'; 'BG'; 'BH'];
    
    % load filenames into the cell-structure filenamelist{i, j}
    la=0; es=0;
    
    a = dir([bd '\*MDF']);
    if size(a,1) < 8
        fn = [];
        fsz = [];
        em = [];
        es = [];
    else
        for i=1:8
            a = dir([bd '\' cards(i,:) '*MDF']);
            for j=1:length(a)
                fn{i, j} = a(j).name;
                fsz(i, j) = a(j).bytes;
                em(i,j) = str2num(fn{i, j}(3:8));
            end;        
            % test wether lengths are equal
            if i>1 & la ~= length(a)
                es=1;
            end;
            % for length test ...
            la=length(a);        
        end;
        for i=2:8
            em(i,:)=em(i,:)-em(1,:);
        end;        
    end;
    % calculate relative distance of numbers for error matrix

    
end