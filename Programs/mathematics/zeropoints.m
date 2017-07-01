function [x0, dir] = zeropoints(x, y)
%==========================================================================
%function x0 = zeropoints(x, y)
%--------------------------------------------------------------------------
% ZEROPOINTS finds the zero crossings of a function y, not the zero
% positions - only if a zero position is a zero crossing!
%--------------------------------------------------------------------------
% IN: x,y: vectors of same length
%OUT: x0: zero points (linear interpolated between two points.)
%     dir: direction: - to + +1; 0to0 0;  - to + -1
%--------------------------------------------------------------------------
% EX: [PolyIsat, voltlim, ivoltlim, iVf] = subPlasmaIsatPoly_v2(data);
%            y = polyval(PolyIsat, x);
% 16.04.2012-18:02 C. Brandt, San Diego
%==========================================================================

ix = (1:length(y))';
ysig = sign(y);

% Differentiate function:
Dy = diff(ysig)./diff(ix);
% Add a First Element
Dy = [( Dy(1) - (Dy(2)-Dy(1)) ) Dy']';
% 
Dy(1) = 0;

i2pos = Dy==+2;  % - tO +
i2nul1= Dy==+1;  % + to 0
i2nul2= Dy==-1;  % 0 to -
i2neg = Dy==-2;  % + to -

% From negative to positive
ind = ix(i2pos);
x2pos= abs(y(ind-1)) .*(x(ind) -x(ind-1)) ./(y(ind) - y(ind-1)) + x(ind-1);
d2pos=(+1) * ones(1, numel(x2pos))';
% figure; hold on;
% plot(x,y,'b')
% plot(x2pos, zeros(numel(x2pos),1), 'r*')
% hold off

% From positive to negative
ind = ix(i2neg);
x2neg= abs(y(ind-1)) .*(x(ind) -x(ind-1)) ./(y(ind-1)-y(ind)) + x(ind-1);
d2neg=(-1) * ones(1, numel(x2neg))';
% figure; hold on;
% plot(x,y,'b')
% plot(x2neg, zeros(numel(x2neg),1), 'r*')
% hold off

% Special Cases: y is exact zero: Add 2 by one shifted: @ zerocross is 2
hef = i2nul2(2:end) + i2nul2(1:end-1);
ih = hef == +2;
x2pos2 = x(ih)+1;
d2pos2 = -1;
% Special Cases: y is exact zero: Add 2 by one shifted: @ zerocross is -2
hef = i2nul1(2:end) + i2nul1(1:end-1);
ih = hef == -2;
x2neg2 = x(ih)+1;
d2neg2 = -1;


% Sort zero points:
x0_a = [x2pos; x2neg; x2neg2; x2pos2];
dira= [d2pos; d2neg; d2neg2; d2pos2];

[x0, ix0] = sort(x0_a);
dir = dira(ix0);

end