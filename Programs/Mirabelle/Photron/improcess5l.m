% improcess5l: load images from a dialog box, removes the background summed
% over all the images, and saves the resulting images in the same directory
% The resulting movie is played once, and can be save as an .avi file
% The saved images are shifted to positive values, so that the conversion
% to uint-numbers doesn't truncate the negative values. The following
% programs have to substract this shift to recover the original values
% The shift is saved in a mat-file.
% (C) F. Brochard 04/2008, version 10/2009

clear all

[filename, pathname] = uiGetFiles;

test = ischar(filename);
infos=aviinfo([pathname char(filename)]);
framewidth = infos.Width;
frameheight= infos.Height;

makemovie = input('Do you want to record a video (y/n) ?','s');
n = input('Howmany images ?');

% loading the images and making the averaged image
disp('Loading the files...')
before=zeros(framewidth, frameheight, n);
after=zeros(framewidth, frameheight, n);
% peut-être à intervertir!

for i=1:n
    %curfile = [pathname char(filename(i,:))];
    before(:,:,i) = double(aviread([pathname char(filename)],i));
end

aver=mean(before,3); % averaged image
aver=double(aver);
shift=max(max(aver));

figure;set(gcf,'color','w');

if makemovie=='y'
    mov = avifile('movie.avi','compression','none','quality',100,'fps',5);
end
disp('- done')
disp('Removing background...')
% remove the averaged image and save the corresponding images
for i=1:n
    after(:,:,i)=before(:,:,i)-aver;
end

cmin=min(min(min(after)));
cmax=max(max(max(after)));

for i=1:n
    fin(:,:) = after(:,:,i);
    nomfin=[pathname 'a' char(filename(i,:))]; %name of the saved files
    imwrite(uint16(fin+shift),nomfin,'tif');
    
    %imagesc(after(:,:,i)); 
    
    imagesc(fin);    
    caxis([cmin cmax])
    colorbar;
    colormap(pastell)
    %colormap(jet)
    

    
    F = getframe;
    if makemovie=='y'        
        mov = addframe(mov,F);
    end
end

disp('- done')
if makemovie=='y'
    mov = close(mov);
else
    movie(F,1,4)
end

shiftname = input('name of the shift file:','s');
save(shiftname,'shift');
