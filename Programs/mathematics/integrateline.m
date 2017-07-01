function [A] = integrateline(m, n, a, b)
%==========================================================================
%function [A] = integrateline(m, n, a, b)
%--------------------------------------------------------------------------
% INTEGRATELINE calculates the integral of a line between the limits a and
% b.
%--------------------------------------------------------------------------
% IN: m: slope of line
%     n: crossing with y-axis
%     a, b: integration limits
%OUT: A: value of the integral
%--------------------------------------------------------------------------
% EX: A = integrateline(m, n, a, b);
%==========================================================================

A = 0.5*m*((b-a)^2) + n*(b-a);

end