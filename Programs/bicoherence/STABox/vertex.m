function [x2,y2,z2,col2] = vertex(x,y,z,col,edge)
%==========================================================================
%function [x2,y2,z2,col2] = vertex(x,y,z,col,edge)
%ThDdW 6/96
%--------------------------------------------------------------------------
% VERTEX rearranges a 2D plot to be used with PATCH, PCOLOR
% or SURFACE so that the vertices are correctly displayed
%--------------------------------------------------------------------------
%	x	x axis for display
%	y	y axis for display
%	z	z data matrix
%	col	optional colour level corresponding to z;
%		default is col=z
%	edge	if specified the colour of the edges
%		corresponds to the value of edge. To prevent
%		edges from being displayed set edge=NaN
%		default is edge = minimum of z
%	x2,y2,z2,col2	the converted data, ready for display
%==========================================================================


if nargin<5,	edge = min(z(~isnan(z)));	end
if nargin<4,	col = z;			end

x = x(:);
y = y(:);
nx = length(x);
ny = length(y);
[n1,n2] = size(z);
if nx~=n2 || ny~=n1, 
	error('** sizes of x and y must match z **');
end
dx = diff(x)/2;
x1 = [x(1)-dx(1); x(1:nx-1)+dx; x(nx)+dx(nx-1)];
dy = diff(y)/2;
y1 = [y(1)-dy(1); y(1:ny-1)+dy; y(ny)+dy(ny-1)];


nx2 = 2*(nx+1);
ny2 = 2*(ny+1);
x2 = zeros(nx2,1);
y2 = zeros(ny2,1);
x2([1:2:nx2-1 2:2:nx2]) = x1([1:nx+1 1:nx+1]);
y2([1:2:ny2-1 2:2:ny2]) = y1([1:ny+1 1:ny+1]);



z1 = zeros(ny,nx2);
z2 = zeros(ny2,nx2);
z1(:,[1 2:2:nx2-2 3:2:nx2-1 nx2]) = [ones(ny,1)*edge ...
		z z ones(ny,1)*edge];
z2([1 2:2:ny2-2 3:2:ny2-1 ny2],:) = [ones(1,nx2)*edge; ...
		z1; z1; ones(1,nx2)*edge];


col1 = zeros(ny,nx2);
col2 = zeros(ny2,nx2);
col1(:,[1 2:2:nx2-2 3:2:nx2-1 nx2]) = [ones(ny,1)*edge ...
		col col*0+edge ones(ny,1)*edge];
col2([1 2:2:ny2-2 3:2:ny2-1 ny2],:) = [ones(1,nx2)*edge; ...
		col1; col1*0+edge; ones(1,nx2)*edge];

end

