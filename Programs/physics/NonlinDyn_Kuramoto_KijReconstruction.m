function Kij = NonlinDyn_Kuramoto_KijReconstruction(tt, xi, fct_i)
%==========================================================================
% function Kij = NonlinDyn_Kuramoto_KijReconstruction(tt,xi,fct_i)
%--------------------------------------------------------------------------
% NONLINDYN_KURAMOTO_KIJRECONSTRUCTION calculates the coupling matrix from
% a given set of time traces of all oscillators. The method is based on the
% recipe given in [1].
% [1] SG Shandilya, New J. Phys. 13, 013004 (2011).
%---------------------------------------------------------------------INPUT
% tt: time vector of (rows: length of time trace, one column)
% xi: variable vector (e.g. phases) (rows: length of time trace,
%     columns: numbers of oscillators (=N) )
% fct_i: function f_i, e.g. in Kuramoto f_i = omega_i, i.e. the eigen-
%        frequencies of the oscillators. These values need to be known.
%        (1xN, one row, number of columns = number of oscillators)
%==========================================================================

% Number of oscillators
N = length(fct_i);

% Original time vector (e.g. tt: 50000 x 1)
tvec = tt;

% Shandilya & Timme Method (2011) for coupling matrix reconstruction:
%---------------------------------------------------------------------- (i)
% (i) Observe the collective dynamical trajectory x_i(t) of all units of 
%     the network at times t ? {t_0, t_1, ..., t_M}.

% (ii) Estimate states x(d)_i and derivatives x(d)_i at times
%      tau_m= {tau_1, tau_2 , ..., tau_M} where tau_m := (t_m-1 + t_m)/2 by
%      approximating to first-order (3)-(4).

% Create tau_m
tau = ( tvec(1:end-1) + tvec(2:end) ) / 2;

M = length(tau);

% xi2 is interpolation of xi
xi2 = zeros(M,N);
for i=1:N
  xi2(:,i) = ( xi(1:end-1, i) + xi(2:end, i) ) / 2;
end

% Linearly estimate d(xi)/dt
dxi2 = zeros(M,N);
for i=1:N
  dxi2(:,i) = ( xi(2:end, i) - xi(1:end-1, i)) ./ (tvec(2:end) - tvec(1:end-1) );
end

% Activate this line when fct_i should be calculated from average of d/dt(xi)
% fct_i = mean(dxi2,1);

% (iii) Use the observed state variables x_i (tau_m) and the estimated
%       derivatives x_i(tau_m) to compute fct_i(x_i(tau_m)) 
%       and g_ij(x_i(tau_m), x_j(tau_m)) and set up the matrix equation (6).

% (iv) Using L2 optimization, solve for unknown coupling strengths 
%      (and, if applicable, for unknown parameters appearing linear in 
%      the system) according to (8).

% Calculate the quantity X_i (defined in Shandilya as: d(xi)/dt-fct_i)
Xi = dxi2 - ones(M,1)*fct_i;

% Calculate g_ij as defined in Kuramoto: g_ij = sin(theta_j-theta_i)
g_ij = zeros(N,N,M);
for i=1:N
  for j=1:N
    g_ij(i,j,:) = sin( xi2(1:end,j) - xi2(1:end,i));
  end
end

% Calculate J_ik
J = NaN(N,N);
for i=1:N
  
  Gi = squeeze( g_ij(i,:,:) );
  
  A = Xi(:,i)' * Gi';
  B = Gi * Gi';

  % J(i,:) = mrdivide(A, B);  % same as: J1(i,:) = A/B;
  % --> but gives NaN values and the error:
  % "Warning: Matrix is singular to working precision."
  % --> doc mldivide gives this solution (use pinv(B))
  J(i,:) = A * pinv(B);
end


% Negate J: (*** Why is that? All equations seem correct.)
Kij = -J;

% (v) If desired, threshold the resultant weighted adjacency matrix, as 
%     appropriate for the question under consideration.

end