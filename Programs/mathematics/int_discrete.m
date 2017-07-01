function [S, Int] = int_discrete(x, y)
%==========================================================================
%function [S, Int] = int_discrete(x, y)
% Jun-06-2012, C. Brandt, San Diego (UCSD, CER)
%--------------------------------------------------------------------------
% INT_DISCRETE integrates a discrete function y(x).
% x and y must be both column vectors.
% IN: x, y: column vectors of same length
%OUT: S: Value of integral
%     Int: integral function of F(x) = Int y(x) dx
%--------------------------------------------------------------------------
% EX: [S, Int] = int_discrete(x, y)
%==========================================================================

% Length of x
xl = length(x);

% Total integral (trapezoidal rule)
S = sum( ( y(2:xl)+y(1:xl-1) ) .* ( x(2:xl)-x(1:xl-1) ) ) /2;

% Total integral (trapezoidal rule)
Int = cumsum( ( y(2:xl)+y(1:xl-1) ) .* ( x(2:xl)-x(1:xl-1) ) ) /2;

% Points of Integral are in between x_i, thus one is missing
% Add one point by spline to obtain original vector length
xvec = ( x(2:xl)+x(1:xl-1) )/2;
cs = spline(xvec, Int);
Int = ppval(cs, x);

end