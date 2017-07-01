function [xnew, ynew] = XYAVGMultiples(x, y)
%==========================================================================
%function [xnew, ynew] = XYAVGMultiples(x, y)
%--------------------------------------------------------------------------
% XYAVGMULTIPLES averages y-points at the same x-position.
%--------------------------------------------------------------------------
% IN: one line (unsorted or sorted) vectors: x, y
%OUT: x, and y vector with averaged positions
%--------------------------------------------------------------------------
% EX: [xnew, ynew] = XYAVGMultiples(x, y);
% 17.02.2012-17:48 C.Brandt, San Diego (checked)
%==========================================================================


% Sort vector x (and y)
[x isort] = sort(x);
y = y(isort);


% Counters for averaging points at same x-positions
ctr = 0;
ctr_eq = 0;

% Define one more element in order that x(i+1) at end can be found
x(end+1) = NaN;
y(end+1) = NaN;

xh = ones(1,length(x)) * NaN;
yh = ones(1,length(x)) * NaN;


for i=1:length(x)-1

  if x(i+1)==x(i)     % If two subsequent points are equal:
    ctr_eq = ctr_eq+1;

  else                % If two subsequent points are not equal:
    ctr = ctr+1;      
    xh(ctr) = x(i);
    if i>1
      yh(ctr) = mean(y(i-ctr_eq:i));
    else
      yh(ctr) = y(i);
    end
    ctr_eq = 0;       % Reset the equal-counter

  end

end


% Remove NaNs
ih = ~isnan(xh); xnew = xh(ih);
ih = ~isnan(yh); ynew = yh(ih);

end