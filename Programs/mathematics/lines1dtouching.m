function [xt, yt] = lines1dtouching(l1, l2)
%==========================================================================
%function [xt, yt] = lines1dtouching(l1, l2)
%--------------------------------------------------------------------------
% LINES1DTOUCHING calculates whether 2 1 D lines touch and gives the 
% coordinates.
% IN: l1, l2: parameters of lines [m1 n1 x01], [m2 n2 x02]
%OUT: touching coordinates: xt, yt (NaN if one is no line, Inf: parallel)
%
%--------------------------------------------------------------------------
% EX: [xt, yt] = lines1dtouching([m1 n1 x01], [m2 n2 x02])
%==========================================================================

m1 = l1(1); n1 = l1(2); x01 = l1(3);
m2 = l2(1); n2 = l2(2); x02 = l2(3);

if ~(isnan(m1) || isnan(m2))
% one or both points are NaN
xt  = NaN; yt  = NaN;

if isinf(abs(m1))
  if isinf(abs(m2))
    % both lines are perpendicular
    xt = Inf;
    yt = Inf;
    
  else
    % line 1 is perpendicular, line 2 is ok
    xt = x01;
    yt = m2*x01+n2;
  end
  
else
  if isinf(abs(m2))
    % line 1 is ok, line 2 is perpendicular
    xt = x02;
    yt = m1*x02+n1;
    
  else
    if m1==m2
      % both lines are parallel
      xt = Inf;
      yt = Inf;
    else
      % both lines are touching
      xt = (n2-n1)/(m1-m2);
      yt = (m1*n2-m2*n1)/(m1-m2);
    end
  end
end

end

