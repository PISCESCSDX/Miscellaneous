% Connect to CSDX pc
mdsconnect('132.239.202.220');

shotno = input('Enter the shot number to download: ');
mdsopen('csdx',shotno);

%========================================================================>>
% Definition of constants
%--------------------------------------------------------------------------
pa.Te = 4.0;                                 % electron temperature (eV)
pa.ion_mass = 40.0;                          % ion mass (u)
pa.tip_area_dual3x3 = 0.033*0.1*2.0;         % cm^2 dual 3x3 probe 'pr18'
pa.tip_area_RS = 0.06*0.25*2.0;              % cm^2 Reynold stress probe
pa.Isat_resistor = 50.0;                     % shunt (Ohm)
%
pa.Isat_amp = [-100 -100 -100 500 500 -100 -100 -100 -100];
pa.Vf_amp   = [0.014 0.014 0.014 0.014 0.014 0.014 0.014 0.014 0.014];
%========================================================================<<



%========================================================================>>
% Read 18 tip probe
%--------------------------------------------------------------------------
pr18.Is{1} = mdsvalue('\acq196_001:input_01');
pr18.Is{2} = mdsvalue('\acq196_001:input_02');
pr18.Is{3} = mdsvalue('\acq196_001:input_03');
pr18.Is{4} = mdsvalue('\acq196_001:input_04');
pr18.Is{5} = mdsvalue('\acq196_001:input_05');
pr18.Is{6} = mdsvalue('\acq196_001:input_06');
pr18.Is{7} = mdsvalue('\acq196_001:input_07');
pr18.Is{8} = mdsvalue('\acq196_001:input_08');
pr18.Is{9} = mdsvalue('\acq196_001:input_09');

pr18.Vf{1} = mdsvalue('\acq196_001:input_10');
pr18.Vf{2} = mdsvalue('\acq196_001:input_11');
pr18.Vf{3} = mdsvalue('\acq196_001:input_12');
pr18.Vf{4} = mdsvalue('\acq196_001:input_13');
pr18.Vf{5} = mdsvalue('\acq196_001:input_14');
pr18.Vf{6} = mdsvalue('\acq196_001:input_15');
pr18.Vf{7} = mdsvalue('\acq196_001:input_16');
pr18.Vf{8} = mdsvalue('\acq196_001:input_17');
pr18.Vf{9} = mdsvalue('\acq196_001:input_18');
%========================================================================<<


%========================================================================>>
% RS probe
%--------------------------------------------------------------------------
prRS.Is_1 = mdsvalue('\acq196_001:input_26');
prRS.Vf_1 = mdsvalue('\acq196_001:input_25');
prRS.Vf_2 = mdsvalue('\acq196_001:input_27');
prRS.Vf_3 = mdsvalue('\acq196_001:input_28');
prRS.pos  = mdsvalue('\acq196_001:input_29');
prRS.TRG  = mdsvalue('\acq196_001:input_30');
%========================================================================<<


% Save data in Matlab format
fn = [num2str(shotno) '.mat'];
save(fn,'pa','pr18','prRS')
