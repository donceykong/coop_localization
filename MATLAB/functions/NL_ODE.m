function dxdt = NL_ODE(~, x, u, L, w)

dxdt=zeros(6,1); % Initiate size of x_dot to preallocate memory

dxdt(1) = u(1)*cos(x(3))+w(1) ;
dxdt(2) = u(1)*sin(x(3))+w(2) ;
dxdt(3) = (u(1)/L)*tan(u(2))+w(3) ;
dxdt(4) = u(3)*cos(x(6))+w(4) ;
dxdt(5) = u(3)*sin(x(6))+w(5) ;
dxdt(6) = u(4)+w(6) ;

end
