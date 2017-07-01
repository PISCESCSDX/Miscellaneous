function indout = findind(vec, num)
%==========================================================================
%function indout = findind(vec, num)
%--------------------------------------------------------------------------
% Finds the index of a monotonic vector, which is the closest to num.
% ind = NaN, if nothing can be found.
%--------------------------------------------------------------------------
% IN: vec: monotonic 1dim vector
%     num: number
%OUT: indout index of vector which lies most in the vicinity of num
%--------------------------------------------------------------------------
% EX: indout = findind([0 0.2 0.8 1.1 1.2], 0.7) DELIVERS ind=3;
%==========================================================================

nrow = size(vec,1);
ncol = size(vec,2);
if ncol>nrow; vec = vec'; end
  
pp = polyfit((1:length(vec))',vec,1);

if pp(1)<0
  vec = flipud(vec);
  flipback = 1;
else
  flipback = 0;
end

indout(length(num)) = 0;
for k = 1:length(num)
  % FIND INDICES WHERE vec IS SMALLER AND BIGGER THAN num
  i_lo = find(vec <  num(k));
      % IF num << vec
      if isempty(i_lo)
        i_lo = 1; A_lo = vec( i_lo );
      else
          i_lo = i_lo(end); A_lo = vec( i_lo );
      end
  i_hi = find(vec >= num(k));
      % IF num >> vec
      if isempty(i_hi)
        i_hi = length(vec); A_hi = vec(end);
      else
          i_hi = i_hi(1); A_hi = vec( i_hi );
      end

  % COMPARE THE DIFFERENCES
  diff_lo = num(k) - A_lo;
  diff_hi = A_hi - num(k);

  if diff_lo >= diff_hi
    ind = i_hi;
  else
    ind = i_lo;
  end

  % IF num LIES BEYOND vec: ind=NaN
  if i_lo == i_hi
    ind = NaN;
  end

  if flipback == 1
    ind = length(vec) - ind;
  end

  indout(k) = ind;
end %for k loop

end