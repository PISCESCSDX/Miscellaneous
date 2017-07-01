function [clockstring] = clock_int
%==========================================================================
%function [clockstring] = clock_int
%--------------------------------------------------------------------------
% Jan-17-2007, C. Brandt, IPP Greifswald
% May-23-2013, C. Brandt, UC San Diego
% CLOCK_INT shows the time in a string 'yyyy/mm/dd hh:mm:ss'.
%--------------------------------------------------------------------------
%INPUT:
%OUTPUT:
%  clockstring
%--------------------------------------------------------------------------
%EXPAMPLE:
% a = clock_int;
%==========================================================================

    c = clock;
    csec  = floor(c(6));
    msec  = (c(6)-csec)*1e3;
    musec = (msec-floor(msec))*1e3;
    nsec  = (musec-floor(musec))*1e3;
    
    msec  = floor(msec);
    musec = floor(musec);
    nsec  = floor(nsec);

clockstring = {   [num2str(c(1))  '/' mkstring('','0', c(2),99,'') ...
 '/' mkstring('','0',c(3),99,'')  ' ' mkstring('','0', c(4),99,'') ...
 ':' mkstring('','0',c(5),99,'')  ':' mkstring('','0', csec,99,'') ...
 '.' mkstring('','0',msec,999,'') '.' mkstring('','0',musec,999,'') ...
 '.' mkstring('','0',nsec,999,'')]};

    clockstring = cell2mat(clockstring);
    
end