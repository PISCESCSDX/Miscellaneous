function [nnum] = rounddec(num)
%function [nnum] = rounddec(num)
% Round an integer number up to the next multiple of 10.
% To +inf or -inf depending on the sign.
%
% EX: rounddec(-22) ==> -30
% See also: rounddec_adv

  nnum = sign(num) * ceil( abs(num) /10)*10;

end