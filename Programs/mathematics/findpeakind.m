function [peak_ind] = findpeakind(signal);
% Finds the maximum peak of signal and looks to both sides for its end. The
% end is defined, where it again goes up or stays constant.
% output:   peak_ind    [left_ind center_ind right_ind signalmaximum]
% EX:

[sigmax indmax] = max(signal);

sigend = length(signal);

% test left side
statvar=0; pos=indmax-1;
while statvar==0
    if pos-1<=1
        pos = 1;
        break;
    end;
    if signal(pos-1)>signal(pos)
        statvar=1;
    else
        pos=pos-1;
    end;
end;

% left boundary
peak_ind(1) = pos;

% test left side
statvar=0; pos=indmax+1;
while statvar==0
    if pos+1>=sigend
        pos = sigend;
        break;
    end;
    if signal(pos+1)>signal(pos)
        statvar=1;
    else
        pos=pos+1;
    end;    
end;

% left boundary
peak_ind(2) = indmax;
peak_ind(3) = pos;
peak_ind(4) = sigmax;

end