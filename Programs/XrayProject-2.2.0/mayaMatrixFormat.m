function [out] = mayaMatrixFormat(R,t)

% function [out] = mayaMatrixFormat(R,t)
%	
% input: 	R is a nx3x3 rotation matrix array from boneTransformsSVDMethod
%			or a 3x3 from Soder method
%		t is an nx3 xyz translation array.
%		n represents the number of rows (timesteps) 			
% output: for each rigid object,
%    R 3x3 rotation matrix and t translations into maya 1x16 array
% Note: maya stores the 16 element array of the INVERSE matrix in row
% order. 

idx = [4;8;12];

if size(R,2) == 3
    if numel(size(R))==3
        for i = 1:size(R,1)
            out(i,1:3) = R(i,:,1);
            out(i,5:7) = R(i,:,2);
            out(i,9:11) = R(i,:,3);
            out(i,13:15) = t(i,:);
            out(i,idx) = 0;
            out(i,16) = 1;
        end
    elseif numel(size(R))==2
        out(1:3) = R(:,1);
        out(5:7) = R(:,2);
        out(9:11) = R(:,3);
        out(13:15) = t;
        out(idx) = 0;
        out(16) = 1;
    end
elseif size(R,2) == 4
    if numel(size(R))==3
        for i = 1:size(R,1)
            out(i,1:3) = R(i,1:3,1);
            out(i,5:7) = R(i,1:3,2);
            out(i,9:11) = R(i,1:3,3);
            out(i,13:15) = R(i,1:3,4);
            out(i,idx) = 0;
            out(i,16) = 1;
        end
    elseif numel(size(R))==2
        out(1:3) = R(:,1);
        out(5:7) = R(:,2);
        out(9:11) = R(:,3);
        out(13:15) = R(:,4);
        out(idx) = 0;
        out(16) = 1;
    end
end
