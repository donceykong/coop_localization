function [deltax_m, P_m, delta_y, K, deltax_p, P_p,x_lkf,epsilon_x,epsilon_y] = LKF(Q,R,deltax_p,P,y_act,y_pred,x_sim,val,x)
%LKF Linearized KF algorithm
%   Time update/prediction step for time k+1
[Ft,Gt,Ht,Omega] = Jacobians(x_sim(:,1),val) ;

for t = 1:1000
    deltax_m = Ft*deltax_p ;       %No G because no u perturbation
    P_m = Ft*P*Ft'+Omega*Q*Omega' ;
    [Ft,Gt,Ht,Omega] = Jacobians(x_sim(:,t+1),val) ;

    %Mesurement update/correction step for time k+1
    delta_y = y_act(:,t+1)-y_pred(:,t+1); %change to y nom
    K = P_m*Ht'*(Ht*P_m*Ht'+R)^-1 ;
    deltax_p = deltax_m+K*(delta_y-Ht*deltax_m) ;
    P_p = (eye(6)-K*Ht)*P_m ;
    x_lkf(:,t+1) = x_sim(:,t+1)+deltax_p ;
    
    %NEES Test
    e_x = x(:,t+1)-x_lkf(:,t+1) ;
    epsilon_x(t+1) = e_x'*(P_p)^-1*e_x ;

    %NIS Test
    S = Ht*P_m*Ht'+R ;
    e_y = delta_y-Ht*deltax_m ;
    epsilon_y(t+1) = e_y'*S^-1*e_y ;
end

end




