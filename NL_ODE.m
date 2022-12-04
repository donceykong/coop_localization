function dxdt = NL_ODE(~, x, u, L)

dxdt=zeros(6,1); % Initiate size of x_dot to preallocate memory

dxdt(1) = u(1)*cos(x(3));
dxdt(2) = u(1)*sin(x(3));
dxdt(3) = (u(1)/L)*tan(u(2));
dxdt(4) = u(3)*cos(x(6));
dxdt(5) = u(3)*sin(x(6));
dxdt(6) = u(4);

end