function [x_m,P_m,y_m,e_y,Kt,x_p,epsilon_x,epsilon_y] = EKF(y_nom,P_p,val,R,Q,x)
%EKF Summary of this function goes here
%   Detailed explanation goes here
[Ft,Gt,Ht,Omega] = Jacobians(x(:,1),val) ;
for t = 1:1000
    x_m(:,t+1) = x(:,t) ;
    P_m = Ft*P_p*Ft'+Omega*Q*Omega' ;

    [Ft,Gt,Ht,Omega] = Jacobians(x_m(:,t+1),val) ;
    y_m = Ht*x_m ;
    e_y = y_nom(:,t+1)-y_m(:,t+1) ;
    Kt = P_m*Ht'*(Ht*P_m*Ht'+R)^-1 ;
    x_p(:,t+1) = x_m(:,t+1)+Kt*e_y ;
    P_p = (eye(6)-Kt*Ht)*P_m ;

    %NEES Test
    e_x = x(:,t+1)-x_p(:,t+1) ;
    epsilon_x(t+1) = e_x'*(P_p)^-1*e_x ;

    %NIS Test
    S = Ht*P_m*Ht'+R ;
    epsilon_y(t+1) = e_y'*S^-1*e_y ;
end
end

