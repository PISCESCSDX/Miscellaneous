function [uexc, iexc] = eexcui(uin)
%FUNCTION [uexc iexc] = eexcui(uin)
% Calculate the output voltage and the current to the electric exciter.
% [ !!! For another pressure the current can be different. !!!]
% [ This calibration is for p=0.2Pa, IB=170.62A ]
% [ folder: 20070220_eexc/15 ]
%
% INPUT:    uin     input voltage to amplifier (OMNITRONIC) /V
% OUTPUT:   uexc    amplitude of output voltage /V
%           iexc    amplitude of current /A (be aware of the 
%                   calibration parameters read above!)
% EXAMPLE: [uexc iexc] = eexcui(uin);

if nargin<1; error('Voltage Uin is missing!'); end;

p = [-0.34396 82.5026 -0.020312];
    uexc = p(1)*(uin.*uin) + p(2).*uin + p(3);
p = [-0.75386 0.82166 -0.0199];
    iexc = p(1)*(uin.*uin) + p(2).*uin + p(3);

% first parameters
% p = [-0.33031 79.1506 -0.019547];
%     uexc = p(1)*(uin.*uin) + p(2).*uin + p(3);
% p = [-0.71813 0.78476 -0.018837];
%     iexc = p(1)*(uin.*uin) + p(2).*uin + p(3);    

end