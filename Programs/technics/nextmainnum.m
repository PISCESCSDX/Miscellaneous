function [numout] = nextmainnum(num, mainnum, updown)
%==========================================================================
%function [numout] = nextmainnum(num, mainnum, updown)
%--------------------------------------------------------------------------
% NEXTMAINNUM calculates in respect to the number 'num' the next 
% (or previous) integer multiple of mainnum. 
%--------------------------------------------------------------------------
% IN: num     number
%     mainnum main intervall (integer)
%     updown  'up' upper limit, 'down' lower limit
%OUT: numout
%--------------------------------------------------------------------------
% EXAMPLE:  [numout] = nextmainnum(num, mainnum, updown);
%           numout = nextmainnum(22, 20, 'up') yields 40
%==========================================================================

if nargin<2; error('Input arguments are missing!'); end;


if num<0 & strcmp(updown,'up'); num = num-mainnum;  end;

hilfs = floor(abs(num/mainnum))*mainnum;

switch updown
  case 'up'
    numout = hilfs*sign(num) + mainnum;
  case 'down'
    numout = hilfs*sign(num) - mainnum;
end;

end