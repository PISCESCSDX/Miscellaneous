function [] = plotcontour(x, y, C, n, xl, yl, fs)
%==========================================================================
%function [] = plotcontour(x, y, C, n, xl, yl, fs)
% 20.11.2008 C. Brandt, Greifswald
% Last Change: 08.03.2012 C. Brandt, San Diego
%--------------------------------------------------------------------------
% fs: fontsize default 12
% our_colorbar('\delta n [a.u.]', 12, 0.001, 0.015, 0.002)
%==========================================================================

% Make a contourf plot with n color levels
[~, hC] = contourf(x, y, C, n);
% Do not show the black lines
set(hC,'LineStyle','none');
mkplotnice(xl, yl, fs, '-20', '-30');

end