function [indsm, vecsm] = smooth_longvector(ind,vec,sm,rpt)
%==========================================================================
%function [indsm, vecsm] = smooth_longvector(x,vec,sm,rpt)
%--------------------------------------------------------------------------
% Jun-27-2013, C. Brandt, San Diego
% SMOOTH_LONGVECTOR smoothes an array more efficiently and uses much less
% time.
%--------------------------------------------------------------------------
%INPUT
%  ind: index vector
%  vec: input vector
%  sm: smoothing points
%  rpt: number of repetitions
%OUTPUT
%  vecsm: smoothed vector, number of elements is shortened by factor sm^rpt
%--------------------------------------------------------------------------
%EXAMPLE
% ind = (1:4e6)';
% vec = sin(ind/100000) + randn(length(ind),1);
% sm = 100; rpt = 2;
% [indsm,vecsm] = smooth_longvector(ind,vec,sm,rpt);
% hold on
% plot(ind,vec,'b')
% plot(indsm,vecsm,'ro-')
% % try to smooth it using: vecsm = smooth(vec,10000)
%==========================================================================

% Smooth
for i=1:rpt
  vec = smooth(vec,sm);
  vec = vec(1:sm:end);
  ind = ind(1:sm:end);
end

% Output
vecsm = vec;
indsm = ind;

end