function u = lorenzf(t,x)
global SIGMA R B

u = [SIGMA*(x(2)-x(1)), x(1)*(R - x(3)) - x(2), x(1)*x(2) - B*x(3)]';