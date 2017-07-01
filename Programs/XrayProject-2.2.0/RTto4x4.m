function [Transf] = RTto4x4(R, T)
% function [Transf] = RTto4x4(R, T)
%
% Inputs:  R = 3x3 rotation matrix
%          T = xyz translation
% Output:  Transf = 4x4 tranformation matrix. 


Transf(:,:) = eye(4,4);
Transf(1:3,1:4) = [R T'];
Transf(4,1:4) = [0 0 0 1];
   


