function [nnum] = rounddec_adv(num)
%function [nnum] = rounddec_adv(num)
% Round an integer number up to the next multiple of its own(!) decade.
% To +inf or -inf depending on the sign.
% EX: -22   -> -30
%      1.2  -> 2
%      0.03 -> 0.04
%      438  -> 500
% See also: rounddec

% get the sign and the absolute value
  snum = sign(num);
  vnum = abs(num);
% get the 10-exponents
  enum = ceil(log10(vnum))-1;
% help number
  hnum = vnum.*10^(-enum);
  hnum = ceil(hnum);
  hnum = hnum.*10.^(enum);
% get the signs back  
  nnum = hnum.*snum;

end