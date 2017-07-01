function [cell_strvec]= line2cellstr(tline)
% function [cell_strvec]= line2cellstr(tline)
%
% breaks tline into substrings at spaces and returns
% theses strings as cell vector
%
% input tline         string containing several field with space
%                     as delimiter
% output cell_strvev  cell mat with substrings

    cell_strvec= {};
    ind= [1:size(tline, 2)];
    ind= [0, ind(tline== ' '), size(tline, 2)];
    

    for i= 2:size(ind, 2);
        cell_strvec= [cell_strvec, ...
                      tline(ind(i - 1) + 1: ind(i) - 1);
                      ];
    end
    
    cell_strvec= cell_strvec( ~( strcmp(cell_strvec, ' ') | ...
                                 strcmp(cell_strvec, '' )   ...
                                 ));
    

end