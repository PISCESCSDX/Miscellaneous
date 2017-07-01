function [xmirror] = mirrorx(orig)

%flip data points horizontally

for i = 1:size(orig,2)
    if rem(i,2) ~= 0
        xmirror(:,i) = 1025-orig(:,i);
    else
        xmirror(:,i) = orig(:,i);
    end
end