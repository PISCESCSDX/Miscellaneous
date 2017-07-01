function [yout, linv] = gradlength(x, y)
%function [xout, yout] = gradlength(x, y)
% Calculate the inverse gradient length: y/grad(y)
% INFO: L^(-1) [m^(-1)]   
%
% IN: x: x-vector
%     y: profile-vector
%OUT: yout: gradient length ( y / grad(y) )
%     linv: inverse gradient length
% EX:[gy] = gradlength(rr,n1f);

if nargin<2, help gradlength, return; end;

[yd] = diff_discrete(x, y);
yout = y./yd;
linv = 1./yout;

end