function [smS] = smoothspec(S, nque, hlvl, smpts, intn, rmbpks)
%function [smS] = smoothspec(S, nque, hlvl, smpts, intn, rmbpks)
%Quench the noise of a logarithmic Spectrum with peaks above!
% IN: S: signal vector
%     nque: strongness of noise quench >1; 1 no quench, 2 quench double
%     hlvl: histogram-level ]0,1[ - above level everything will be quenched
%     smpts: smooth-points
%     intn: number of the intervalls for the histogram
%     rmbpks(opt): remove peaks without a width (default: 1=y; 0=n)
% EX: sig = smoothspecNEW(ampS(:,i), 20, 0.05, 20, 100, 1);

if nargin<2; nque  = 20;  end;
if nargin<3; hlvl  = 0.05; end;
if nargin<4; smpts = 20;  end;
if nargin<5; intn  = 100;  end;
if nargin<6; rmbpks = 1;  end;

% GET BACKGROUND: SMOOTH SPECTRA EXTREMELY
  bg = smooth(S,smpts);
% procedure to get the peaks and the noise-width
  diff = S-bg;
% MAKE HISTOGRAM OF diff
    maxd = max(diff);
    mind = min(diff);
    % delta-dB of the histogramm
    d = (maxd-mind)/intn;
    % make the histogram .. count the y-values
    for i=1:intn
      a=mind+(i-1)*d;
      b=find( a <= diff  &  diff < a+d);
      histdiffx(i) = a;
      if isempty(b)
        histdiff(i) = 0;
      else
        histdiff(i) = size(b,1);
      end;
    end;
    % for debugging: figure; plot(histdiffx, histdiff);
    
% NOW: QUENCH THE NOISE LOG-GAUSS-PEAK - but leave the peaks
% NORMALIZE THE HISTOGRAMM
      histdiff_norm = histdiff/max(histdiff);
% LOOK FROM WHERE THE hlvl BEGINS
      f_hlvl = max( find(histdiff_norm>=hlvl) );
      noise_begin = histdiffx(f_hlvl);
% QUENCH THE NOISE
      diffq = diff;
      for i=1:f_hlvl % for loop for all points which are no peaks
        % find indices for points
          a=mind+(i-1)*d; % 
          b=find( a <= diff  &  diff < a+d);
        diffq(b) = diffq(b)./nque;
      end;
      %
% FIND PEAKS WITHOUT PEAK-WIDTH and quench them also
% METHOD 1
    if rmbpks==1
        for i=f_hlvl:length(histdiff_norm) % for loop for all peak-points
          a=mind+(i-1)*d; % 
          b=find( a <= diff  &  diff < a+d);
          for j=1:length(b)
            if diffq(b(j)-1)<=noise_begin & diffq(b(j)+1) <= noise_begin
              diffq(b(j)) = diffq(b(j))./nque;
            end;
          end;
        end;
    end;
    %
    % END: add the background back
    smS = diffq + bg;
end