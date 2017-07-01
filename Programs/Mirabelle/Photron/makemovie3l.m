% makemovie

clear all

[filename, pathname] = uiGetFiles;
shiftname= input('name of the shift file (without extension)','s');
shiftfile=[pathname shiftname];
load(shiftfile); %this loads the shift-file
n=length(filename); % # of images

name = input('Movie name:','s')
mov = avifile([name '.avi'],'compression','none','quality',100,'fps',5)

% figure properties
set(0,'Units','pixels') 
scrnsize = get(0,'ScreenSize');
f1 = figure('Color','w','Name','Original Image');

% loading the images and finding the scale

for i=1:n
    curfile = [pathname char(filename(i,:))];
    keke(:,:,i) = double(imread(curfile))-double(shift);

end

    cmin=min(min(min(keke)));
    cmax=max(max(max(keke)));
    
for i=1:n
    im(:,:) = keke(:,:,i);
    sim = size(im);


    % figures properties
    width = sim(1); % width of the figure
    height= sim(2); % height of the figure
    %pos  = [100, 0.5*scrnsize(4) + 10, width, height];
   
    figure(f1);
    set(gcf, 'color','w');
    imagesc(im);
    caxis([cmin cmax])
    colorbar;
  
    colormap(pastell)
    
    F = getframe;
    mov = addframe(mov,F);
 
end

mov = close(mov)