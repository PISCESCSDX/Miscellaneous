function s = integral_discrete(x, y)
%==========================================================================
%function s = integral_discrete(x, y)
%--------------------------------------------------------------------------
% INTEGRAL_DISCRETE integrates a discrete function y(x).
%--------------------------------------------------------------------------
% EX: s = integral_discrete(x, y);
%==========================================================================

xl = length(x);
dx = x(2)-x(1);

% Integration with trapezoidal rule
s = (y(2:xl) + y(1:xl-1))/2 * dx;

end