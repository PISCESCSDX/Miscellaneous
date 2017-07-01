function flipCoordinateSystem()

%user friendly version to open 

% get the xyclicks from the calibration
[fname,pname]=uigetfile('*.csv','Select the [prefix]xypts.csv file');

%get the headers
fid = fopen([pname,fname],'r');
tline = fgets(fid);
headers = textscan(tline,'%s %s',2,'delimiter',',');
fidclose = fclose(fid);

%get the headers in a format that fprintf will use
for i = 1:prod(size(headers))
    headers{i} = headers{i}{1};
end

%read the data
old=dlmread([pname,fname],',',1,0);

%flip the coordinates
new = coordFlipxy(old);

%save path and file name
[fout,pout] = uiputfile('*.csv','Save Bone Data As',...
    [pname,'M',fname]);

%open new file for writing
f1 = fopen([pout,fout],'w');

% write headers
for i = 1:prod(size(headers)) - 1
    fprintf(f1,'%s,',headers{i});
end
fprintf(f1,'%s\n',headers{end});

% write data
for i = 1:size(new,1)
    tempdata = squeeze(new(i,:));
    for j = 1:size(tempdata,2)-1
        fprintf(f1,'%.6f,',tempdata(j));
    end
    fprintf(f1,'%.6f\n',tempdata(end));
end

%close the file
fclose(f1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [new] = coordFlipxy(orig)

%change calibration points to get a left handed coordinate system to a
%right handed system
%
% INPUT: orig = xy clicks from calibration cube
% OUTPUT: new = renumbers the calibration cube points
%
% for example: points 1:4 are moved to 49 to 52

new(1:4,:) = orig(1:4,:);
new(5:8,:) = orig(17:20,:);
new(9:12,:) = orig(33:36,:);
new(13:16,:) = orig(49:52,:);
new(17:20,:) = orig(5:8,:);
new(21:24,:) = orig(21:24,:);
new(25:28,:) = orig(37:40,:);
new(29:32,:) = orig(53:56,:);
new(33:36,:) = orig(9:12,:);
new(37:40,:) = orig(25:28,:);
new(41:44,:) = orig(41:44,:);
new(45:48,:) = orig(57:60,:);
new(49:52,:) = orig(13:16,:);
new(53:56,:) = orig(29:32,:);
new(57:60,:) = orig(45:48,:);
new(61:64,:) = orig(61:64,:);


