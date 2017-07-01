function yout = filtspline(x, y, points_filt, spline_strength)
%==========================================================================
%function yout = filtspline(x, y, p_filt, spline_strength)
%--------------------------------------------------------------------------
% FILTSPLINE smoothes a data vector using a filter. Afterwards csaps is
% applied to smooth the results, which may exhibit spikes.
%--------------------------------------------------------------------------
% x, y: input x/ and y-vector
% points_filt: points about which filtmooth is applied
% splstr: spline strength E [0 ... 1]
%
% yout: smoothed and splined output vector
%--------------------------------------------------------------------------
%EX: yout = filtspline(x, y, points_filt, 0.5)
%==========================================================================

y1 = filtmooth(y, points_filt);
yout = csaps(x, y1, spline_strength, x);

end