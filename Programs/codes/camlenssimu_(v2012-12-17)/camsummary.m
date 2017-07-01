% Short script to summarize the results in one file

fnmain0 = 'ccd_d3d0_';
fnmain1 = 'ccd_';


ccd0.info = 'background plasma = averaged plasma';
ccd1.info = 'background plasma with superimposed fluctuations';
ccdd.info = 'difference: ccd1-ccd0';

he0 = zeros(200,200);
he1 = zeros(200,200);

maxccd0ccd = -Inf;
maxccd0cur = -Inf;
maxccd1ccd = -Inf;
maxccd1cur = -Inf;

maxccddccd = -Inf;
maxccddcur = -Inf;

minccddccd = +Inf;
minccddcur = +Inf;

for i=1:15
  fn0 = mkstring(fnmain0, '0', i, 1000, '.mat');
  load(fn0);he0 = zeros(200,200);

  he0 = he0 + ca.currccd;
  ccd0.ccd{i} = he0;
  ccd0.currccd{i} = ca.currccd;
  
  clear ca;
  fn1 = mkstring(fnmain1, '0', i, 1000, '.mat');
  load(fn1);
  he1 = he1 + ca.currccd;
  ccd1.ccd{i} = he1;
  ccd1.currccd{i} = ca.currccd;
  clear ca;
  
  % Difference to get fluctuations
  ccdd.ccd{i} = ccd1.ccd{i} - ccd0.ccd{i};
  ccdd.currccd{i} = ccd1.currccd{i} - ccd0.currccd{i};
  
  
  if matmax(ccd0.ccd{i})>maxccd0ccd
    maxccd0ccd = matmax(ccd0.ccd{i});
  end
  if matmax(ccd0.currccd{i})>maxccd0cur
    maxccd0cur = matmax(ccd0.currccd{i});
  end
  
  if matmax(ccd1.ccd{i})>maxccd1ccd
    maxccd1ccd = matmax(ccd1.ccd{i});
  end
  if matmax(ccd1.currccd{i})>maxccd1cur
    maxccd1cur = matmax(ccd1.currccd{i});
  end

  if matmax(ccdd.ccd{i})>maxccddccd
    maxccddccd = matmax(ccdd.ccd{i});
  end
  if matmax(ccdd.currccd{i})>maxccddcur
    maxccddcur = matmax(ccdd.currccd{i});
  end
  
  if matmin(ccdd.ccd{i})<minccddccd
    minccddccd = matmin(ccdd.ccd{i});
  end
  if matmin(ccdd.currccd{i})<minccddcur
    minccddcur = matmin(ccdd.currccd{i});
  end
  
end

% Allocate maxima and minima
ccd0.ccdmax     = maxccd0ccd;
ccd0.currccdmax = maxccd0cur;

ccd1.ccdmax     = maxccd1ccd;
ccd1.currccdmax = maxccd1cur;

ccdd.ccdmax     = maxccddccd;
ccdd.currccdmax = maxccddcur;

ccdd.ccdmin     = minccddccd;
ccdd.currccdmin = minccddcur;


% Inverse: Play summed movie from near to far
he0 = zeros(200,200);
he1 = zeros(200,200);

ctr = 0;
for i=15:-1:1
  ctr = ctr+1;
  fn0 = mkstring(fnmain0, '0', i, 1000, '.mat');
  load(fn0);
  he0 = he0 + ca.currccd;
  invccd0.ccd{ctr} = he0;
  invccd0.currccd{ctr} = ca.currccd;
  
  clear ca;
  fn1 = mkstring(fnmain1, '0', i, 1000, '.mat');
  load(fn1);
  he1 = he1 + ca.currccd;
  invccd1.ccd{ctr} = he1;
  invccd1.currccd{ctr} = ca.currccd;
  clear ca;
  
  % Difference to get fluctuations
  invccdd.ccd{ctr} = invccd1.ccd{ctr} - invccd0.ccd{ctr};
  invccdd.currccd{ctr} = invccd1.currccd{ctr} - invccd0.currccd{ctr};
  
end


% Save all
save('camsummary.mat', 'ccd0', 'ccd1', 'ccdd', ...
  'invccd0', 'invccd1', 'invccdd')