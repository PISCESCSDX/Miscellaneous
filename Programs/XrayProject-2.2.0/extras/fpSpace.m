function [output] = fpSpace

% inputs:  data = xyzpts
%          

% get the xyz data
[fdata,pdata]=uigetfile('*xyzpts.csv','Select the [prefix]xyzpts.csv file');
data = dlmread([pdata,fdata],',',1,0);

for i=1:size(data,2)/3
      colheaders{i*3-2}=sprintf('pt%s_X',num2str(i));
      colheaders{i*3-1}=sprintf('pt%s_Y',num2str(i));
      colheaders{i*3-0}=sprintf('pt%s_Z',num2str(i));
    end


%change directory
cd(pdata);

% load force plate space
load 'C:\Documents and Settings\clifford\My Documents\Pig Files\cube2forceMatrix.mat' 

% create output matrix
output = zeros(size(data));

% for each marker
for i = 1:size(data,2)/3
    tmp = data(:,i*3-2:i*3);
    
    % for each timestep
    for j = 1:size(data,1)
        % calculate new point
    	output(j,i*3-2:i*3) = (tmp(j,:)-t)*R;
    end
end

% save path and file name
    [pout, fout, ext, version] = fileparts([pdata,fdata]);
    [fdata,pdata] = uiputfile('*.csv','Save Bone Data As',...
        [pout,filesep,fout,'FORCESPACE',ext]);
    
    csvWithHeaders([pdata,fdata],output,colheaders)

    