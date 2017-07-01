function indtimedelay = ccf_timedelay(corr)
%==========================================================================
%function indtimedelay = ccf_timedelay(corr)
%--------------------------------------------------------------------------
% May-21-2013, C. Brandt, UCSD, San Diego
% CCF_TIMEDELAY computes the index of the time delay between the maximum
% and the first null of a correlation function (cross- or auto-).
%--------------------------------------------------------------------------
%INPUT:
% corr: vector of a cross-correlation function (or auto-c. fct)
%OUTPUT:
% indtimedelay: index of time delay between maximum and 1st null
%--------------------------------------------------------------------------
% EXAMPLE:
%==========================================================================

% Find index of maximum of correlation function and cut corr from there
[~, i1] = max(corr);
corr = corr(i1:end);

% Loop to find the first zero after maximum
ctr = 0; status = 0;
while status == 0
  ctr = ctr+1;
  if sign(corr(ctr+1)) < sign(corr(ctr))
    status = 1;
    indtimedelay = ctr;
  end
end

end