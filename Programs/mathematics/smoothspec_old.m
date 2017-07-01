function [namp] = smoothspec(amp, num);
% In: amp(vec) amplitude vector
%     num(int) number of peaks which should be regarded
% cbra, 20070921

sz = size(amp,2);

% find and save all peaks above noiselevel
%========================================
% remove offset to find peaks (/20 should be good choice for every spec)
  namp = smooth(amp', round(sz/40) );
%  namp = smooth(amp', round(sz/20) );
  a = amp-namp';
  
% loop to find all peaks above the noiselevel
for i=1:num
  peaknr{i} = findpeakind(a);
  % remove peak from signal
    namp(peaknr{i}(1):peaknr{i}(2)) = amp(peaknr{i}(1):peaknr{i}(2));
    a(peaknr{i}(1):peaknr{i}(2)) = (a(peaknr{i}(1)-1) + a(peaknr{i}(2)+1))/2;
end;


% add old peaks to new background
%================================

end