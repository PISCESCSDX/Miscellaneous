function [ivec xyint] = integratexy(x, y)
%==========================================================================
%function [ivec loopint] = integratexy(x, y)
%--------------------------------------------------------------------------
% INTEGRATEXY calculates the integral of all closed loops in a 
% 2d vector. Counter-clockwise loops are counted negative and 
% clockwise loops are counted positive.
%--------------------------------------------------------------------------
% IN: v, w: vectors of the points
%OUT: ivec: number
%     xyint: summed integral of the loops along the time
%--------------------------------------------------------------------------
% This is a short script for testing the Green Integrals.
% t = (0:1000)/10;
% noise = 0.2;
% % Shift the signals
% 
% 
% % Uncorrelated signals
% x1 = noise*randn(numel(t),1);
% y1 = noise*randn(numel(t),1);
% [~, xyint1] = integratexy(x1,y1);
% 
% % Correlated signals
% phi = 1.0*pi/2;
% x2 = noise*randn(numel(t),1) + sin(t');
% y2 = noise*randn(numel(t),1) + sin(t'+phi);
% [~, xyint2] = integratexy(x2,y2);
% 
% figeps(18,22,1); clf; 
% subplot(4,2,1)
%   hold on
%   plot(x1,'k');
%   plot(y1,'b'); set(gca,'xlim',[0 1000])
%   hold off
%   title('uncorrelated signals')
% subplot(4,2,2)
%   hold on
%   plot(x2,'k');
%   plot(y2,'r'); set(gca,'xlim',[0 1000])
%   hold off
%   title('correlated signals')
% subplot(4,2,3)
%   plot(x1,y1,'x')
%   title('phase space: x vs y')
% subplot(4,2,4)
%   plot(x2,y2,'rx')
%   title('phase space: x vs y')
% subplot(4,2,5)
%   plot(cumsum(xyint1))
%   set(gca,'xlim',[t(1) t(end)])
%   title('cumulated Green integral')
% subplot(4,2,6)
%   hold on
%   plot(cumsum(xyint1),'b')
%   plot(cumsum(xyint2),'r')
%   hold off
%   set(gca,'xlim',[t(1) t(end)])
%   title('cumulated Green integral')
% 
% % Test the cross correlation function
% ntau = 50;
% [c_w1,lags1] = xcorr(x1,y1,ntau,'coeff');
% [c_w2,lags2] = xcorr(x2,y2,ntau,'coeff');
% subplot(4,2,7);
%   stem(lags1,c_w1)
%   title('auto correlation')
% subplot(4,2,8);
%   stem(lags2,c_w2)
%   title('auto correlation')
%--------------------------------------------------------------------------
% EX: [ivec xyint] = integratexy(x, y)
%==========================================================================

% define number vector
ivec = 1:length(x);

% go through each element of the vectors
% calculate


% Find all lines
%================
s0 = 0; ci = 0;
while s0==0
  ci = ci+1; % i-counter up
  [m(ci), n(ci), x0(ci)] = line1d([x(ci) y(ci)], [x(ci+1) y(ci+1)]);
  if ci+1 == length(x)
    s0 = 1;  % status finished
    m(ci+1)=NaN; n(ci+1)=NaN; x0(ci+1)=NaN;
    break
  end
end


% Calculate Integrals
%=====================
for i=1:length(x)-1
  if ~isnan(m(i))
    if isinf(abs(m(i)))
      xyint(i) = 0;
    else
      xyint(i) = integrateline(m(i), n(i), x(i), x(i+1));
    end
  else
    xyint(i) = 0;
  end
end
% last value is zero
xyint(length(x)) = 0;

end