function [R,t] = camPositionFromDLT(coefs)

% function [R,t] = camPositionFromDLT(coefs)
%
% Input:    11 parameter DLT coefficients
% Outputs:  R = camera rotation matrix
%           t = camera xyz coordinates


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

R=inv(T3);
t=[xyz(1),xyz(2),xyz(3)];

end