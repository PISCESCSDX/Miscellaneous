function [mat_oct] = octwires;
% === CREATION OF COIL-MATRIX FOR B-FIELD CALCULATION ===
% create matrix wires of octupole mat_oct(coilnr, PC1, PC2) -mat_ocq[n, 7]
% a length of short coil side [m]
% b:  length of long coil side [m]
% rc: distance to tube center [m]
  a = 0.0300;
  b=0.150;  
  rc=0.067;

small_phi = atan((a/2)/rc);       % angle coil edge to x-axis
helpdist = sqrt((a/2)^2 + rc^2);   % distance to coil edge
windings = 100;
for i=1:8
    alpha=45/180*pi*(i-1);
    x1=rc*cos(alpha+small_phi);
    y1=rc*sin(alpha+small_phi);
    x2=rc*cos(alpha-small_phi);
    y2=rc*sin(alpha-small_phi);
    % wire 1
    mat_oct(4*(i-1)+1,1) = i;
    mat_oct(4*(i-1)+1,2) = x1;    
    mat_oct(4*(i-1)+1,3) = y1;
    mat_oct(4*(i-1)+1,4) = 0;
    mat_oct(4*(i-1)+1,5) = x1;    
    mat_oct(4*(i-1)+1,6) = y1;
    mat_oct(4*(i-1)+1,7) = b;    
    mat_oct(4*(i-1)+1,8) = windings;
    % wire 2
    mat_oct(4*(i-1)+2,1) = i;
    mat_oct(4*(i-1)+2,2) = x1;    
    mat_oct(4*(i-1)+2,3) = y1;
    mat_oct(4*(i-1)+2,4) = b;
    mat_oct(4*(i-1)+2,5) = x2;    
    mat_oct(4*(i-1)+2,6) = y2;
    mat_oct(4*(i-1)+2,7) = b;        
    mat_oct(4*(i-1)+2,8) = windings;    
    % wire 3
    mat_oct(4*(i-1)+3,1) = i;
    mat_oct(4*(i-1)+3,2) = x2;    
    mat_oct(4*(i-1)+3,3) = y2;
    mat_oct(4*(i-1)+3,4) = b;
    mat_oct(4*(i-1)+3,5) = x2;    
    mat_oct(4*(i-1)+3,6) = y2;
    mat_oct(4*(i-1)+3,7) = 0;            
    mat_oct(4*(i-1)+3,8) = windings;    
    % wire 4
    mat_oct(4*(i-1)+4,1) = i;
    mat_oct(4*(i-1)+4,2) = x2;    
    mat_oct(4*(i-1)+4,3) = y2;
    mat_oct(4*(i-1)+4,4) = 0;
    mat_oct(4*(i-1)+4,5) = x1;    
    mat_oct(4*(i-1)+4,6) = y1;
    mat_oct(4*(i-1)+4,7) = 0;                
    mat_oct(4*(i-1)+4,8) = windings;    
end

end