function ak47(tool)
%function ak47(tool)
% End licence connection of idle MatLab users in the VINETA-group.
%  IN: tool: string array e.g. 'curve', 'extsym', 'image', 'signal', 
%            'spline', 'statistic', 'symbol', 'wavelet'
% Ex: tool = ak47('signal');

if nargin<1
  error('Enter toolboxname!');
end


for i=0:100
  lm_rtb(tool,i);
end

end