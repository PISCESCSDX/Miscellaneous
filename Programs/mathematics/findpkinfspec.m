function [fexact Aexact] = findpkinfspec(fvec, fspec, fpos)
%20080226-Di-13:36 Brandt
%function [fexact Aexact] = findpkinfspec(fvec, fspec, fpos)
% Searches for the maximal Peak in the df-vicinity of fpos.
% Uses spline to interpolate the f-spectrum.
% IN: fvec: f-axis
%     fspec: f-spectrum
%     fpos: frequency, to find the maximum
%OUT: fexact: f of peak
%     Aexact: A of peak

% DELTA f
df = fvec(2)-fvec(1);

% FIND MAX PEAK IN VICINITY
% !!! AT THE MOMENT: DOES NOT WORK AT THE BOUNDARIES OF fspec
status = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SEARCH FOR THE MAXIMUM IN SMALL INTERVALS, ITERATIVELY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while status==0
  % f-INTERVAL
  fint = fpos-df/2:df/100:fpos+df/2;
  % AMPLITUDEs OF the f-INTERVAL
  Avec = spline(fvec, fspec, fint);
  % MAXIMUM AMPLITUDE AND INDEX
  [AMax i_A] = max(Avec);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % IF MAX AT LEFT BOUNDARY
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if i_A==1
      status = 0;
      fpos = fpos-df/2;          % shift new fdw to the left about df/2
    else
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % IF MAX AT RIGHT BOUNDARY
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if i_A==length(Avec)
        status = 0;
        fpos = fpos+df/2;       % shift new fdw to the right about df/2
      else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % MAXIMUM FOUND
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        status = 1;
        fexact = fint(i_A);
        Aexact = AMax;
      end
    end
end

end

