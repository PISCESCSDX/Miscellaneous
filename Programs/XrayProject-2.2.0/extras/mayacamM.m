function mayacam(imagesize)

% Input: imagesize 1x2 [width height] is optional default is [1024 1024]

% creates a maya camera using the input xy clicks from the calibration cube
% and a frame specification file defining the cube. The output file is read
% into maya using the dlteuler.mel function

%David Baier 4/30/07
%last updated 2/14/2008

% check for image size input. If none use the default of 1024 x 1024
if exist('imagesize') == 0
    imagesize = [1024 1024];
end

[specfile,specpath]=uigetfile({'*.csv','comma separated values'}, ...
    'Please select your calibration object specification file');

cd(specpath);

specdata=dlmread([specpath,specfile],',',1,0); % read in the calibration file

[xyfile,xypath]=uigetfile({'*.csv','comma separated values'}, ...
    'Please select your _xypoints.csv file from the DLT calibration');

cd(xypath);

xydata = dlmread([xypath,xyfile],',',1,0);

for i = 1:size(xydata,2)

    curxy = xydata(:,i*2-1:i*2);

    [coefs, avgres] = mdlt1(specdata,curxy);

    C = coefs;

    for i = 1:size(C,2)
        coefs = C(:,i);

        m1=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7); ...
            coefs(9),coefs(10),coefs(11)];
        m2=[-coefs(4);-coefs(8);-1];

        xyz=inv(m1)*m2;

        D=(1/(coefs(9)^2+coefs(10)^2+coefs(11)^2))^0.5;
        D=D(1); % + solution

        Uo=(D^2)*(coefs(1)*coefs(9)+coefs(2)*coefs(10)+coefs(3)*coefs(11));
        Vo=(D^2)*(coefs(5)*coefs(9)+coefs(6)*coefs(10)+coefs(7)*coefs(11));

        du = (((Uo*coefs(9)-coefs(1))^2 + (Uo*coefs(10)-coefs(2))^2 + (Uo*coefs(11)-coefs(3))^2)*D^2)^0.5;
        dv = (((Vo*coefs(9)-coefs(5))^2 + (Vo*coefs(10)-coefs(6))^2 + (Vo*coefs(11)-coefs(7))^2)*D^2)^0.5;

        du=du(1); % + values
        dv=dv(1);
        Z=-1*mean([du,dv]); % there should be only a tiny difference between du & dv

        T3=D*[(Uo*coefs(9)-coefs(1))/du ,(Uo*coefs(10)-coefs(2))/du ,(Uo*coefs(11)-coefs(3))/du ; ...
            (Vo*coefs(9)-coefs(5))/dv ,(Vo*coefs(10)-coefs(6))/dv ,(Vo*coefs(11)-coefs(7))/dv ; ...
            coefs(9) , coefs(10), coefs(11)];

        dT3=det(T3);

        if dT3 < 0
            T3=-1*T3;
        end

        T=inv(T3);
        T(:,4)=[0;0;0];
        T(4,:)=[xyz(1),xyz(2),xyz(3),1];

        % compute YPR from T3
        %
        % Note that the axes of the DLT based transformation matrix are rarely
        % orthogonal, so these angles are only an approximation of the correct
        % transformation matrix
        alpha=atan2(T(2,1),T(1,1));
        beta=atan2(-T(3,1), (T(3,2)^2+T(3,3)^2)^0.5);
        gamma=atan2(T(3,2),T(3,3));

        % check for orthogonal transforms by back-calculating one of the matrix
        % elements
        if abs(cos(alpha)*cos(beta)-T(1,1)) > 1e-8
            disp('Warning - the transformation matrix represents transformation about')
            disp('non-orthogonal axes and cannot be represented as a roll, pitch & yaw')
            disp('series with 100% accuracy.')
        end

        ypr=rad2deg([gamma,beta,alpha]);

        scale = .1;

        planeX = ((imagesize(1))/2 - Uo)*scale;
        planeY = ((imagesize(2))/2 - Vo)*scale;
        planeZ = scale*Z;


        T = [xyz'; ypr; planeX,planeY,planeZ; Uo,Vo,Z; scale,imagesize(1),imagesize(2)];

        pfix=[xypath,xyfile];
        pfix(end-8:end)=[]; % remove the 'xypts.csv' portion

        csvwrite([pfix,'mayaCam.csv',sprintf('%s',i)],T);

    end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [b,avgres]=mdlt1(pk,sk)

% function [b,avgres]=mdlt1(pk,sk)
%
%Input:		pk-matrix containing global coordinates (X,Y,Z) of the ith point
%				e.g. pk(i,1), pk(i,2), pk(i,3)
%				sk-matrix containing image coordinates (u,v) of the ith point
%    			e.g. sk(i,1), sk(i,2)
%Output:		sets of 11 DLT parameters for all iterations
%				The code is far from being optimal and many improvements are to come.
%
%Author: 	Tomislav Pribanic, University of Zagreb, Croatia
%e-mail:		Tomislav.Pribanic@zesoi.fer.hr
%				Any comments and suggestions would be more than welcome.
%Date:		September 1999
%Version: 	1.0
%
%Function uses MDLT method adding non-linear constraint:
%(L1*L5+L2*L6+L3*L7)*(L9^2+L10^2+L11^2)=(L1*L9+L2*L10+L3*L11)*(L5*L9+L6*L10+L7*L11) (1)
%(assuring orthogonality of transformation matrix and eliminating redundant parametar) to the
%linear system of DLT represented by basic DLT equations:
%							u=(L1*X+L2*Y+L3*Z+L4)/(L9*X+L10*Y+L11*Z+1);	(2)
%							v=(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1);	(3).
%(u,v)	image coordinates in digitizer units
%L1...L11 	DLT parameters
%(X,Y,Z)	object space coordinates
%Once the non-linear equation (1) was solved for the L1 parameter, it was substituted
% for L1 in the equation (2) and now only 10 DLT parameters appear.
%
%The obtained non-linear system was solved with the following algorithm (Newton's method):
%equations u=f(L2-L11) (2) and v=g(L2-L11) (3) were expressed using truncated Taylor
%series expansion (up to the first derivative) resulting again with 
%the set of linearized equations (for particular point we have):
%	u=fo+pd(fo)/pd(L2)*d(L2)+...+pd(fo)/pd(L11)*d(L11)		(4)
%	v=go+pd(go)/pd(L2)*d(L2)+...+pd(go)/pd(L11)*d(L11)		(5)
%pd- partial derivative
%d-differential
%fo, go, pd(fo)/pd(L2)...pd(fo)/pd(L11)*d(L11) and  pd(go)/pd(L2)...pd(go)/pd(L11) are
%current estimates acquired by previous iteration.
%Initial estimates are provided by conventional 11 DLT parameter method.
%
%Therefore standard linear least square technique can be applied to calculate d(L2)...d(L11)
%elements.
%Each element is in fact d(Li)=Li(current iteration)-Li(previous iteration, known from before).
%Li's of current iteration can be than substituted for a new estimates in (4) and (5) until
%all elements of d(Li's) are satisfactory small.

%REFERENCES:

%1. The paper explains linear and non-linear MDLT.
%	 The function reflects only the linear MDLT (no symmetrical or
%	 asymmetrical lens distortion parameters included).

%   Hatze H. HIGH-PRECISION THREE-DIMENSIONAL PHOTOGRAMMETRIC CALIBRATION
%   AND OBJECT SPACE RECONSTRUCTION USING A MODIFIED DLT-APPROACH.
%   J. Biomechanics, 1988, 21, 533-538

%2. The paper shows the particular mathematical linearization technique for 
%	 solving non-linear nature of equations due to adding non-linear constrain.

%	 Miller N. R., Shapiro R., and McLaughlin T. M. A TECHNIQUE FOR OBTAINING
%	 SPATIAL KINEMATIC PARAMETERS OF SEGMENTS OF BIOMECHANICAL SYSTEMS 
%	 FROM CINEMATOGRAPHIC DATA. J. Biomechanics, 1980, 13, 535-547




%Input:		pk-matrix containing global coordinates (X,Y,Z) of the ith point
%				e.g. pk(i,1), pk(i,2), pk(i,3)
%				sk-matrix containing image coordinates (u,v) of the ith point
%    			e.g. sk(i,1), sk(i,2)
%Output:		sets of 11 DLT parameters for all iterations
%				The code is far from being optimal and many improvements are to come.

%[a]*[b]=[c]

% automatic removal of NaN points added by Ty Hedrick 9/14/00
Cut=[];
for i=1:size(sk,1)
  if isnan(sk(i,1))==1
    Cut(1,size(Cut,2)+1)=i;
  end
end
%Cutlines=[Cut.*2-1, Cut.*2]
pk([Cut],:)=[];
sk([Cut],:)=[];

m=size(pk,1);	% number of calibration points
c=sk';c=c(:);	% re-grouping image coordinates in one column
ite=10; 			%number of iterations

% Solve 'ortogonality' equation (1) for L1
L1=solve('(L1*L5+L2*L6+L3*L7)*(L9^2+L10^2+L11^2)=(L1*L9+L2*L10+L3*L11)*(L5*L9+L6*L10+L7*L11)','L1');
%initialize basic DLT equations (2) and (3)
u=sym('(L1*X+L2*Y+L3*Z+L4)/(L9*X+L10*Y+L11*Z+1)');
v=sym('(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)');
%elimenate L1 out of equation (2)using the (1)
jed1=[ char(L1) '=L1'];
jed2=[ char(u) '=u'];
[L1,u]=solve( jed1, jed2,'L1,u');

%Find the first partial derivatives of (4) and (5)
%f(1)=diff(u,'L1');g(1)=diff(v,'L1'); 
%L1 was chosen to be eliminated. In case other parameter (for example L2) is chosen
%the above line should become active and the appropriate one passive instead.
f(1)=diff(u,'L2');g(1)=diff(v,'L2');
f(2)=diff(u,'L3');g(2)=diff(v,'L3');
f(3)=diff(u,'L4');g(3)=diff(v,'L4');
f(4)=diff(u,'L5');g(4)=diff(v,'L5');
f(5)=diff(u,'L6');g(5)=diff(v,'L6');
f(6)=diff(u,'L7');g(6)=diff(v,'L7');
f(7)=diff(u,'L8');g(7)=diff(v,'L8');
f(8)=diff(u,'L9');g(8)=diff(v,'L9');
f(9)=diff(u,'L10');g(9)=diff(v,'L10');
f(10)=diff(u,'L11');g(10)=diff(v,'L11');

%Find the inital estimates using conventional DLT method
for i=1:m
   a(2*i-1,1)=pk(i,1);
   a(2*i-1,2)=pk(i,2);
   a(2*i-1,3)=pk(i,3);
   a(2*i-1,4)=1;
   a(2*i-1,9)=-pk(i,1)*sk(i,1);
   a(2*i-1,10)=-pk(i,2)*sk(i,1);
   a(2*i-1,11)=-pk(i,3)*sk(i,1);
   a(2*i,5)=pk(i,1);
   a(2*i,6)=pk(i,2);
   a(2*i,7)=pk(i,3);
   a(2*i,8)=1;
   a(2*i,9)=-pk(i,1)*sk(i,2);
   a(2*i,10)=-pk(i,2)*sk(i,2);
   a(2*i,11)=-pk(i,3)*sk(i,2);
end
%Conventional DLT parameters
b=a\c;
%Take the intial estimates for parameters
%L1=b(1); L1 is excluded.
L2=b(2);L3=b(3);L4=b(4);L5=b(5);L6=b(6);
L7=b(7);L8=b(8);L9=b(9);L10=b(10);L11=b(11);

%Save a for use in generating residuals
a_init=a;
clear a b c

%Perform the linear least square technique on the system of equations made from (4) and (5)
%IMPORTANT NOTE:
%the elements of matrices a and c (see below) are expressions based on (4) and (5) and part
%of program which calculates the partial derivatives (from line %Find the first partial...
%to the line %Find the inital...)
%However the elements itself are computed outside the function since the computation itself
%(for instance via MATLAB eval function: a(2*i-1,1)=eval(f(1));a(2*i-1,2)=eval(f(2)); etc.
%c(2*i-1)=sk(i,1)-eval(u);c(2*i)=sk(i,2)-eval(v);)is only time consuming and unnecessary.
%Thus the mentioned part of the program has only educational/historical purpose and 
%can be excluded for practical purposes

for k=1:ite  %k-th iteartion
   %Form matrices a and c
   for i=1:m	%i-th point
      X=pk(i,1);Y=pk(i,2);Z=pk(i,3);
      %first row of the i-th point; contribution of (4) equation
      a(2*i-1,1)=(-X*L6*L9^2-X*L6*L11^2+X*L10*L5*L9+X*L10*L7*L11+Y*L5*L10^2+Y*L5*L11^2-Y*L9*L6*L10-Y*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      a(2*i-1,2)=(-X*L7*L9^2-X*L7*L10^2+X*L11*L5*L9+X*L11*L6*L10+Z*L5*L10^2+Z*L5*L11^2-Z*L9*L6*L10-Z*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      a(2*i-1,3)=(L5*L10^2+L5*L11^2-L9*L6*L10-L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      a(2*i-1,4)=(L4*L10^2+L4*L11^2+X*L2*L10*L9+X*L3*L11*L9+L2*Y*L10^2+L2*Y*L11^2+L3*Z*L10^2+L3*Z*L11^2)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(L11^2+L10^2+L9*X*L10^2+L9*X*L11^2+L10^3*Y+L10*Y*L11^2+L11*Z*L10^2+L11^3*Z);
      a(2*i-1,5)=(-X*L2*L9^2-X*L2*L11^2+X*L3*L11*L10-L2*Y*L9*L10-L3*Z*L9*L10-L4*L9*L10)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(-L9^2*X*L10-L10^2*Y*L9-L11*Z*L9*L10-L9*L10);
      a(2*i-1,6)=(-X*L3*L9^2-X*L3*L10^2+X*L2*L10*L11-L2*Y*L9*L11-L3*Z*L9*L11-L4*L9*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(-L9^2*X*L11-L10*Y*L9*L11-L11^2*Z*L9-L9*L11);
      a(2*i-1,7)=0;
      a(2*i-1,8)=(-2*X*L2*L6*L9-2*X*L3*L7*L9+X*L2*L10*L5+X*L3*L11*L5-L2*Y*L6*L10-L2*Y*L7*L11-L3*Z*L6*L10-L3*Z*L7*L11-L4*L6*L10-L4*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(X*L5*L10^2+X*L5*L11^2-2*L9*X*L6*L10-2*L9*X*L7*L11-L10^2*Y*L6-L10*Y*L7*L11-L11*Z*L6*L10-L11^2*Z*L7-L6*L10-L7*L11);
      a(2*i-1,9)=(2*L4*L5*L10-2*X*L3*L7*L10+X*L2*L5*L9+X*L2*L7*L11+X*L3*L11*L6+2*L2*Y*L5*L10-L2*Y*L9*L6+2*L3*Z*L5*L10-L3*Z*L9*L6-L4*L9*L6)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(2*L5*L10+2*L9*X*L5*L10-L9^2*X*L6+3*L10^2*Y*L5+Y*L5*L11^2-2*L10*Y*L9*L6-Y*L9*L7*L11+2*L11*Z*L5*L10-L11*Z*L9*L6-L9*L6);
      a(2*i-1,10)=(2*L4*L5*L11-2*X*L2*L6*L11+X*L2*L10*L7+X*L3*L5*L9+X*L3*L6*L10+2*L2*Y*L5*L11-L2*Y*L9*L7+2*L3*Z*L5*L11-L3*Z*L9*L7-L4*L9*L7)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11)^2*(2*L5*L11+2*L9*X*L5*L11-L9^2*X*L7+2*L10*Y*L5*L11-L10*Y*L9*L7+Z*L5*L10^2+3*L11^2*Z*L5-Z*L9*L6*L10-2*L11*Z*L9*L7-L9*L7);
      %second row of the i-th point; contribution of (5) equation
      a(2*i,1)=0;
      a(2*i,2)=0;
      a(2*i,3)=0;
      a(2*i,4)=X/(L9*X+L10*Y+L11*Z+1);
      a(2*i,5)=Y/(L9*X+L10*Y+L11*Z+1);
      a(2*i,6)=Z/(L9*X+L10*Y+L11*Z+1);
      a(2*i,7)=1/(L9*X+L10*Y+L11*Z+1);
      a(2*i,8)=-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)^2*X;
      a(2*i,9)=-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)^2*Y;
      a(2*i,10)=-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)^2*Z;
      %analogicaly for c matrice
      c(2*i-1)=sk(i,1)-(L4*L5*L10^2+L4*L5*L11^2-X*L2*L6*L9^2-X*L2*L6*L11^2-X*L3*L7*L9^2-X*L3*L7*L10^2+X*L2*L10*L5*L9+X*L2*L10*L7*L11+X*L3*L11*L5*L9+X*L3*L11*L6*L10+L2*Y*L5*L10^2+L2*Y*L5*L11^2-L2*Y*L9*L6*L10-L2*Y*L9*L7*L11+L3*Z*L5*L10^2+L3*Z*L5*L11^2-L3*Z*L9*L6*L10-L3*Z*L9*L7*L11-L4*L9*L6*L10-L4*L9*L7*L11)/(L5*L11^2+L5*L10^2+L9*X*L5*L10^2+L9*X*L5*L11^2-L9^2*X*L6*L10-L9^2*X*L7*L11+L10^3*Y*L5+L10*Y*L5*L11^2-L10^2*Y*L9*L6-L10*Y*L9*L7*L11+L11*Z*L5*L10^2+L11^3*Z*L5-L11*Z*L9*L6*L10-L11^2*Z*L9*L7-L9*L6*L10-L9*L7*L11);
      c(2*i)=sk(i,2)-(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1);
   end
   c=c';c=c(:); %regrouping in one column
   b=a\c; %10 MDLT parameters of the k-the iteration
   
   % Prepare the estimates for a new iteration
   L2=b(1)+L2;L3=b(2)+L3;L4=b(3)+L4;L5=b(4)+L5;L6=b(5)+L6;
   L7=b(6)+L7;L8=b(7)+L8;L9=b(8)+L9;L10=b(9)+L10;L11=b(10)+L11;
   % Calculate L1 based on equation (1)and 'save' the parameters of the k-th iteration
   dlt(k,:)=[eval(L1) L2 L3 L4 L5 L6 L7 L8 L9 L10 L11];
   %%disp('Number of iterations performed'),k
   clear a b c
end
%b=dlt;%return all sets of 11 DLT parameters for all iterations
b=dlt(k,:)';%return last DLT set in KineMat orientation


% calculate residuals - added by Ty Hedrick
% note that this currently uses the initial estimate of the DLT parameters rather than the final set
D=a_init*b;
sk_l=sk';
sk_l=sk_l(:); 
R=sk_l-D;
res=norm(R); avgres=res/size(R,1)^.5;