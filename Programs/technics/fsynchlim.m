function [f_synch] = fsynchlim(tvec,mvec,fvec,mmat,fmat,fdw,fexvec,mex)
%20080225-Mo-12:48 Brandt
%function [fsynch] = fsynchlim(tvec,mvec,fvec,mmat,fmat,fdw,fexvec,mex)
%
%

% STEPS OF TVEC
  tl = length(tvec);

% FREQUENCY RESOLUTION
  df = fvec(2)-fvec(1);
  disp([ 'frequency resolution: ' num2str(df) '[ Hz]'] )



% CHECK NOW for every tvec-step:%
% 1: mdw = mex? mex is maximal peak
%   IF TRUE ==> 2.
%   ELSE 3.
% 2. fex is maximal PEAK
% 3. 
  for i=1:tl
      [mA i_m] = max( mmat(:, i) );
      figeps(10,10,1); clf; plot(mvec, mmat(:, i))
      % - - - - - - - - - - - - - - - - - - - - - 1. CHECK max(mmat)=mex ?
      if mvec(i_m)==mex
          % - - - - - - - - - - - - - - - - - - - 2.CHECK fex is fmax?
          [fA i_f] = max( fmat(:, i) );
          if fexvec(i) < fvec(i_f)+df && fexvec(i) > fvec(i_f)-df
              f_synch(i) = fvec(i_f);
          else
              f_synch(i) = NaN;
          end
      else
        f_synch(i) = NaN;
      end

  end


end