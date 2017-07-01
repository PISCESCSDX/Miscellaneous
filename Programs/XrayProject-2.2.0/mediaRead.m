%% mediaRead

function [mov]=mediaRead(fname,frame,incolor)

% function [mov]=mediaRead(fname,frame,incolor);
%
% Wrapper function which uses aviread or cineRead depending on what type of
% file is detected.  Also performs the flipud() on the result of aviread
% and puts the cdata result from cineRead into a mov.* structure.

if strcmpi(fname(end-3:end),'.avi')
  mov=aviread(fname,frame);
  if incolor==false
    mov.cdata=flipud(mov.cdata(:,:,1));
  else
    for i=1:size(mov.cdata,3)
      mov.cdata(:,:,i)=flipud(mov.cdata(:,:,i));
    end
  end
elseif strcmpi(fname(end-3:end),'.cin')
  mov.cdata=cineRead(fname,frame);
elseif strcmpi(fname(end-4:end),'.cine')
  mov.cdata=cineRead(fname,frame);
else
  mov=[];
  disp('mediaRead: bad file extension')
end
