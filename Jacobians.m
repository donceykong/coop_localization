function [Ft,Gt,Ht,Omega_t] = Jacobians(x,val)
%JACOBIANS Summary of this function goes here
%     val = [va_nom vg_nom L phi_g_nom wa_nom val(6) val(7) val(8) val(9)] ;
    At = [0 0 -val(2)*sin(x(3)) 0 0 0; 0 0 val(2)*cos(x(3)) 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 -val(1)*sin(x(6)); 0 0 0 0 0 val(1)*cos(x(6)); 0 0 0 0 0 0] ;
    Bt = [cos(x(3)) 0 0 0; sin(x(3)) 0 0 0; 1/val(3)*tan(val(4)) val(2)/(val(3)*cos(val(4))^2) 0 0; 0 0 cos(x(6)) 0; 0 0 sin(x(6)) 0; 0 0 0 1] ;
    C = [(val(6)-val(7))/(((val(6)-val(7))^2/(val(8)-val(9))^2+1)*(val(8)-val(9))^2) -1/((val(8)-val(9))*((val(6)-val(7))^2/(val(8)-val(9))^2+1)) -1 -(val(6)-val(7))/((val(8)-val(9))^2*((val(6)-val(7))^2/(val(8)-val(9))^2+1)) 1/((val(8)-val(9))*((val(6)-val(7))^2/(val(8)-val(9))^2+1)) 0; (val(9)-val(8))/sqrt((val(9)-val(8))^2+(val(7)-val(6))^2) (val(7)-val(6))/sqrt((val(7)-val(6))^2+(val(9)-val(8))^2) 0 -(val(9)-val(8))/sqrt((val(9)-val(8))^2+(val(7)-val(6))^2) -(val(7)-val(6))/sqrt((val(9)-val(8))^2+(val(7)-val(6))^2) 0; -(val(7)-val(6))/((val(9)-val(8))^2*((val(7)-val(6))^2/(val(9)-val(8))^2+1)) 1/((val(9)-val(8))*((val(7)-val(6))^2/(val(9)-val(8))^2+1)) 0 (val(7)-val(6))/(((val(7)-val(6))^2/(val(9)-val(8))^2+1)*(val(9)-val(8))^2) -1/((val(9)-val(8))*((val(7)-val(6))^2/(val(9)-val(8))^2+1)) 0; 0 0 0 1 0 0; 0 0 0 0 1 0] ;
    D = zeros(5,4) ;
    Ft = eye(6)+.1*At ;
    Gt = .1*Bt ;
    Ht = C ;
    Omega = eye(6) ;
    Omega_t = .1*Omega ;
end

