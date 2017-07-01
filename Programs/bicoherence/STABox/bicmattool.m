function [lxy] = bicmattool(f1, f2, bicmat);
% Finds in a bicoherence matrix the lines.
% 5 points: 1. left top, 2. right top 3. middle left, 
%           4. middle right, 5. midlow left 6. lower right
%
% IN: f1: vector: with frequency 1
%         vector: with frequency 2
%         bicmat: bicoherence matrix
%OUT: lines: matrix with point coordinates: 
%         [lty ltx; rty rtx; mly mlx; mry mrx; lry lrx]

[m n] = size(bicmat);

a = ~isnan(bicmat);
% remove boundary
a(1,:)=0;
a(end,:)=0;
a(:,1)=0;
a(:,end)=0;

% 1. point: find-loop for the point at the left top
ctrx = 5;
ctry = m;
status = 0;
while status==0
  ctrx=ctrx+1;
  if ctrx==n+1
    ctrx=1;
    ctry=ctry-1;
  end;
  if a(ctry, ctrx)==1
    status=1;
  end;
  % check for NaN-lines  
  if sum(a(ctry,:))>0.9*length(a(ctry,:))
    ctry=ctry-1;
    ctrx=ctrx-1;
    status=0;
  end;
end;
lines = [ctry ctrx];

% 2. point: find-loop for the point at the right top
ctrx = n-5;
ctry = m;
status = 0;
while status==0
  ctrx=ctrx-1;
  if ctrx==0
    ctrx=n;
    ctry=ctry-1;
  end;
  if a(ctry, ctrx)==1
    status=1;
  end;
  % check for NaN-lines
  if sum(a(ctry,:))>0.9*length(a(ctry,:))
    ctry=ctry-1;
    ctrx=ctrx-1;
    status=0;
  end;  
end;
lines = [lines; ctry ctrx];

%find the zero-line-y-positions: y0up and y0low
ytop = lines(1,1);
xmid = lines(1,2);
ctrx = xmid;
ctry = ytop+1;
status = 0;
while status==0
  ctry = ctry-1;
  if a(ctry, ctrx)==0
    status=1;
  end;
end;
y0up = ctry+1;
%
status = 0;
while status==0
  ctry=ctry-1;
  if a(ctry, ctrx)==1
    status=1;
  end;
end;
y0low = ctry;

% 3. point: find-loop for the point at the middle left
ctrx = 0;
ctry = y0up;
status = 0;
while status==0
  ctrx=ctrx+1;
  if a(ctry, ctrx)==1
    status=1;
  end;
end;
lines = [lines; ctry ctrx];

% 4. point: find-loop for the point at the middle right
ctrx = n+1;
ctry = y0up;
status = 0;
while status==0
  ctrx=ctrx-1;
  if a(ctry, ctrx)==1
    status=1;
  end;
end;
lines = [lines; ctry ctrx];

% 5. point: find-loop for the point in the mid lower left corner
ctrx = 0;
ctry = y0low;
status = 0;
while status==0
  ctrx=ctrx+1;
  if a(ctry, ctrx)==1
    status=1;
  end;
end;
lines = [lines; ctry ctrx];

% 6. point: find-loop for the point in the right lower corner
ctrx = 5;
ctry = 1;
status = 0;
while status==0
  ctrx=ctrx+1;
  if ctrx==n+1
    ctrx=6;
    ctry=ctry+1;
  end;
  if a(ctry, ctrx)==1
    status=1;
  end;
end;
lines = [lines; ctry ctrx];

pix = lines(2,2)-lines(1,2)+1;

% df1 = f1(1+pix)-f1(1);
% df2 = f2(1+pix)-f2(1);
lxy(1,1)=f1(lines(1,2));
%lxy(1,2)=f1(lines(3,2))-df1;

if (lines(3,2)-pix)<1
  a=1;
else
  a=lines(3,2)-pix;
end;
lxy(1,2)=f1(a);
lxy(1,3)=f2(lines(1,1));
lxy(1,4)=f2(lines(3,1));
lxy(2,1)=f1(lines(2,2));

if (lines(4,2)+pix)>n
  a=n;
else
  a=lines(4,2)+pix;
end;
lxy(2,2)=f1(a);
lxy(2,3)=f2(lines(2,1));
lxy(2,4)=f2(lines(4,1));

if (lines(5,2)-pix)<1
  a=1;
else
  a=lines(5,2)-pix;
end;
lxy(3,1)=f1(a);
lxy(3,2)=f1(lines(6,2));
lxy(3,3)=f2(lines(5,1));
lxy(3,4)=f2(lines(6,1));

end