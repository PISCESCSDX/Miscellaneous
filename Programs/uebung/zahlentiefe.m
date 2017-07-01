EPS=1;
for num=1:1000
 EPS=EPS/2;
 if (1+EPS)<=1
   EPS=EPS*2;
   break
 end
end
EPS, num
