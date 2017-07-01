function pointshift=cou_repair_two_rows(row1, row2)
%
%
%function phaseshift=cou_repair_two_rows(row1, row2)
%
%   input   row1, row2  time rows of a couronne matrix
%   output  pointshift, amount of points of the phaseshift between these
%   rows
%
% Defect channels have to be NaN. Then COU_REPAIR replaces this rows
% with the mean of the surrounding good rows.


    % make rows mean free
    row1=row1-mean(row1);
    row2=row2-mean(row2);
    % normalize to the amplitude maximum
    row1=row1/max(abs(row1));
    row2=row2/max(abs(row2));

    % shift 0.5ms to the left and to the right (that means with
    % dt_sample=800ns) 625 points to each side
    min=Inf;
    for i=-600:20:600
        if std(circshift(row1,i)-row2)<min
            min=std(circshift(row1,i)-row2);
            pointshift=i;
%         else
%             pointshift=0;
        end;
    end;

end