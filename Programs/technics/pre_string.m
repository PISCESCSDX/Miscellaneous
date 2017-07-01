function prestr = pre_string(num, maxnum, strchar)
%function str = pre_string(num, maxnum, strchar)
% Creates a string of the character strchar, so that sum of the length of
% the string and the number is equal the length of the maximal possible
% number maxnum.
%
% num: current number
% maxnum: maximal number, which will ever appear
% strchar: character which is used in the prestring (default: space)
if nargin<3
  strchar = ' ';
end


if num==0
  d=0;
else
  d=floor(log10(num));
end

% pre: amount of characters in front of num
pre = length(num2str(maxnum));

prestr='';
if d<pre
  for i=1:pre-d-1
    prestr = [prestr strchar];
  end
end

end