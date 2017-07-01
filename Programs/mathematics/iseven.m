function out = iseven(num)
%==========================================================================
%function out = iseven(num)
%--------------------------------------------------------------------------
% May-19-2013, C. Brandt, San Diego
% ISEVEN gives a 1 if 'num' is even and a 0 if it is odd.
%--------------------------------------------------------------------------
%IN:
% num: integer
%OUT:
% out: 1: num is even, 0: num is odd
%--------------------------------------------------------------------------
%EXAMPLE: out = iseven(8); out=1
%==========================================================================

% Use the bitget function (according to MatLab Forum it is better to 
% avoid floating point issues)
chk = bitget(abs(num),1);

if chk ~= 0
  out = 0;
else
  out = 1;
end

end