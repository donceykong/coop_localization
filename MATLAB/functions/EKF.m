function [x_m,P_m,y_m,e_y,Kt,x_p,epsilon_x,epsilon_y,sigma,innovation,error] = EKF(y_true,P_p,perturb_x0,val,R,Q,x_true)
%EKF Summary of this function goes here
%   Detailed explanation goes here
[Ft,~,~,Omega] = Jacobians(perturb_x0,val) ;
for t = 1:1000
    x_m(:,t+1) = x_true(:,t) ;
    P_m = Ft*P_p*Ft'+Omega*Q*Omega' ;

    [Ft,~,Ht,Omega] = Jacobians(x_m(:,t+1),val) ;
    y_m(:,t+1) = Ht*x_m(:,t+1) ;
    e_y = y_true(:,t+1)-y_m(:,t+1) ;
    innovation(:,t+1) = e_y ;
    Kt = P_m*Ht'*(Ht*P_m*Ht'+R)^-1 ;
    x_p(:,t+1) = x_m(:,t+1)+Kt*e_y ;
    P_p = (eye(6)-Kt*Ht)*P_m ;
    sigma(:,t+1) = diag(P_p) ;

    %NEES Test
    e_x = x_true(:,t+1)-x_p(:,t+1) ;
    error(:,t+1) = e_x ;
    epsilon_x(:,t+1) = e_x'*((P_p)^-1)*e_x ;

    %NIS Test
    S = Ht*P_m*Ht'+R ;
    epsilon_y(t+1) = e_y'*(S^-1)*e_y ;
end
end

