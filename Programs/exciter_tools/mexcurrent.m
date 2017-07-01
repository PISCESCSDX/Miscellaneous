function [currex] = mexcurrent(Uex, fex)
%function [currex] = mexcurrent(Uex, fex)
% Current of the magnetic exciter.
%
% Uex [V]
% fex [Hz]

load /home/cbra/matlab/m-files/exciter_tools/currmax_oct100.mat
currex = 0.28 * Uex/0.7.*ppval(spli_curr, fex); % 0.28 factor manual 
                                                % from measurement

end