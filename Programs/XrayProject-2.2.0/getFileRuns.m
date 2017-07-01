% get lists of first filenames and run lengths from all selected filenames
function [fImSorted,fRunLength] = getFileRuns(fIn)
%
% 19 Jan 2011 L J Reiss

fImage=fIn;
% Sort list fImage by name. Result is in fImSorted.
fImSorted = sort(fImage);
% Sort list fImSorted by file extension.  Result is in fImage.
imax = size(fImSorted,2);

Itodo = ones(imax,1);
IextRun = ones(imax,1);
i3=0;

while (imax>i3)   
    iNext = find(Itodo,1);
    iNext = iNext(1);    
    [ptemp, ftemp, ext] = fileparts(fImSorted{iNext});
    TT = strfind(fImSorted,ext);    
    for i1=1:imax
        if(Itodo(i1)==1)
            if ~(isequal(TT(i1),{[]}))
                i3=i3+1;
                fImage(i3)=fImSorted(i1);
                Itodo(i1)=0;
            end
        end
    end
end
% Sort list fImage by name length.  When finished, result is in fImSorted.

Itodo = ones(imax,1);
i3=0;

while (imax>i3)
    
    iNext = find(Itodo,1);
    iNext = iNext(1);  
    tsize = size(fImage{iNext},2); % character length of first filename in list
[ptemp,ftemp,ext] = fileparts(fImage{iNext});
    while(iNext<=imax)  % copy all filenames with same char len as first in list
        tnewsize = size(fImage{iNext},2);
        [ptemp,ftemp,newext]=fileparts(fImage{iNext});
        if(tsize == tnewsize) && (strcmp(ext,newext))
            i3=i3+1;
            fImSorted(i3)=fImage(iNext);
            Itodo(iNext)=0;
        end
        iNext = iNext + 1; 
    end
    
end

% Find sublists (i.e., files with same prefix and ext), and
% check sublists for runs (i.e., sequence of tif or jpg frames)   
% Then, tell user what is
% found (i.e., first file name in each run and length of run).
%
% fprintf statements below output filename at start of each run and run
% length for tif and jpg file runs.
% When finished,
% indexout is number of runs
% fRunLength(1:indexout) is list of lengths of runs for tif and jpg;
% otherwise 0 (e.g., for avi, cine).
% fImage(1:indexout) is list of first file for each run.
%
fRunLength = zeros(imax,1);
indexfname=1;
indexout=0;
 
while (imax>=indexfname)
    [ptemp,fname,ext]=fileparts(fImSorted{indexfname});
    switch (ext)
        case {'.jpg','.JPG','.jpeg','.JPEG','.tif','.TIF','.tiff','.TIFF'}
            % assume a stack of jpg or tif files with framenumber encoded at end of
            % file name, e.g., rat.00004.tif is frame 4 of rat file.
            % obtain frame number from file name e.g., rat.00004.tif is frame 4.
            % Dots in  filename prefix are permitted--e.g., rat.003.00005.tif is
            % frame 5 of rat.003 file.
            indexDot=strfind(fname,'.');
            NumFrames = 1; %initialize
            fprintf('\n%s',fImSorted{indexfname});
            indexout=indexout+1;
            fImSorted(indexout)=fImSorted(indexfname);
            if isempty(indexDot)
                frameNo = 1; % assume single frame if dot not found
                indexfname = indexfname+1;
            else
                frameNo = sscanf(fname(indexDot(end)+1:end),'%d',1);
                if(isa(frameNo,'numeric'))
                    % find and count additional frames with same filename prefix.
                    iCharsInFrameNo = length(fname)-indexDot(end);
                    newFname = fname;
                    nextFrameNo = frameNo;
                    while (imax>=indexfname)&&...
                            (isequal([newFname,ext],fImSorted{indexfname}))
                        % create file name for subsequent frame, e.g., rat.00005.tif follows
                        % rat.00004.tif
                        nextFrameNo = nextFrameNo+1;
                        newFname = [fname(1:indexDot(end)),...
                            sprintf('%0*d',iCharsInFrameNo,nextFrameNo)];
                        indexfname=indexfname+1;
                    end
                    NumFrames = nextFrameNo - frameNo;
                else
                    frameNo = 1; % assume single frame if frame# not found
                    indexfname = indexfname+1;
                end
            end
            fRunLength(indexout)=NumFrames;
            if (NumFrames==1)
                fprintf(' -- 1 frame');
            else
                fprintf(' -- %d frames',NumFrames);
            end
        otherwise
            fprintf('\n%s',fImSorted{indexfname});
            indexout=indexout+1;
            fImSorted(indexout)=fImSorted(indexfname);
            indexfname=indexfname+1;
    end
end
fprintf('\n');
fImSorted(indexout+1:imax)='';
fRunLength = fRunLength(1:indexout);
