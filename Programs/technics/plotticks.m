function [dy,y1] = plotticks(ymin, ymax, nt, zeroOnOff)
%==========================================================================
%function [dy,y1] = plotticks(ymin, ymax, nt, zeroOnOff)
%--------------------------------------------------------------------------
% Automatical finds optimal tick distance dy and start tick y1 for given 
% ymin and ymax of plot limits.
% Version works only reliable for limits (ymax-ymin) between 5 and 1000.
%--------------------------------------------------------------------------
%EXAMPLE:
% lymax = 5; lymin = 0;
% ylim = [lymin lymax]; 
% [dy,ystart] = plotticks(lymin, lymax, 5, 1);
% ytick = ystart:dy:lymax;
%==========================================================================

if nargin<4
  zeroOnOff = 0;
end
  
lab = [1 2 5 10 20 30 40 50 60 70 80 90 100];

d = ymax-ymin;




if ymin<=0 || (ymin>0 && d/ymin>10) || zeroOnOff==1

  if ymin>0
    d = ymax;
    ymin = 0;
  end
  
  v = abs((d ./lab) - nt);
  [~, imin] = min(v);
  dy = lab(imin);

  
  if ymin>=0
    y1 = 0;
    
  else
    y1 = ymin + dy*(ceil(ymin/dy) - ymin/dy);
    
  end
  
  
else
    v = abs((d ./lab) - nt);
  [~, imin] = min(v);
  dy = lab(imin);
  
  y1 = ymin + dy*(ceil(ymin/dy) - ymin/dy);
  
end



% plot(lab, v, 'bo-')

end