function [mayaTransforms res resCT] = rigidBody(varargin)
% function [mayaTransforms res resCT] = rigidBody(markerIdx,ct)
% function [mayaTransforms] = rigidBodyMotionFromMarkers(markerIdx,ct)
%
% takes ct marker data and digitized data file and outputs bone
% matrix transforms using singular value decomposition

% input: markerIdx is a cell array where the marker index for bone1 is in
% cell 1, bone2 in cell 2... ex: markerIdx{1} = [1;2;3];... 
% 
% added support for XrayProject default directory October 2009 -- L. Reiss.
% last changed 27 May 2010 -- LReiss 
defaultdir = cd; % initialize
xrayprojectdirhandle = 0; % initialize
if nargin==0
    
elseif nargin==1 % assume just markerIdx or call from XrayProject.
    if iscell(varargin(1)) %If from XrayProject, it is a cell array of handles.
        xrayprojhandles = varargin{1};
        defaultdir = get(xrayprojhandles.defaultdir,'String');
        xrayprojectdirhandle = xrayprojhandles.defaultdir;
    else
        markerIdx = varargin(1);
    end
elseif nargin==2 % assume the arguments of the original stand-alone script.
    markerIdx = varargin(1);
    ct = varargin(2);
else
    disp('rigidBody: incorrect number of input arguments');
    return;   
end

    % if you have't input ct
    if exist('ct') == 0
        %get ct cord data
        [fcord,pcord]=uigetfile('*.csv','Select the CT marker coordinate file',...
            defaultdir);
        
        if fcord == 0
            disp(sprintf('\n No file chosen \n'))
            return
        end
        
        ct = dlmread([pcord,fcord],',',1,0);

        defaultdir = pcord; %update default directory
        if(xrayprojectdirhandle~=0)
            set(xrayprojectdirhandle,'String',pcord);
        end
        
        % write it to the workspace for next set of files
        assignin ('base', 'ct',ct);
        
    end
    
        % get the xyz data
    [fdata,pdata]=uigetfile('*.csv',...
        'Select the [prefix]xyzpts.csv or xyzptsBUTTER.csv file',...
        defaultdir);
    
    % cancel if no file was chosen
    if fdata == 0
        disp(sprintf('\n No file chosen \n'))
        return
    end
    
    data = dlmread([pdata,fdata],',',1,0);
    
    defaultdir = pdata; %update default directory
    if(xrayprojectdirhandle~=0)
        set(xrayprojectdirhandle,'String',pdata);
    end

    %if you haven't input a markerIdx
    if exist('markerIdx') == 0
        % get the number of markers and create a list for markers
        markerNum = size(data,2)/3;
        mList = num2str((1:markerNum)','%g\n');

        % get number of rigid objects from the user
        boneNum = inputdlg('How many Bones?','Bone Number',1,{'1'});
        boneNum = str2num(boneNum{1});

        % get markers associated with each bone
        for i = 1:boneNum
            [currentMarkerIdx,ok] = listdlg('PromptString',...
                sprintf('Select the markers for bone %d',i),...
                'Name','Marker Selection','ListSize',[200 17*markerNum],...
                'SelectionMode','multiple','ListString',mList);
            if(ok==0)
                disp(spintf('\n Cancelled by user. \n'));
                return
            end
            markerIdx{i} = currentMarkerIdx;            
        end
        
        %write it to workspace for additional files
        assignin ('base', 'markerIdx',markerIdx);
    else
        boneNum = size(markerIdx,2);
    end

    % insert ct data in first non-nan row
    data = findFirstFrame(data,ct,markerIdx);    
    
    % calculate transforms for each bone
    for i = 1:boneNum
        landmarks = markerIdx{i};
        colIdx = [(3*landmarks), (3*landmarks)-1,(3*landmarks)-2];
        colIdx = sort(colIdx);
        x = data(:,colIdx);
        [R t res(:,i)]=svdrigid(x);
        
        % Composite the relative transformations to give absolute
        % transforms for each bone at each timestep
        for j = 1:size(t,1)
            rot(:,:) = R(j,:,:);
            trans(:,:) = t(j,:);
            TF(j,:,:) = RTto4x4(rot,trans);
        end
        
        sampleCol = TF(:,1,1);
        [idx, gapAfter, startend] = indexNonNan(sampleCol);
        
        for j = 1:size(startend,1)
            for k = startend(j,1)+1:startend(j,2)
                if k == startend(j,1)+1 && j ~= 1
                    A = B*A;
                    B(:,:) = TF(k-1,:,:);
                    TF(k-1,:,:) = B*A;
                    A = B*A;
                else
                    A(:,:) = TF(k-1,:,:);
                end
                B(:,:) = TF(k,:,:);
                TF(k,:,:) = B*A;
            end
        end       
        mayaTransforms(:,16*i-15:16*i) = mayaMatrixFormat(TF);
    end
    
    % get residual for ct-to-calibration for each frame
    for i = 1:boneNum
        landmarks = markerIdx{i};
        colIdx = [(3*landmarks), (3*landmarks)-1,(3*landmarks)-2];
        colIdx = sort(colIdx);
        for j = 1:size(data,1)
            x = [ct(1,colIdx);data(j,colIdx)];
        [Rct tct resCT(j,i)]=svdrigid(x);
        end
    end
    
    % save path and file name
    [pout, fout, ext, version] = fileparts([defaultdir,fdata]);
    [fdata,pdata] = uiputfile('*.csv','Save Bone Data As',...
        [pout,filesep,fout,'AbsTforms',ext]);
    
    if fdata == 0
        disp(sprintf('\n Save cancelled by user. \n'))
        return
    end
    
    dlmwrite([pdata,fdata],mayaTransforms,'precision','%10.10f');
    
    defaultdir = pdata; %update default directory
    if(xrayprojectdirhandle~=0)
        set(xrayprojectdirhandle,'String',pdata);
    end
    
    % update save path and file name
    [pout, fout, ext, version] = fileparts([pdata,fdata]);

    [fdata,pdata] = uiputfile('*.csv','Save Residuals As',...
        [pout,filesep,fout,'TRes',ext]);
 
    if fdata == 0
        disp(sprintf('\n Save cancelled by user. \n'))
        return
    end
    
    defaultdir = pdata; %update default directory
    if(xrayprojectdirhandle~=0)
        set(xrayprojectdirhandle,'String',pdata);
    end
    
    dlmwrite([pdata,fdata],res,'precision','%10.10f');
    clear ct;
    clear markeridX;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dataOut] = findFirstFrame(data,ct,markerIdx)
% function [dataOut] = findFirstFrame(data,ct,markerIdx)
% Prepends the marker coordinate data before the first non-NaN row
% INPUTS:   data        - rows are time and columns are xyz coordinates
%           ct          - single row of xyz marker coordinates that directly 
%                         correspond to data columns
%           markerIdx   - Index of markers for each bone
% OUTPUTS: dataOut      - data with prepended ct data
%
% David Baier 6/11/2008
% last changed 27 May 2010 LReiss    
    boneNum = size(markerIdx,2);
    dataOut = zeros(size(data,1)+1,size(data,2)).*NaN;
    
    % for each bone, find the first row with at least 3 non-NaN points
    for i = 1:boneNum
        
        columnIdx = [markerIdx{i}*3-2 markerIdx{i}*3-1 markerIdx{i}*3];
        columnIdx = sort(columnIdx);
        
        % get the columns for one bone at a time
        curBone = data(:,columnIdx);
        firstframe = 1;
        
        % count NaNs per row
        for j = 1:size(curBone,1)
            curRow = curBone(j,:);
            idx = find(~(isnan(curRow)));
            % check to see if
            if size(idx,2) >= 9
                firstframe = j;
                break;
            end
        end   
        
        dataOut(2:(size(data,1) + 1),columnIdx)=data(:,columnIdx);
        dataOut(firstframe,columnIdx)=ct(1,columnIdx);

    end
            
        

