function [mat]= normmat_std(mat)
% function [mat]= norm_mat(mat)
% 
% standardization of couronne-data - lines & columns get normalized to 
% their standard deviation
%
% input:    mat        matrix with measurement data
% output:   mat        normalized matrix
%

   %rows   = size(mat, 1);
   %cols   = size(mat, 2);
   %one_col= ones(1, size(mat,2));
   one_row= ones(size(mat,1),1);

   mat= mat - one_row * mean(mat);
   
   %normalisation along time (rows)
   std_time= std(mat);
   std_time(std_time == 0)= 1e-5;
   mat= mat ./ (one_row * std_time);
   
   %normalisation along angle (cols)
   %std_probe= std(mat, [], 2);
   %std_probe(std_probe == 0)= 1e-5;
   %mat= mat ./ (std_probe * one_col);

end