function [deltax_p_capt, sigma,x_est,epsilon_x,epsilon_y,innovation,error] = LKF(perturb_x0,Q,R,P_p,y_true,y_nom,x_nom,val,x_true)
%LKF Linearized KF algorithm
%   Time update/prediction step for time k+1
[Ft,~,~,Omega] = Jacobians(x_nom(:,1),val) ;
deltax_p = perturb_x0 ;
for t = 1:1000
    deltax_m = Ft*deltax_p ;       %No G because no u perturbation
    P_m = Ft*P_p*Ft'+Omega*Q*Omega' ;
    [Ft,~,Ht,Omega] = Jacobians(x_nom(:,t+1),val) ;

    %Mesurement update/correction step for time k+1
    delta_y = y_true(:,t+1)-y_nom(:,t+1); %change to y nom
    K = P_m*Ht'*((Ht*P_m*Ht'+R)^-1) ;
    deltax_p = deltax_m+K*(delta_y-Ht*deltax_m) ;
    P_p = (eye(6)-K*Ht)*P_m ;
    sigma(:,t+1) = diag(P_p) ;
    x_est(:,t+1) = x_nom(:,t+1)+deltax_p ;
    deltax_p_capt(:,t+1) = deltax_p ;
    %NEES Test
    e_x = x_true(:,t+1)-x_est(:,t+1) ;
    error(:,t+1) = e_x ;
    epsilon_x(t+1) = e_x'*((P_p)^-1)*e_x ;

    %NIS Test
    S = Ht*P_m*Ht'+R ;
    e_y = y_true(:,t+1)-Ht*deltax_m ;
    innovation(:,t+1) = e_y ;
    epsilon_y(t+1) = e_y'*(S^(-1))*e_y ;
end

end




