% wdenoise : wavelet filtering of a series of images
% thr: main parameter = threshold for the noise
% the image data is shifted back to its original values
% (C) F. Brochard, 04/2008, version 01/2009
clear all   % empty the workspace

lvl = 2;
wname='sym4';

%opening multiple files by calling a dialog box
[filename, pathname] = uiGetFiles;

%loading the shift value
shiftname= input('name of the shift file (without extension)','s');
shiftfile=[pathname shiftname];
load(shiftfile); %this loads the shift-file

% figures properties
set(0,'Units','pixels') 
scrnsize = get(0,'ScreenSize');
f1 = figure('Color','w','Name','Original Image');
f2 = figure('Color','w','Name','Filtered Image');

    n=length(filename);
    % start of the main loop
%inter=zeros(:,:,n);
    for i=1:n
    disp(['image # ' num2str(i)])
    % load the files
    curfile = [pathname char(filename(i,:))];
    im = double(imread(curfile))-double(shift); sim = size(im);
    
    % figures properties
    width = sim(1); % width of the figure
    height= sim(2); % height of the figure
    pos1  = [10, 0.5*scrnsize(4) + 10, width, height];
    pos2  = [pos1(1)+width+10, pos1(2) width, height];
    
    % draws the original image
    figure(f1);set(gcf, 'Position',pos1);
    image(im),colormap(pastell)
    
    %threshold analysis
    %[thr,sorh,keepapp] = ddencmp('den','wv',im);
    % De-noise image using global thresholding option.
    %denim = wdencmp('gbl',im,'sym4',2,thr,sorh,keepapp);
    %fim = wcodemat(denim);
    
    [C,S] = wavedec2(im,lvl,wname);
    [Ea,Edetails] = wenergy2(C,S);
    
    [NC,NS,cA] = upwlev2(C,S,wname);
    
    %Y = upcoef2('a',cA,wname,2); %reconstructed image at 1st order
    % draws the filtered image
    figure(f2);set(gcf, 'Position',pos2);
    %image(Y)
    pcolor(cA),shading('interp')
    colormap(pastell)
    
    wsmooth(cA);
    lis=wsmooth(cA);
    [nx, ny]=size(lis);
    [xi,yi]=meshgrid(1:.5:nx,1:.5:ny);
    inter(:,:,i)=interp2(1:ny,1:nx,lis,yi,xi);
    % saves the filtered image
    end
    shift = max(max(max(inter)));
    shiftname = input('name of the new shift file:','s');
    save(shiftname,'shift');
    for i=1:n
    nomfin=[pathname wname 'smooth' char(filename(i,:))];
    imwrite(uint16(inter(:,:,i)'+shift),nomfin); 
    end