function [mat]= cou_repair(mat, l_complete_rem, l_ph_meth)
%
%
%function [mat]= cou_repair(mat)
%
% Defect channels have to be NaN. Then COU_REPAIR replaces this rows
% with the mean of the surrounding good rows.
%
% (1) Cuts away the biggest compact defect part and reorder the matrix,
% that the first element is a good one.
% (2) search between the last and first working rows all compact defect
% areas.
% (3) refill them.
% 
%
% input     mat         matrix [n x 64] n sample, 64 channels (2pi)
%                       whereas the defect rows musst have the value NaN!
% Limit for complete remove of rows:    6
% Limit for phaseshift-mean-method:     5
%  


if nargin < 3
   l_ph_meth= 5;
end
if nargin < 2
   l_complete_rem= 6;
end   



c=isnan(mat');
c=c(:,1);

% rotate mat until a good line is on the bottom
i=1;
if c(1)==1
    while c(i)==1
        i=i+1;
    end;
end;
mat=circshift(mat, [0 -i]);


% search not working compact parts
lc=length(c),
part_nr=0;
% data of the defect channels
%  def(i,j,k) ... i no. of defect area; j start point; k length
%defectpart(1:20,1:2)=0;
defectpart(1:1,1:2)=NaN;%***
for i=2:length(c)
    % search a start of a defect area
    if c(i-1)==0 && c(i)==1
        part_nr=part_nr+1;          
        defectpart(part_nr, 1)=i;
        defectpart(part_nr, 2)=1;
    end;
    %
    if c(i-1)==1 && c(i)==1
        defectpart(part_nr, 2)=defectpart(part_nr, 2)+1;
    end;    
end;

defectpart,
% 
a=size(defectpart);
i=1;
while i<=a(1)-1
    % amount of defect channels in this "defectchannelcluster"
    %  def(i,j,k) ... i no. of defect area; j start point; k length
    for j=1:defectpart(i,2)        
        % upper row
        row1=mat(:,defectpart(i, 1)-1+defectpart(i, 2));
        % lower row
        row2=mat(:,defectpart(i, 1)-1-1 +(j-1) );
        % 
        % complete phaseshift has to be divided by the amount of steps
        % to shift
        steps=defectpart(i, 2)+2-j;
        %
        pointshift=cou_repair_two_rows(row1, row2),
        %
        mat(:,defectpart(i, 1)-1 +(j-1))=(circshift(row1,round(pointshift/steps*(steps-1)))+circshift(row2, -round(pointshift/steps)))/2;        
    end;
    i=i+1;
 end;

% 
end