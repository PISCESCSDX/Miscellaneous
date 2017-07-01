function updateMirror

[fname1,pname1]=uigetfile('*.mat','Select camera1 Undistortion Transform File');

cd(pname1);

[fname2,pname2]=uigetfile('*.mat','Select camera2 Undistortion Transform File');
[fc1,pc1]=uigetfile('*.csv','Select the camera1 xypts calibration file');
[fc2,pc2]=uigetfile('*.csv','Select the camera2 xypts calibration file');
[specfile,specpath]=uigetfile({'*.csv','comma separated values'}, ...
			'Please select your calibration object specification file');
[digfile,digpath]=uigetfile('*.csv','Select the xypts from digitized data');



load([pname1,fname1]);

        if exist('BasePoints') == 0
            BasePoints = base_points;
            InputPoints = input_points;
            clear *_points;
        end

BasePoints = mirrorx(BasePoints);
InputPoints = mirrorx(InputPoints);
        BasePointsflip(:,1)= BasePoints(:,1);
        InputPointsflip(:,1)= InputPoints(:,1);
        BasePointsflip(:,2)=1024-BasePoints(:,2);
        InputPointsflip(:,2)=1024-InputPoints(:,2);
        cam1ud=cp2tform(BasePointsflip,InputPointsflip,'lwm');
        cam1ud.xlim=[min(InputPointsflip(:,1)),max(InputPointsflip(:,1))];
        cam1ud.ylim=[min(InputPointsflip(:,2)),max(InputPointsflip(:,2))];
        cam1d=cp2tform(InputPointsflip,BasePointsflip,'lwm');
        cam1d.xlim=[min(BasePointsflip(:,1)),max(BasePointsflip(:,1))];
        cam1d.ylim=[min(BasePointsflip(:,2)),max(BasePointsflip(:,2))];

undistortTform = cp2tform(InputPoints, BasePoints, 'lwm');

c1tform = cam1ud;

[file,path] = uiputfile('*.mat','Save Workspace As',...
    [pname1,'mirrorC1UNDTFORM']);
save([path,file], 'InputPoints', 'BasePoints','undistortTform');

clear BasePoints* InputPoints* undistortTform;
pause(0.1);

load([pname2,fname2]);

        if exist('BasePoints') == 0
            BasePoints = base_points;
            InputPoints = input_points;
            clear *_points;
        end

BasePoints = mirrorx(BasePoints);
InputPoints = mirrorx(InputPoints);
        BasePointsflip(:,1)= BasePoints(:,1);
        InputPointsflip(:,1)= InputPoints(:,1);
        BasePointsflip(:,2)=1024-BasePoints(:,2);
        InputPointsflip(:,2)=1024-InputPoints(:,2);
        cam2ud=cp2tform(BasePointsflip,InputPointsflip,'lwm');
        cam2ud.xlim=[min(InputPointsflip(:,1)),max(InputPointsflip(:,1))];
        cam2ud.ylim=[min(InputPointsflip(:,2)),max(InputPointsflip(:,2))];
        cam2d=cp2tform(InputPointsflip,BasePointsflip,'lwm');
        cam2d.xlim=[min(BasePointsflip(:,1)),max(BasePointsflip(:,1))];
        cam2d.ylim=[min(BasePointsflip(:,2)),max(BasePointsflip(:,2))];

undistortTform = cp2tform(InputPoints, BasePoints, 'lwm');

c2tform = cam2ud;

[file,path] = uiputfile('*.mat','Save Workspace As',...
    [pname2,'mirrorC2UNDTFORM']);
save([path,file], 'InputPoints', 'BasePoints','undistortTform');

clear BasePoints InputPoints undistortTform

calpts1 = dlmread([pc1,fc1],',',1,0);
calpts2 = dlmread([pc2,fc2],',',1,0);
calpts1 = mirrorx(calpts1);
calpts2 = mirrorx(calpts2);
calpts1 = coordFlipxy(calpts1);
calpts2 = coordFlipxy(calpts2);


specdata = dlmread([specpath,specfile],',',1,0); % read in the calibration file

numPts=size(specdata,1);
coefs1 = dltfu(specdata,calpts1);
coefs2 = dltfu(specdata,calpts2);
uda.dltcoef = cat(2,coefs1,coefs2);

uda.nvid = 2;

% dltcoefs
[file,path] = uiputfile('*.csv','Save Coeffecients As',...
    [pname2,'MDLTcoefs.csv']);
dlmwrite([path,file],uda.dltcoef,',');
[pn, fnonly, ext, versn] = fileparts([path,file]);
dlmwrite([pn,filesep,fnonly,'c1',ext],coefs1,',');
dlmwrite([pn,filesep,fnonly,'c2',ext],coefs2,',');
dlmwrite([pn,filesep,fnonly,'c1xypts',ext],calpts1,',',1,0);
dlmwrite([pn,filesep,fnonly,'c2xypts',ext],calpts2,',',1,0);

digdata = dlmread([digpath,digfile],',',1,0); % read in the digitized data file
uda.offset(1:length(digdata),1:uda.nvid)=0;

digdata = mirrorx(digdata);
len=size(digdata,1);
numpts=size(digdata,2)/4; % number of points
uda.xypts=reshape(digdata,len,size(digdata,2)/numpts,numpts);


        disp('Recomputing all 3D coordinates.')
        for i=1:size(uda.xypts,3)
            foo=uda.xypts(:,:,i);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %added dedistortion (Baier 1/16/06)
            foo(:,1:2)=applyTform(c1tform,foo(:,1:2));
            foo(:,3:4)=applyTform(c2tform,foo(:,3:4));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            rawResults=reconfu(uda.dltcoef,foo);
            uda.dltpts(:,:,i)=rawResults(:,[1:3]);
            uda.dltres(:,:,i)=rawResults(:,4);
        end

    % get a place to save it
    pname=uigetdir(pwd,'Pick a directory to contain the output files');
    pause(0.1); % make sure that the uigetdir executed (MATLAB bug)

    % get a prefix
    pfix=inputdlg({'Enter a prefix for the data files'},...
      'Data prefix',1,{'trial01'});
    if prod(size(pfix))==0
      pfix='';
      return
    else
      pfix=pfix{1};
    end

    % test for existing files
    if exist([pname,filesep,pfix,'xyzpts.csv'])~=0
      overwrite=questdlg('Overwrite existing data?', ...
        'Overwrite?','Yes','No','No');
    else
      overwrite='Yes';
    end

    % create headers (dltpts)
    for i=1:size(uda.dltpts,3)
      dlth{i*3-2}=sprintf('pt%s_X',num2str(i));
      dlth{i*3-1}=sprintf('pt%s_Y',num2str(i));
      dlth{i*3-0}=sprintf('pt%s_Z',num2str(i));
    end

    % create headers (dltres)
    for i=1:size(uda.dltpts,3)
      dlthr{i}=sprintf('pt%s_dltres',num2str(i));
    end

    % create headers (xypts)
    numPts=size(uda.dltpts,3);
    for i=1:numPts
      for j=1:uda.nvid
        xyh{(i-1)*uda.nvid*2+(j*2-1)}=...
          sprintf('pt%s_cam%s_X',num2str(i),num2str(j));
        xyh{(i-1)*uda.nvid*2+(j*2)}=...
          sprintf('pt%s_cam%s_Y',num2str(i),num2str(j));
      end
    end

    % create headers (offset)
    for i=1:uda.nvid
      offh{i}=sprintf('cam%s_offset',num2str(i));
    end

    if strcmp(overwrite,'Yes')==1
      % dltpts
      f1=fopen([pname,filesep,pfix,'xyzpts.csv'],'w');
      % header
      for i=1:prod(size(dlth))-1
        fprintf(f1,'%s,',dlth{i});
      end
      fprintf(f1,'%s\n',dlth{end});

      % data
      for i=1:size(uda.dltpts,1);
        tempData=squeeze(uda.dltpts(i,:,:));
        for j=1:prod(size(tempData))-1
          fprintf(f1,'%.6f,',tempData(j));
        end
        fprintf(f1,'%.6f\n',tempData(end));
      end
      fclose(f1);


      % xypts
      f1=fopen([pname,filesep,pfix,'xypts.csv'],'w');
      % header
      for i=1:prod(size(xyh))-1
        fprintf(f1,'%s,',xyh{i});
      end
      fprintf(f1,'%s\n',xyh{end});
      % data
      for i=1:size(uda.xypts,1);
        tempData=squeeze(uda.xypts(i,:,:));
        for j=1:prod(size(tempData))-1
          fprintf(f1,'%.6f,',tempData(j));
        end
        fprintf(f1,'%.6f\n',tempData(end));
      end
      fclose(f1);

      % xyzres
      f1=fopen([pname,filesep,pfix,'xyzres.csv'],'w');
      % header
      for i=1:prod(size(dlthr))-1
        fprintf(f1,'%s,',dlthr{i});
      end
      fprintf(f1,'%s\n',dlthr{end});
      % data
      for i=1:size(uda.dltres,1);
        tempData=squeeze(uda.dltres(i,:,:));
        for j=1:prod(size(tempData))-1
          fprintf(f1,'%.6f,',tempData(j));
        end
        fprintf(f1,'%.6f\n',tempData(end));
      end
      fclose(f1);

      % offsets
      f1=fopen([pname,filesep,pfix,'offsets.csv'],'w');
      % header
      for i=1:prod(size(offh))-1
        fprintf(f1,'%s,',offh{i});
      end
      fprintf(f1,'%s\n',offh{end});
      % data
      for i=1:size(uda.offset,1);
        tempData=squeeze(uda.offset(i,:,:));
        for j=1:prod(size(tempData))-1
          fprintf(f1,'%.6f,',tempData(j));
        end
        fprintf(f1,'%.6f\n',tempData(end));
      end
      fclose(f1);

%      uda.recentlysaved=1;
%      set(h(1),'Userdata',uda); % pass back complete user data

      msgbox('Data saved.');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,avgres,rawres] = dltfu(F,L,Cut)
% Description:	Program to calculate DLT coefficient for one camera
%               Note that at least 6 (valid) calibration points are needed
%               function [A,avgres] = dltfu(F,L,Cut)
% Input:	- F      matrix containing the global coordinates (X,Y,Z)
%                        of the calibration frame
%			 e.g.: [0 0 20;0 0 50;0 0 100;0 60 20 ...]
%		- L      matrix containing 2d coordinates of calibration 
%                        points seen in camera (same sequence as in F)
%                        e.g.: [1200 1040; 1200 1360; ...]
%               - Cut    points that are not visible in camera;
%                        not being used to calculate DLT coefficient
%                        e.g.: [1 7] -> calibration point 1 and 7 
%			 will be discarded.
%		      	 This input is optional (default Cut=[]) 
% Output:	- A      11 DLT coefficients
%               - avgres average residuals (measure for fit of dlt)
%			 given in units of camera coordinates
%
% Author:	Christoph Reinschmidt, HPL, The University of Calgary
% Date:		January, 1994
% Last changes: November 29, 1996
% 		July 7, 2000 - Ty Hedick - NaN points automatically
%                 added to cut.
%		August 8, 2000 - Ty Hedrick - added raw_res output
% Version:	1.1
% References:	Woltring and Huiskes (1990) Stereophotogrammetry. In
%               Biomechanics of Human Movement (Edited by Berme and
%               Cappozzo). pp. 108-127.

if nargin==2; Cut=[]; end;

if size(F,1) ~= size(L,1)
disp('# of calibration points entered and seen in camera do not agree'), return
end

% find the NaN points and add them to the cut matrix
for i=1:size(L,1)
  if isnan(L(i,1))==1
    Cut(1,size(Cut,2)+1)=i;
  end
end

m=size(F,1); Lt=L'; C=Lt(:);

for i=1:m
  B(2*i-1,1)  = F(i,1); 
  B(2*i-1,2)  = F(i,2); 
  B(2*i-1,3)  = F(i,3);
  B(2*i-1,4)  = 1;
  B(2*i-1,9)  =-F(i,1)*L(i,1);
  B(2*i-1,10) =-F(i,2)*L(i,1);
  B(2*i-1,11) =-F(i,3)*L(i,1);
  B(2*i,5)    = F(i,1);
  B(2*i,6)    = F(i,2);
  B(2*i,7)    = F(i,3);
  B(2*i,8)    = 1;
  B(2*i,9)  =-F(i,1)*L(i,2);
  B(2*i,10) =-F(i,2)*L(i,2);
  B(2*i,11) =-F(i,3)*L(i,2);
end

% Cut the lines out of B and C including the control points to be discarded
Cutlines=[Cut.*2-1, Cut.*2];
B([Cutlines],:)=[];
C([Cutlines],:)=[];

% Solution for the coefficients
A=B\C; % note that \ is a left matrix divide
D=B*A;
R=C-D;
res=norm(R); avgres=res/size(R,1)^0.5;
rawres=R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [H] = reconfu(A,L)
%function [H] = reconfu(A,L)
% Description:	Reconstruction of 3D coordinates with the use local (camera
%		coordinates and the DLT coefficients for the n cameras).
% Input:	- A  file containing DLT coefficients of the n cameras
%		     [a1cam1,a1cam2...;a2cam1...]
%		- L  camera coordinates of points
%		     [xcam1,ycam1,xcam2,ycam2...;same at time 2]
% Output:	- H  global coordinates, residuals, cameras used
%		     [Xt1,Yt1,Zt1,residt1,cams_used@t1...; same for t2]
% Author:	Christoph Reinschmidt, HPL, The University of Calgary
% Date:		September, 1994
% Last change:  November 29, 1996
% Version:	1.1

n=size(A,2);
% check whether the numbers of cameras agree for A and L
%if 2*n~=size(L,2); disp('the # of cameras given in A and L do not agree')
%                   disp('hit any key and then "try" again'); pause; return
%end


H(size(L,1),5)=[0];         % initialize H

% ________Building L1, L2:       L1 * G (X,Y,Z) = L2________________________

for k=1:size(L,1)  %number of time points
  q=[0]; L1=[]; L2=[];  % initialize L1,L2, q(counter of 'valid' cameras)
  for  i=1:n       %number of cameras
    x=L(k,2*i-1); y=L(k,2*i);
    if ~(isnan(x) | isnan(y))  % do not construct l1,l2 if camx,y=NaN
      q=q+1;
      L1([q*2-1:q*2],:)=[A(1,i)-x*A(9,i), A(2,i)-x*A(10,i), A(3,i)-x*A(11,i); ...
        A(5,i)-y*A(9,i), A(6,i)-y*A(10,i), A(7,i)-y*A(11,i)];
      L2([q*2-1:q*2],:)=[x-A(4,i);y-A(8,i)];
    end
  end

  if (size(L2,1)/2)>1  %check whether enough cameras available (at least 2)
    g=L1\L2; h=L1*g; DOF=(size(L2,1)-3);
    avgres=sqrt(sum([L2-h].^2)/DOF);
  else
    g=[NaN;NaN;NaN]; avgres=[NaN];
  end

  %find out which cameras were used for the 3d reconstruction
  b=fliplr(find(sum(reshape(isnan(L(k,:)),2,size(L(k,:),2)/2))==0));
  if size(b,2)<2; camsused=[NaN];
  else,    for w=1:size(b,2), b(1,w)=b(1,w)*10^(w-1); end
    camsused=sum(b');
  end

  H(k,:)=[g',avgres,camsused];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ptsT]=applyTform(T,pts);

% function [ptsT]=applyTform(T,pts)
%
% Applies the inverse transform specified in T to the [x,y] points in pts
% added dedistortion (Baier 1/16/06)

ptsT=pts;

idx=find(isnan(pts(:,1))==0);

[ptsT(idx,1),ptsT(idx,2)]=tforminv(T,pts(idx,1),pts(idx,2));



