function subplotexciter(R_el, L_el,beta,wdth,col,N)
%==========================================================================
%function subplotexciter(R_el, L_el,beta,wdth,col,N)
%--------------------------------------------------------------------------
% Line plot at exciter positions.
%--------------------------------------------------------------------------
% IN: R_el: distance to tube center [mm]
%     L_el: length of electrode [mm]
%     beta: rotate whole exciter
%     wdth: LineWidth
%     col:  color (e.g. 'k', or [0 0 1], ...)
%     N: number of electrodes
%--------------------------------------------------------------------------
% EX: subplotexciter(42,10,0,5,'r',16)
%==========================================================================

if nargin<6;
  N=8;
end

% angle coil edge to x-axis
  small_phi = atan( (L_el/2)/R_el );
% distance to coil edge
  helpdist  = sqrt((L_el/2)^2 + R_el^2);

for i=1:N
  alpha = (360/N)/180*pi*(i-1) + beta;
  x1=R_el*cos(alpha+small_phi);
  y1=R_el*sin(alpha+small_phi);
  x2=R_el*cos(alpha-small_phi);
  y2=R_el*sin(alpha-small_phi);
  % wire 1 (along z)
  mat(i,1) = x1;
  mat(i,2) = y1;
  mat(i,3) = x2;
  mat(i,4) = y2;
  %   % PLOT for control of the z-wire positions
  %     plot(x1,y1, 'ro'); hold on
  %     plot(x2,y2, 'bo'); hold on
end;


for i=1:N
  line([mat(i,1) mat(i,3)], [mat(i,2) mat(i,4)], ...
    'LineWidth', wdth, 'Color', col);
end;

end