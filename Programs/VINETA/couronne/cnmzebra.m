function cnmzebra(tint, t1, ch, defch, diph);
%
%FUNCTION CNMZEBRA(tint, t1, ch, defch, diph);
% Evaluates all BIN-files for zebra plots.
% needs: readbin
%  IN: tint: time interval (ms)  which should be shown in the timeplot
%            and in the zebraplot
%    t1: start point of tseries
%    ch: number of channel shown in the time trace
%    defch: vector of bad channels
%    diph(opt): dirty phase: 1 - correct, 0 - don't
% OUT:
% EXAMPLE: cnmzebra(1.1, 6001, 1, [2 35], 1);
% Continue with <<plotzebralist([1 2 3], 1, 1, [1 2 3], 1)>>

if nargin<5; diph=0; end
if nargin<4; defch=[]; end
if nargin<3; ch=1; end
if nargin<2; t1=1; end
if nargin<1; tint=4; end

a = dir('cnm*.BIN');
b = dir('cou*.MDF');

for i=1:length(a)    
    disp_num(i, length(a));
    [A tt] = readbin(a(i).name);
    % DIRTY PHASE REMOVAL
    if diph==1
      [A tt diphfit] = dirtyphase(A, tt);
    end;
    
    A = A';

% ZEBRA-PLOT
  [zt phi zA{i}] = mat2zebra(A, tt, tint, t1, defch);
end;

save('3_zebra.mat', 'zt', 'phi', 'zA');

end