function [deltax_p_capt, sigma,x_est,epsilon_x,epsilon_y,innovation,error] = LKF(perturb_x0,Q,R,P_p,y_true,y_nom,x_nom,val,x_true)
%LKF Linearized KF algorithm
%   Time update/prediction step for time k+1
[Ft,~,~,Omega] = Jacobians(x_nom(:,1),val) ;
deltax_m = perturb_x0 ;
P_m = P_p;
Qt = Q;
for t = 1:1000
    %Time update/prediction step for time k+1
    deltax_p = Ft * deltax_m;  %No G because no u perturbation %+K*(delta_y-Ht*deltax_m) ;
    P_p = Ft * P_m  * Ft' + Omega * Qt * Omega';
    
    %Mesurement update/correction step for time k+1
    [Ft,~,Ht,Omega] = Jacobians(x_nom(:,t+1), val) ;
    K = P_p * Ht' * ((Ht * P_p * Ht' + R)^-1) ;
    delta_y = y_true(:,t+1)-y_nom(:,t+1); %change to y nom
    deltax_m = deltax_p + K * (delta_y - Ht * deltax_p);
    P_m = (eye(6) - K * Ht) * P_p ;

    % deltax_m = Ft*deltax_p ;      
    % P_m = Ft*P_p*Ft'+Omega*Q*Omega' ;
    
    sigma(:,t) = sqrt(diag(P_m)) ;
    x_est(:,t+1) = x_nom(:,t+1) + deltax_m ;
    deltax_p_capt(:,t+1) = deltax_m ;
    %NEES Test
    e_x = x_true(:,t+1)-x_est(:,t+1) ;
    error(:,t+1) = e_x ;
    epsilon_x(t+1) = e_x' * ((P_m)^-1) * e_x ;

    %NIS Test
    S = Ht*P_p*Ht'+R ;
    e_y = y_true(:,t+1) - Ht * deltax_p ;
    innovation(:,t+1) = e_y ;
    epsilon_y(t+1) = e_y'*(S^(-1))*e_y ;
end

end




