% addImFrame - preprocess as needed and append image to file
function [newaviobj] = addImFrame(aviobj,...
    outframe,pFile,outext,scaleType,ext,iminfo,tempid)
% outframe - image to append
% pFile - proposed file path (input)
% outext - extension of output file (.jpg,.tif,.avi)
% scaleType - 'moviemax','framemax','shift5','shift4','none'
% iminfo - image info 
% ext - type of original file
% aviobj - avifile object, if applicable (for avi file output)
% tempid - temporary file id, if applicable (for 'moviemax' case)
newaviobj = aviobj;
newpFile = pFile;
% preprocess if image bitdepth is greater than 8. 
switch scaleType 
 %  case 'moviemax'
 % save raw outframe in temporary file and determine the maximum
 % pixel value for the movie. Later, the temporary file is read and each
 % frame is rescaled so the movie's maximum pixel value is mapped to the
 % maximum value that can be represented in eight bits (or whatever bit
 % depth is desired).
 %   case 'none'
 % save raw outframe
 %            
    case 'shift4'
        outframe = uint8(double(2^(-4))*outframe);
    case 'shift5'
        outframe = uint8(double(2^(-5))*outframe);
    case 'framemax'
        outframe = uint8((double(2^8)/double(max(max(outframe))))*outframe);
    otherwise
end

% append
if strcmp(scaleType,'moviemax')
    precision = [ class(outframe) ];
    fwrite(tempid,outframe,precision);
else
switch outext
    case '.avi'
        newaviobj = addframe(aviobj, outframe);
    case {'.tif','.jpg'}
            newaviobj = aviobj;
            ptemp = pFile;     
            % Check if file already exists to avold overwriting.
            checkingfilename = 1;
            nx=0;
            while (checkingfilename)
                if nx==10000
                    disp('Proposed filename in use. Will be overwritten.');
                    ptemp = pFile;
                    checkingfilename = 0;
                end
                if exist(ptemp,'file')
                    nx=nx+1;
                    suffix = [sprintf('_%04d',nx)];
                    ptemp = [pFile(1:end-3), suffix, outext];
                else
                    checkingfilename = 0;
                    if nx>0
                        disp('Proposed filename in use. File saved as:  ');
                        disp(sprintf('%s',ptemp));
                    end
                end
            end
    
        imwrite(outframe,ptemp,outext(2:end));
end
end
end
        