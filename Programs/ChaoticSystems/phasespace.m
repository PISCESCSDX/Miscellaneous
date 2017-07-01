function [Y,T]=phasespace(x,dim,tau)
%function [Y,T]=phasespace(x,dim,tau)
% The phase space reconstruction of a time series x whith the method of 
% delays (MOD), in embedding dimension m and for time dalay tau.
% 
% IN: x: time vector
%     dim: embedding dimension
%     tau: time delay
%OUT: Y: trajectory matrix in the reconstructed phase space
%     T: phase space length
%
% EX: [Y,T]=phasespace(A(:,1),3,1000);
%     plot3(Y(:,1), Y(:,2), Y(:,3));
% 11 Mar 2001, Brandt 04/09/2007

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
   % N is the time series length
   N=length(x);
end

if nargin<2 | isempty(dim)==1
    dim=2;
else
    % dim must be scalar
    if sum(size(dim))>2
        error('dim must be scalar.');
    end
    % dim must be an integer
    if dim-round(dim)~=0
        error('dim must be an integer.');
    end
    % dim must be positive
    if dim<=0
        error('dim must be positive.');
    end
end

if nargin<3 | isempty(tau)==1
    tau=1;
else
    % tau must be scalar
    if sum(size(tau))>2
        error('tau must be scalar.');
    end
    % tau must be an integer
    if tau-round(tau)~=0
        error('tau must be an integer.');
    end
    % tau must be positive
    if tau<=0
        error('tau must be positive.');
    end
end

% Total points on phase space 
T=N-(dim-1)*tau;

% Initialize the phase space
Y=zeros(T,dim);

% Phase space reconstruction with MOD
for i=1:T
   Y(i,:)=x(i+(0:dim-1)*tau)';
end


% Reference:
% Takens F (1981): Detecting strange attractors in turbulence. Lecture notes in
% Mathematics, 898. Springer.
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421