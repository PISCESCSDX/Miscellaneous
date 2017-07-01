function stacktif(pathname,outfile,del)
% stacktif(pathname, outfile, del)
%  pathname is the full path
%  outfile is the desired file name (including *.tif extension)
%  del = 1 if you want to delete the original tif images

% get the names of the tif files in the path
tif_files=ls(fullfile(pathname,'*.tif'));
if size(tif_files,1)==0
    tif_files=ls(fullfile(pathname,'*.tiff'));
end

% create the full path and filename for the outfile
outfile=fullfile(pathname,outfile);

% loop through all the tif files
for i=1:size(tif_files,1)
    
    % display each tif file as it is 'stacked'
    infile=fullfile(pathname,tif_files(i,:));
    display([tif_files(i,:) ' - File ' num2str(i) ' of ' num2str(i)])
    
    % load each tif file as it is 'stacked'
    I_tiff=imread(infile);
    
    % write tif stack
    if i==1
        imwrite(I_tiff,outfile,'tif','Compression','packbits','WriteMode','overwrite')
    else
        imwrite(I_tiff,outfile,'tif','Compression','packbits','WriteMode','append')
    end
    
    % delete original tif file if desired
    if del==1
        delete(infile);
    end
    
end