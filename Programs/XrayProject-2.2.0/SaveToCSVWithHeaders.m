function SaveToCSVWithHeaders(fileName, M, headers)
% Author:  Trevor O'Brien  trevor@cs.brown.edu
% Date:    November 4, 2007
%
%          Concatenates headers with matrix M, and saves the resulting cell
%          array to a .csv file with location specified by fileName.
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    outFile = fopen(fileName, 'wt');
    fprintf(outFile, '%s,', headers{1, 1:end-1});
    fprintf(outFile, '%s\n', headers{1, end});
    
    [rows, cols] = size(M);
    
    for i = 1:rows
        j = 0;
        if(cols > 1)
            for j = 1:cols - 1
             fprintf(outFile, '%10.10f,', M(i,j));
            end
        end
        fprintf(outFile, '%10.10f\n', M(i,j + 1));
    end
    
    fclose(outFile);