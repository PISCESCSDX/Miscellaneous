function [n1, n2, nB] = interpbicmat(o1, o2, oB, resfac)
%FUNCTION [n1, n2, nB] = interpbicmat (o1, o2, oB, resfac)
% INTERPBICMAT is written for increase the resolution of a bicoherence
% matrix. Input parameters have to be the original axis vectors o1 and o2
% and the original matrix oB. The size of oB has to fit the sizes of the
% axes o1 and o2! Optional one can adjust the new resolution by a
% resolution factor "resfac". 1 means the resolution stays the same, 2 the
% resolution is the double and so on (default is 3).
%IN: o1 (1d-vec) original x-axis [m]
%    o2 (1d-vec) original y-axis [n]
%    oB (2d-matrix) original bicoherence matrix [mxn]
%    (opt) resfac: new resolution=resfac*old_resolution (default=3)
%OUT:n1: new x-axis [m*resfac]
%    n2: new x-axis [n*resfac]
%    nB: new bicoherence matrix resfac*[mxn]
%EX: [f1, f2, b] = interpbicmat(of1, of2, ob, 4);

if nargin<4; resf=3; end;
if nargin<3; error('Input arguments are missing!'); end;

% [k1m, k2m] = meshgrid(k1, k2);
% h1 = interp(k1,4);
% h2 = interp(k2,4);
% [h1, h2] = meshgrid(h1, h2);      
% hv = interp2(k1m, k2m, b, h1, h2, 'linear');

  [o1m, o2m] = meshgrid(o1, o2);
  n1 = interp(o1, resfac);
  n2 = interp(o2, resfac);
  [n1m, n2m] = meshgrid(n1, n2);
  nB = interp2(o1m, o2m, oB, n1m, n2m, 'linear');

% plotkbic(1, h1(1,:), h2(:,1), hv, 1);
  
end