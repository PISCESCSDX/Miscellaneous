function PW = fct_bfield_close2wire(P, PWbefore, wm, eps)
%==========================================================================
%function PW = fct_bfield_close2wire(P, PWbefore, wm, eps)
%
% !!! Code seems to work, but is very slow !!!
%
% Last change: 08.03.2012, San Diego, C. Brandt
% 08.03.2012, San Diego, C. Brandt
%--------------------------------------------------------------------------
% FCT_BFIELD_CLOSE2WIRE calculates the positions PW, where P(x,y,z)
% is closer than 'eps' to any coil wire.
%--------------------------------------------------------------------------
% IN:  P: 3D meshgrid where B should be calculated
%   PWbefore: Points of close wires before
%     wm: wire matrix containing the wire start and end points
%OUT: PW: matrix (x,y,z), 0 no wire, NaN wire is closer than eps to P
%--------------------------------------------------------------------------
% EXAMPLES: PW = fct_bfield_close2wire(P, wm, eps)
%==========================================================================

% number of wires
lw = length(wm.S1);

[dimx,dimy,dimz] = size(P.x);
PW = PWbefore;

% Go through all wires
ctr = 0;
for iw=1:lw
  disp_num(iw,lw)
  for ii = 1:dimx
    for jj = 1:dimy
      for kk = 1:dimz
        % Current position vector R (change from mm to m)
        p  = [P.x(ii,jj,kk) P.y(ii,jj,kk) P.z(ii,jj,kk)];
        s = wm.S1{iw};
        q = wm.S2{iw} - s;
        
        % Minimal distance between wire and point R
        tmin = (dot(p,q) - dot(q,s)) / dot(q,q);
        
        % Shortest perpendicular dist. only on wire if tmin E [0,1]
        if tmin>=0 || tmin<=1
          diff = norm(s + tmin*q - p);
        else
          d1 = norm(p-wm.S1{iw});
          d2 = norm(p-wm.S2{iw});
          diff = min([d1 d2]);
        end
        
        % Store position if difference is smaller than epsilon
        if diff<eps
          ctr = ctr+1;
          PW(ii,jj,kk) = NaN;
        end
        
      end
    end
  end
end

end