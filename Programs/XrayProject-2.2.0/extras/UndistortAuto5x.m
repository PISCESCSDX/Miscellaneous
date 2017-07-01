function UndistortAuto5x

% User interface for undistorting grid images from Carm Xray images at
% Brown University.
% 
% User selects a grid image. The gray threshold should be adjusted to
% maximize the number of cells (colored red) without any overlap. if two
% cells are touching (red areas overlap), the undistortion procedure won't
% work. The cell size limit allows the user to eliminate small cells. The
% largest number that does not remove cells from the centrer of the image
% should be used. 

% Pressing the set button 1) creates a matrix of Input Points (the xy
% coordinates of the grid centroids) and a corrected matrix given the 
% known dimensions of the grid

% Several new features in 5x version 
% 1. User interface for selecting gray level and cell size threshold
% 2. Ability to mirror the image if desired(removed)
% 3. Much improved performance
% 4. Automated grid type and orientation detection
% 5. User chooses whether or not to preview an undistorted image
% 6. preview is done using 1/8 of points reducing the processing time.

% David Baier 4/23/07

% main figure window
h = figure('MenuBar','none', 'Toolbar','none', ...
    'HandleVisibility','callback',...
    'position',[20,500,200,300], ...
    'Name', 'Undistorter', 'NumberTitle','off',...
    'UserData',[],'Color', get(0, 'defaultuicontrolbackgroundcolor'));

% panel for gray level slider
hsp = uipanel('Parent',h,'Title','Gray level threshold','FontSize',10,...
    'Units','characters','Position',[1 8 38 6]);

% threshold text box
he1 = uicontrol('Parent', h,'style','edit','Units','characters',...
    'HandleVisibility','callback','Position',[15 11 10 1.5],'enable','off',...
    'String','150','Callback',@he1Callback,'BackgroundColor',[1,1,1]);

% slider control for threshold
hs = uicontrol('Parent', h,'style','slider','Units','characters',...
    'HandleVisibility','callback','Position',[5 9 30 1.5],...
    'Min',0,'Max',255,'Value',150,'Callback', @hsCallback,...
    'enable','off','BackgroundColor',[1,1,1]);

% panel for smallcell slider
hs2p = uipanel('Parent',h,'Title','Size threshold','FontSize',10,...
    'Units','characters','Position',[1 1 38 6]);

% small cell threshold box
he2 = uicontrol('Parent', h,'style','edit','Units','characters',...
    'HandleVisibility','callback','Position',[15 4 10 1.5],'enable','off',...
    'String','0','Callback',@he2Callback,'BackgroundColor',[1,1,1]);

% slider control for removing small cells
hs2 = uicontrol('Parent', h,'style','slider','Units','characters',...
    'HandleVisibility','callback','Position',[5 2 30 1.5],...
    'Min',0,'Max',130,'Value',0,'Callback', @hs2Callback,...
    'UserData',[],'enable','off','BackgroundColor',[1,1,1]);

% open button
hopen = uicontrol('Parent', h,'Units','characters',...
    'HandleVisibility','callback','Position',[1 20 15 2],...
    'UserData',[],'String','Open Image','Callback', @hopenCallback);

% set threshold button
hset = uicontrol('Parent', h,'Units','characters',...
    'HandleVisibility','callback','Position',[3 20 15 2],...
    'String','Set','Visible','off','Callback', @hsetCallback);

% extra button with a future function
hset2 = uicontrol('Parent', h,'Units','characters',...
    'HandleVisibility','callback','Position',[3 20 15 2],...
    'String','Preview','Visible','off','Callback', @hset2Callback);

% checkbox mirrors image
% hc1 = uicontrol('Parent', h,'style','checkbox','Units','characters',...
%     'HandleVisibility','callback','Position',[27 18.5 4 2],...
%     'min',0,'max',1,'value',0,'Callback',@hc1Callback,'enable','off',...
%     'BackgroundColor',get(0, 'defaultuicontrolbackgroundcolor'),...
%     'ToolTipString','check if you want to mirror the original image');
% 
% % checkbox text
% hc1Text = uicontrol('Parent', h,'style','text','Units','characters',...
%     'Position',[19 20 20 1.5],'String','Horizontal Mirror','FontSize',10,...
%     'BackgroundColor', get(0, 'defaultuicontrolbackgroundcolor'));

hWorking = uicontrol('Parent', h,'style','text','Units','characters',...
    'HandleVisibility','Callback','Position',[5 16 18 1.5],'FontSize',10,...
    'String','Working...','Visible','off','BackgroundColor',...
    get(0, 'defaultuicontrolbackgroundcolor'));


    function hopenCallback(hObject, eventdata) %open button clicked

        % get file
        [fname,pname]=uigetfile({'*.tif;*.jpg;*.avi', ...
        'Image files (*.tif, *.jpg, *.avi)'},...
        'Select a calibration grid image');
    
        I = calimread([pname,fname]);
        %do some initial processing
        Ibackground = imopen(I,strel('disk',15));
        I = imsubtract(I,Ibackground);
        I = imadjust(I);
        set(hopen,'UserData',[pname,fname]);
        
        %turn on controls
        set(he1,'enable','on');
        set(he2,'enable','on');
        set(hs,'enable','on');
        set(hs2,'enable','on');
%         set(hc1,'enable','on');
        

        % attach grayscale image data to window for later access
        set(h,'UserData',I);
        
        % uses the default value set in hs2 control to remove small cells
        pixlist = removesmalls(I);
        I(pixlist) = 0;

        RGB = updateRed(I); %set initial value for pixel selection
        figure, imshow(RGB,'InitialMagnification',67)

        figure_handle = imgcf; % get the figure handle for distorted image
        set(figure_handle,'UserData',I); % update image
        
        set(hopen,'visible','off'); % turn the open button off
        set(hset,'visible','on'); % turn the set button on

    end

%     function hc1Callback(hObject, eventdata)
%             
%             % Update image to mirror or unmirror
%             I = get(h,'UserData'); 
%             RGB = updateRed(I);
%             axes_handle = get(imgcf,'CurrentAxes');
%             set(get(axes_handle,'children'),'CData',RGB);
% 
%     end


    function hsCallback(hObject, eventdata)

        set(he1,'String',num2str(round(get(hs,'Value')))); %update edit box
        
        %update image with new threshold input
        I = get(h,'UserData');        
        RGB = updateRed(I);
%         figure_handle = imgcf;
%         set(figure_handle,'UserData',RGB); % update figure

        axes_handle = get(imgcf,'CurrentAxes');
        set(get(axes_handle,'children'),'CData',RGB);

    end

    function hs2Callback(hObject, eventdata)
        
        %update if small cells are updated
        set(he2,'String',num2str(round(get(hs2,'Value')))); 
        I = get(h,'UserData'); 

        RGB = updateRed(I);
        axes_handle = get(imgcf,'CurrentAxes');
        set(get(axes_handle,'children'),'CData',RGB);

    end

    function he1Callback(hObject, eventdata)
        
        % update if new threshold is typed into the edit box
        set(hs,'Value',str2num(get(he1,'String')));
        I = get(h,'UserData');
        
        RGB = updateRed(I);
        axes_handle = get(imgcf,'CurrentAxes');


%         if get(hs,'visible','on')
%             set(get(axes_handle,'children'),'CData',RGB);
%         end

    end

    function he2Callback(hObject, eventdata)


        set(hs2,'Value',str2num(get(he2,'String')));
        I = get(h,'UserData');
        RGB = updateRed(I);
        axes_handle = get(imgcf,'CurrentAxes');

%         if get(hs,'visible','on')
%             set(get(axes_handle,'children'),'CData',RGB);
%         end

    end

    function hsetCallback(hObject, eventdata)

        % get orignal image data
        I = get(h,'UserData');
        udim = size(I,2);
        vdim = size(I,1);

        % turn on working text
        set(hWorking,'visible','on');
        pause(0.1);
        
%         % flip data if needed
%         if get(hc1,'value') == 1
%             I = fliplr(I);
%         end
        
        % get pixel list for small cells and turn them black
        cleancells = get(hs2,'UserData');
        I(cleancells) = 0;        

        % get the level chosen by the user
        level = get(hs,'Value')/255;

        % convert original image to black and white
        bw = im2bw(I,level);
        bw3 = cat(3,bw,bw,bw);

        % update figure
        axes_handle = get(imgcf,'CurrentAxes');
        set(get(axes_handle,'children'),'CData',bw3);

        % get centroid data from grid image
        bwlabeled = bwlabel(bw,4);
        celldata = regionprops(bwlabeled,'Centroid');
        centroids = cat(1,celldata.Centroid);

        %find the centroid closest to the center of the image
        [m,n] = size(bw);
        dist = rnorm([centroids(:,1)-m/2 centroids(:,2)-n/2]);
        idx = find(dist == min(dist));

        cp = centroids(idx,:); % set current point to

        % determine if grid cells are staggered or square
        % if sm is below 0.08, then it is the non-staggered grid
        [six,sm] = adjCells(cp,centroids); 
        [four] = adj4Cells(cp,centroids);
        
        if sm > 0.08

            %determine grid orientation
            offsets = [four(:,1)-cp(1) four(:,2)-cp(2)];
            ang1 = atan(offsets(:,2)./offsets(:,1));
            for i = 1:4
                if ang1(i) < 0
                    ang1(i) = ang1(i)+pi/2;
                end
            end
            ang1 = rad2deg(mean(ang1));

            % rotate image
            bwlabeled = imrotate(bwlabeled,ang1,'nearest','crop');

            %redo steps from above on rotated image
            celldata = regionprops(bwlabeled,'Centroid');
            centroids = cat(1,celldata.Centroid);
            [m,n] = size(bw);
            dist = rnorm([centroids(:,1)-m/2 centroids(:,2)-n/2]);
            idx = find(dist == min(dist));
            cp = centroids(idx,:);
            [four] = adj4Cells(cp,centroids);
            %unrotate image and data
            
            [BasePoints,InputPoints,dY,dX,dOffY] = getPts4(cp,centroids,four);
            dX = NaN;
            dOffY = NaN;            

            % move rotation point to center of the image
            BasePoints(:,1) = BasePoints(:,1) - (udim/2);
            BasePoints(:,2) = BasePoints(:,2) - (vdim/2);
            InputPoints(:,1) = InputPoints(:,1) - (udim/2);
            InputPoints(:,2) = InputPoints(:,2) - (vdim/2);

            % rotate the data ang degrees (clockwise)
            rotm = [cosd(-ang1) -sind(-ang1); sind(-ang1) cosd(-ang1)];
            BasePoints = BasePoints*rotm;
            InputPoints = InputPoints*rotm;

            % move the data back to image coordinate system
            BasePoints(:,1) = BasePoints(:,1) + (udim/2);
            BasePoints(:,2) = BasePoints(:,2) + (vdim/2);
            InputPoints(:,1) = InputPoints(:,1) + (udim/2);
            InputPoints(:,2) = InputPoints(:,2) + (vdim/2);
        else
            % determine image orientation
            horiz = min(abs(six(:,1)-cp(1)));
            vert = min(abs(six(:,2)-cp(2)));
            
            % if grid is horizontal, rotate the image
            if horiz > vert
                bwlabeled = imrotate(bwlabeled,-90);

                %redo processing on rotated image
                celldata = regionprops(bwlabeled,'Centroid');
                centroids = cat(1,celldata.Centroid);
                [m,n] = size(bw);
                dist = rnorm([centroids(:,1)-m/2 centroids(:,2)-n/2]);
                idx = find(dist == min(dist));
                cp = centroids(idx,:); 
                [six,sm] = adjCells(cp,centroids);
            end
        
            [BasePoints,InputPoints,dY,dX,dOffY] = getPts6(cp,centroids,six);

            if horiz > vert  
                
                % move rotation point to center of the image
                BasePoints(:,1) = BasePoints(:,1) - (udim/2);
                BasePoints(:,2) = BasePoints(:,2) - (vdim/2);
                InputPoints(:,1) = InputPoints(:,1) - (udim/2);
                InputPoints(:,2) = InputPoints(:,2) - (vdim/2);
                
                %BasePoints = BasePoints - 512; this was specific to xray
                %InputPoints = InputPoints - 512; 
                
                % rotate the data 90 degrees (clockwise)
                rotm = [cosd(90) -sind(90); sind(90) cosd(90)];                
                BasePoints = BasePoints*rotm;
                InputPoints = InputPoints*rotm;
                
                % move the data back to original rotation point
                BasePoints(:,1) = BasePoints(:,1) + (udim/2);
                BasePoints(:,2) = BasePoints(:,2) + (vdim/2);
                InputPoints(:,1) = InputPoints(:,1) + (udim/2);
                InputPoints(:,2) = InputPoints(:,2) + (vdim/2);
              
            end
            
        end
 
        set(hWorking,'visible','off');        

        set(0,'CurrentFigure',imgcf)
        hold on
        plot(InputPoints(:,1),InputPoints(:,2),'b*')        
        
 %       [BaseReduced,InputReduced] = reducePts(BasePoints,InputPoints);
        previewTform = cp2tform(InputPoints, BasePoints, 'lwm');
        preview = imtransform(I,previewTform,'Xdata',[1 udim],'Ydata',[1 vdim]);
        figure, imshow(preview)
        
        undistortTform = cp2tform(InputPoints, BasePoints, 'lwm');        
        
        %image coordinates flipped to upper right quadrant (like a graph)
        BasePointsflip(:,1)= BasePoints(:,1);
        InputPointsflip(:,1)= InputPoints(:,1);
        BasePointsflip(:,2)=vdim-BasePoints(:,2);
        InputPointsflip(:,2)=vdim-InputPoints(:,2);

        %variables that will be loaded by the digitizing program
        camud=cp2tform(BasePointsflip,InputPointsflip,'lwm');
        camud.xlim=[min(InputPointsflip(:,1)),max(InputPointsflip(:,1))];
        camud.ylim=[min(InputPointsflip(:,2)),max(InputPointsflip(:,2))];
        camd=cp2tform(InputPointsflip,BasePointsflip,'lwm');
        camd.xlim=[min(BasePointsflip(:,1)),max(BasePointsflip(:,1))];
        camd.ylim=[min(BasePointsflip(:,2)),max(BasePointsflip(:,2))];

        [pathname, filename, ext, version] = fileparts(get(hopen,'UserData'));
        
        [file,path] = uiputfile('*.mat','Save Workspace As',...
            [pathname,filesep,filename,'UNDTFORM']);
        save([path,file], 'InputPoints', 'BasePoints','undistortTform',...
            'dY','dX','dOffY','BasePointsflip','InputPointsflip','camud',...
            'camd');
        
        [fim,pim] = uiputfile([pathname,filesep,filename,'UND.tiff'],'Save image As');
        imwrite(preview,[pim,filesep,fim],'tiff');        
        

    end

    function [RGB] = updateRed(I)
        
%         if get(hc1,'Value') == 1 % flip image if checkbox is checked
%             I = fliplr(I);
%         end
            
        pixlist = removesmalls(I); % remove small cells
        I(pixlist) = 0; % turn small cell pixels black        
        
        Ir = I;
        Ib = I;
        Ig = I;
        idx = find(I > (get(hs,'Value')));
        Ir(idx) = 255;
        Ib(idx) = 0;
        Ig(idx) = 0;
        RGB = cat(3,Ir,Ib,Ig);
    end

    function [pixelList] = removesmalls(I)

        level = get(hs,'Value')/255;
        udim = size(I,2);
        vdim = size(I,1);

        % create black/white image and extract information
        bw = im2bw(I,level);
        bwlabeled = bwlabel(bw,4);
        celldata = regionprops(bwlabeled,'Area','BoundingBox','PixelIdxList');

        sizeLim = get(hs2,'value');% get the size limit from hs2

        %get areas and bounding boxes
        areas = cat(1,celldata.Area);
        bb= cat(1,celldata.BoundingBox);

        % select pixels with edge touching cells
        idx = find(bb(:,1) == 0.5 | bb(:,1)+bb(:,3) > udim-0.5 |...
            bb(:,2) == 0.5 | bb(:,2)+bb(:,4) > vdim-0.5 );
        edgeTouchingCells = celldata(idx);
        pixlist = cat(1,edgeTouchingCells.PixelIdxList);

        % select small cell pixels
        idx = find(areas < sizeLim);
        smallcells = celldata(idx);

        %stack the two lists
        pixelList = cat(1,pixlist, cat(1,smallcells.PixelIdxList));
        set(hs2,'UserData',pixelList);

    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%Non-Staggered Grid Procedure %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [BasePoints,InputPoints,dY,dX,dOffY] = getPts4(cp,centroids,four)

        % set first point to the point closest to the center of the image
        BasePoints = cp;
        InputPoints = cp;

        % set the cell center to center distance
        dY = mean(rnorm([four(:,1)-cp(1) four(:,2)-cp(2)]));
        dX = NaN;
        dOffY = NaN;
        
        % establish base points to undisort the quadrants.
        r = four(2,:); %get the initial right cell for 1st quadrant
        f.q1 = four(1,:);
        f.q2 = four(3,:);
        f.q3 = four(4,:);

        cp = four(1,:);
        [four] = adj4Cells(cp,centroids);
        f.q4 = four(4,:);

        cp = four(3,:);


        i = 2;
        ychk = 1; % used to check for edge on y image axis
        xchk = 1; % used to check for edge on y image axis
        col = 1; a = 1; b = 2; c = -1; d = 1;

        for j = 1:4

            while xchk == 1

                while ychk == 1

                    [four] = adj4Cells(cp,centroids);

                    angles = rad2deg(atan2(four(:,2)-cp(2),four(:,1)-cp(1)));
                    ychk = ycheck(angles);
                    if ychk == 0
                        break
                    end

                    cp = four(a,:);
                    InputPoints(i,:) = cp;
                    BasePoints(i,1) = BasePoints(i-1,1);
                    BasePoints(i,2) = BasePoints(i-1,2)+c*dY;
                    i = i+1;
                end
                
                cp = r;
                [four] = adj4Cells(cp,centroids);

                angles = rad2deg(atan2(four(:,2)-cp(2),four(:,1)-cp(1)));
                xchk = ycheck(angles);
                if xchk == 0
                    break
                end

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)+(d*dY)*col;
                if j ==1 || j == 3
                    BasePoints(i,2) = BasePoints(1,2);
                elseif j == 2
                    BasePoints(i,2) = BasePoints(1,2)+dY;                   
                elseif j == 4
                    BasePoints(i,2) = BasePoints(1,2)-dY;  
                end

                r = four(b,:);

                i = i + 1;
                col = col + 1;
                ychk = 1;

            end

            if j == 1

                cp = f.q2;
                [four] = adj4Cells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1);
                BasePoints(i,2) = BasePoints(1,2)+dY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 3; b = 2; c = 1; d = 1;

                r = four(b,:);

            elseif j == 2

                cp = f.q3;
                [four] = adj4Cells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dY;
                BasePoints(i,2) = BasePoints(1,2);
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 2; a = 3; b = 4; c = 1; d = -1;

                r = four(b,:);

            elseif j == 3

                cp = f.q4;
                [four] = adj4Cells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dY;
                BasePoints(i,2) = BasePoints(1,2)-dY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 2; a = 1; b = 4; c = -1; d = -1;

                r = four(b,:);

            end

        end

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Staggered Grid Procedure %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [BasePoints,InputPoints,dY,dX,dOffY] = getPts6(cp,centroids,six)

        % get matrix of points for staggered cells
        BasePoints = cp;
        InputPoints = cp;

        % set the cell center to center distance
        dY = mean(rnorm([six(:,1)-cp(1) six(:,2)-cp(2)]));
        dX = cosd(30)*dY; 
        dOffY = sind(30)*dY;

        % establish base points to undisort the quadrants.
        r = six(2,:); %get the initial right cell for 1st quadrant
        f.q1 = six(1,:);
        f.q2 = six(4,:);
        f.q3 = six(6,:);
        f.q4 = six(5,:);

        i = 2;
        ychk = 1; % used to check for edge on y image axis
        xchk = 1; % used to check for edge on y image axis
        col = 1; a = 1; b = 2; c = -1; d = 1;

        for j = 1:4
            while xchk == 1
                while ychk == 1

                    [six,sm] = adjCells(cp,centroids);

                    angles = rad2deg(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));
                    ychk = ycheck(angles);
                    if ychk == 0
                        break
                    end

                    cp = six(a,:);
                    InputPoints(i,:) = cp;
                    BasePoints(i,1) = BasePoints(i-1,1);
                    BasePoints(i,2) = BasePoints(i-1,2)+c*dY;
                    i = i+1;
                end             
   
                cp = r;
               
                [six,sm] = adjCells(cp,centroids);

                angles = rad2deg(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));
                xchk = ycheck(angles);
                if xchk == 0
                    break
                end

               
                
                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)+(d*dX)*col;
                if j == 3 || j == 4
                    BasePoints(i,1) = BasePoints(1,1)+(d*dX)*(col+1);
                end
                
                col = col + 1;                  
                
                if j == 1
                    if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2)-dOffY;
                    else
                        BasePoints(i,2) = BasePoints(1,2);
                    end
                elseif j == 2
                    if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2)+dOffY;
                    else
                        BasePoints(i,2) = BasePoints(1,2)+dY;
                    end
                elseif j == 3
                    if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2);
                    else
                        BasePoints(i,2) = BasePoints(1,2)+dOffY;
                    end                    
                elseif j == 4
                   if rem(col,2) == 0
                        BasePoints(i,2) = BasePoints(1,2)-dY;
                    else
                        BasePoints(i,2) = BasePoints(1,2)-dOffY;
                    end                    
                end
               
                if rem(col,2) == 0
                    r = six(b+1,:);
                else
                    r = six(b,:);
                end
                    

                i = i + 1;
                ychk = 1;

            end

            if j == 1

                cp = f.q2;
                [six] = adjCells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1);
                BasePoints(i,2) = BasePoints(1,2)+dY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 4; b = 2; c = 1; d = 1;

                r = six(b,:);

            elseif j == 2

                cp = f.q3;
                [six] = adjCells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dX;
                BasePoints(i,2) = BasePoints(1,2)+dOffY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 4; b = 5; c = 1; d = -1;

                r = six(b,:);

            elseif j == 3

                cp = f.q4;
                [six] = adjCells(cp,centroids);

                InputPoints(i,:) = cp;
                BasePoints(i,1) = BasePoints(1,1)-dX;
                BasePoints(i,2) = BasePoints(1,2)-dOffY;
                i = i+1;

                ychk = 1;
                xchk = 1;
                col = 1; a = 1; b = 5; c = -1; d = -1;

                r = six(b,:);

            end

        end

    end

    function [four] = adj4Cells(cp,centroids)

        % returns the 4 closest cells to cp reorders so that 1st row is
        % always up then moves clockwise 2=right 3=down 4=left

        dist = rnorm([centroids(:,1)-cp(1) centroids(:,2)-cp(2)]);
        r = sort(dist);
        r = r(2:5);
        
        idx = find(dist == r(1) | dist == r(2) | dist == r(3) | dist == r(4));
            
        four = centroids(idx,:);

        % reorder four
        angles = atan2(four(:,2)-cp(2),four(:,1)-cp(1));

        idx = find(abs(angles+pi/2)==min(abs(angles+pi/2)));
        U = four(idx,:);
        idx = find(abs(angles)==min(abs(angles)));
        R = four(idx,:);
        idx = find(abs(angles-pi/2)==min(abs(angles-pi/2)));
        D = four(idx,:);
        idx = find(abs(abs(angles)-pi) == min(abs(abs(angles)-pi)));
        L = four(idx,:);

        four = [U;R;D;L];



    end

    function [six,sm] = adjCells(cp,centroids)

        % returns the 6 closest cells to cp
        dist = rnorm([centroids(:,1)-cp(1) centroids(:,2)-cp(2)]);
        r = sort(dist);
        r = r(2:7);
        
        idx = find(dist == r(1) | dist == r(2) | dist == r(3)...
            | dist == r(4)| dist == r(5)| dist == r(6));
            
        six = centroids(idx,:);
        
        sm = std(r)/mean(r);
        
        % reorder six
        % angles in radians from the center point to each of the six points
        angles = rad2deg(atan2(six(:,2)-cp(2),six(:,1)-cp(1)));

        idx = find(abs(angles+90)==min(abs(angles+90)));
        U = six(idx,:);
        idx = find(abs(angles+30)==min(abs(angles+30)));
        UR = six(idx,:);
        idx = find(abs(angles-30)==min(abs(angles-30)));
        DR = six(idx,:);
        idx = find(abs(angles-90)==min(abs(angles-90)));
        D = six(idx,:);
        idx = find(abs(angles-150)==min(abs(angles-150)));
        DL = six(idx,:);
        idx = find(abs(angles+150)==min(abs(angles+150)));
        UL = six(idx,:);

        six = [U;UR;DR;D;UL;DL];

    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [ychk] = ycheck(angles)
        
        ychk = 1;

        if length(angles) == 4
           
            a = [90;0;90;180];
            
            for i = 1:4
                
            hdiff = a(i) - abs(angles(i));
            if  hdiff > 20 || hdiff < -20
                ychk = 0;
            end
            end

        elseif length(angles) == 6
            
            a = [90;30;30;90;150;150];
            
            for i = 1:6
                
            hdiff = a(i) - abs(angles(i));
            if  hdiff > 20 || hdiff < -20
                ychk = 0;
            end
            end

        else
            return
            ychk = 0;
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [BaseReduced,InputReduced] = reducePts(BasePoints,InputPoints)
        
        onumpts = length(BasePoints);
        
        if onumpts < 700
        factor = 1;
        elseif onumpts >= 700 && onumpts < 1000
            factor = 1;
        elseif onumpts >= 1000 && onumpts < 1500
            factor = 2;
        elseif onumpts >= 1500 && onumpts < 2000
            factor = 3;
        elseif onumpts >= 2000 && onumpts < 2500
            factor = 4; 
        elseif onumpts >= 2500 && onumpts < 3000
            factor = 5;  
        else
            factor = 6;
        end
        
        numPoints = round(length(BasePoints)/factor);
        numPoints = numPoints -10;
        
        BaseReduced = BasePoints(1,:);
        for i = 1:numPoints
            BaseReduced(i+1,:) = BasePoints(i*factor,:);
        end
        
        InputReduced = InputPoints(1,:);
        for i = 1:numPoints
            InputReduced(i+1,:) = InputPoints(i*factor,:);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [image]=calimread(fpathname)

        % function [image]=calimread(fpathname)
        %
        % Reads and returns a calibration image

        % check the file extension
        if strcmp('avi',lower(fpathname(end-2:end)))
            mov=aviread(fpathname,1);
            image=mov.cdata(:,:,1);
        else
            image=imread(fpathname);
            image=image(:,:,1);
        end
    end

end