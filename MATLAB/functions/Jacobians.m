function [Ft,Gt,Ht,Omega] = Jacobians(x,val)
%JACOBIANS Summary of this function goes here
%     val = [va_nom vg_nom L phi_g_nom wa_nom val(6) val(7) val(8) val(9)] ;
    denom = ((x(5)-x(2))^2 + (x(4)-x(1))^2);
    At = [0 0 -val(2)*sin(x(3)) 0 0 0; 0 0 val(2)*cos(x(3)) 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 -val(1)*sin(x(6)); 0 0 0 0 0 val(1)*cos(x(6)); 0 0 0 0 0 0] ;
    Bt = [cos(x(3)) 0 0 0; sin(x(3)) 0 0 0; 1/val(3)*tan(val(4)) val(2)/(val(3)*cos(val(4))^2) 0 0; 0 0 cos(x(6)) 0; 0 0 sin(x(6)) 0; 0 0 0 1] ;
    C = [(x(5)-x(2))/denom, (x(1)-x(4))/denom, -1, (x(2)-x(5))/denom (x(4)-x(1))/denom, 0; 
        (x(1)-x(4))/sqrt(denom), (x(2)-x(5))/sqrt(denom), 0, (x(4)-x(1))/sqrt(denom), (x(5)-x(2))/sqrt(denom), 0; 
        (x(5)-x(2))/denom, (x(1)-x(4))/denom, 0, (x(2)-x(5))/denom (x(4)-x(1))/denom, -1; 
        0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0] ;
    Ft = eye(6)+.1*At ;
    Gt = .1*Bt ;
    Ht = C ;
    Omega = .1*eye(6) ;
end

