function plotsnake(x,y,L,dt)
%==========================================================================
%function plotsnake(x,y,L,dt)
% 08.08.2012 C. Brandt, San Diego
%--------------------------------------------------------------------------
% PLOTSNAKE is a helping tool for watching the phase space between x and y
% in an animation.
% L: length of the displayed points.
% dt: duration (s) between showing next and deleting previous.
%--------------------------------------------------------------------------
% t = (1:10e3)'/10e3 * 2*pi * 100;
% x = sin(t) + 0.1*randn(length(t),1);
% y = cos(t) + 0.1*randn(length(t),1);
% plotsnake(x,y,30,0.01)
%==========================================================================

d = length(x);

figeps(14,14,2,50,100);
xmax = max(x); xmin = min(x);
ymax = max(y); ymin = min(y);
col = flipud(copper(1.3*L));

% Temporal Loop
for k=0:d-L-1
  clf  
  hold on
  for j=1:L
    plot(x(k+j:k+j+1),y(k+j:k+j+1),'Color',col(j,:))
  end
  hold off
  
set(gca, 'xlim',[xmin xmax],'ylim',[ymin ymax])
puttextonplot(gca,[0 1],5,-15,num2str(k), 0, 12, 'k');
pause(dt)
end

end