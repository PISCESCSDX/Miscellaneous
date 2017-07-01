function [clockstring] = clock_int
%function []= cou_monitor_kf(basedir, tint, bad_ch)
%20070117 Brandt
%
% show the time in a string: 'year/month/day hour:minute:seconds'
%
% NEEDS:    clock
%
% input:    no
% output:   clockstring
%
% EXPAMPLE: a = clock_int

    c = clock;
    c = fix(c);
    clockstring = {[num2str(c(1)) '/' num2str(c(2)) '/' num2str(c(3)) ... 
                    ' ' num2str(c(4)) ':' num2str(c(5)) ':' ...
                    num2str(c(6))]};
    clockstring = cell2mat(clockstring);
    
end