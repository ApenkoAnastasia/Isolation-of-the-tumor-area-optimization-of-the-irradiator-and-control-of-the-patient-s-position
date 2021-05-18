function P = dip_Ellip_g(N,fx1,fy1,fx2,fy2,D0)
global p a aaa
aa = [round(N/2*(1-fx1)),round(N/2*(1-fy1))];
bb = [round(N/2*(1-fx2)),round(N/2*(1-fy2))];
c = (aa-bb);
d = sqrt(c*c(:))*(D0+1);
[X,Y] = ndgrid(1:N,1:N);
Dxa = X-aa(1);
Dya = Y-aa(2);
Dxb = X-bb(1);
Dyb = Y-bb(2);
Da = sqrt(Dxa.*Dxa+Dya.*Dya);
Db = sqrt(Dxb.*Dxb+Dyb.*Dyb);
D = Da + Db; 
 P = D < d;
 P = P.*exp(-(D/(d*1.4)).^2); % рисуем аппертуру в виде функции Гауса, для более лёгкого поиска точки экстремума
