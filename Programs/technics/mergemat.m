function [out] = mergemat(A, B)
%function [out] = mergemat(A; B)
% MERGE 2 matrices A and B.
% Sort the result and remove double values.
% A, B: column-vectors!

C = [A; B];
C = sort(C);

ctr = 1;
out = []; out(1) = C(1);

for i = 2:length(C)
  if C(i) ~= out(ctr)
    out(ctr+1) = C(i);
    ctr = ctr+1;
  end
end

end