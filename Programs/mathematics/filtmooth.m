function y=filtmooth(x,ns,typ)
%==========================================================================
%function y=filtmooth(x,ns,typ)
%--------------------------------------------------------------------------
% FILTMOOTH smooths a curve using Matlabs 'filter' function.
% FILTMOOTH smooths data in x using either a gaussian or a other kind of 
% window which has a total width given by 2*ns+1 (each side contains ns 
% data points)
%	x		data to smooth (data sets are columns)
%       ns		smoothing width
%	typ		default window is gaussian, other possibilities are
%			'bar'	for Bartlett window (triangular)
%			'box'	for boxcar window (rectangular)
%			'bla'	for Blackman window
%			'ham'	for Hamming window
%			'han'	for Hanning window
%	y		smoothed data
%	ThDdW 3/89
%==========================================================================

if nargin<3, typ = 'gau'; end
[n,m] = size(x);
ns = min(floor(n/2-1),ns);			% ns must not exceed n/2
if ns<=0,
	y = x;
	return
end


if typ=='box'
	w = ones(2*ns+1,1);
elseif typ=='bar'
       	w = [1:ns ns:-1:1]';
elseif typ=='bla'
	w = 0.42-.5*cos(2*pi*(0:2*ns)'/2/ns) + .08*cos(4*pi*(0:2*ns)'/2/ns);
elseif typ=='ham'
	w = 0.54 - 0.46*cos(2*pi*(0:2*ns)'/(2*ns));
elseif typ=='han'
	w = 0.5*(1 - cos(2*pi*(1:2*ns+1)'/(2*ns+2)));
else
	w = (-ns:ns)'/ns;
	w = exp(-3 * w.^2);
end

w = w/sum(w);

% there several possibilities to treat the edges. One can
% extrapolate linearly, keep a fixed value, take a mirror image

% take this to use a mirror image
% x=[2*ones(ns,1)*x(1,:)-x(ns:-1:1,:);  x;  ...
%	2*ones(ns,1)*x(n,:)-x(n:-1:n-ns+1,:)]; 

% take this to exrapolate with a fixed level
% x = [ones(ns,1)*mean(x(1:ns,:)); x; ...
%	ones(ns,1)*mean(x(n-ns:n,:))];

% take this to extrapolate linearly
M1 = [-(ns-1:-1:0)' ones(ns,1)];
M2 = [(1:ns)'    ones(ns,1)];
x = [M1*(M2\x(1:ns,:)); x; M2*(M1\x(n-ns+1:n,:))];


for j=1:m				% do the convolution
	y(:,j)=filter(w,1,x(:,j));
end
y=y((1:n)+2*ns,:);

end
