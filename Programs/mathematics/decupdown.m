function [numout] = decupdown(num, updown, dexp, deccut);
%function [numout] = decupdown(num, updown, dexp);
% Rounds a number up or down to the next decimal place. The decimal place
% can be adjusted by dexp.
%
% input     num     double number
%           updown  number of how much up or down
%           dexp    which decimal place
%           deccut  cut rest of decimal digits 0: yes, 1: no
% output    numout  double number
% EXAMPLE:  num = decupdown(2.345, 1, 2, 0)
%           you get: 2.350

    num_dec = 10^(dexp)*num;
    numtail = num_dec - fix(num_dec);
    numout  = (fix(num_dec)+updown + deccut*numtail)/10^(dexp);

end