function [yout] = diff_discrete(x, y)
%==========================================================================
%function [yout] = diff_discrete(x, y)
%--------------------------------------------------------------------------
% DIFF_DISCRETE differentiates a discrete function y(x).
% INFO: The first element of the differentiation is calculated assuming
% linear interpolation. This error for this estimation becomes smaller with
% finer resolution measurements.
%--------------------------------------------------------------------------
% EX: s = diff_discrete(x, y)
%==========================================================================

yout = diff(y)./diff(x);

% ADD ONE ELEMENT, ASSUMING LINEAR INTERPOLATION FOR THIS ONE
% APPLICABLE, IF GRID FINE ENOUGH
yout = [( yout(1) - (yout(2)-yout(1)) ) yout']';

end