function [output]=applyRotationMatrix(input,rotm);

% function [output]=applyRotationMatrix(input,rotm);
%
% Applies a rotation matrix to input where input is a Nx3 matrix with each
% row being a set of [X,Y,Z] coordinates and rotm is a 3x3 rotation matrix.
% The operation is [X,Y,Z]*[rotm]=[X',Y',Z'].
%
% This function is vectorized and much faster than applying the rotation
% within a loop and quite a bit neater looking than typing the vectorized
% bit out repeatedly.
%
% Ty Hedrick
% 12/10/2005

output(:,1)=input(:,1).*rotm(1,1)+input(:,2).*rotm(2,1)+input(:,3).*rotm(3,1);
output(:,2)=input(:,1).*rotm(1,2)+input(:,2).*rotm(2,2)+input(:,3).*rotm(3,2);
output(:,3)=input(:,1).*rotm(1,3)+input(:,2).*rotm(2,3)+input(:,3).*rotm(3,3);
