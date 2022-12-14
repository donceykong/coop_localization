function [x_est,y_m,e_y,epsilon_x,epsilon_y,sigma,innovation,error] = EKF( ...
    y_true, x0, P0, val, R, Q, u, x_true)
%EKF Summary of this function goes here
%   Detailed explanation goes here
P_m = P0;
x_est = zeros(6, 1001);
x_est(:, 1) = x0;
% [Ft,~,Ht,Omega] = Jacobians(x_true(:,1),val) ;
for t = 1:1000
    [Ft,~,~,Omega] = Jacobians(x_est(:, t), val) ;
    [~, x_p] = ode45(@(t,x) NL_ODE(t, x, u, val(3), zeros(6, 6)), [0.1*(t-1) 0.1*t 0.1*(t+1)], x_est(:, t)) ;
    x_p;
    size(x_p);
    % NL_ODE(t, x, u, val(3), zeros(6, 1))
    x_p = x_p(2, :);
    % x_p = transpose(x_p(t, :))
    P_p = Ft * P_m * Ft'+ +Omega*Q*Omega';
    % x_m(:,t+1) = x_true(:,t) ;
    % P_m = Ft*P_p*Ft'+Omega*Q*Omega' ;

    % [Ft,~,Ht,Omega] = Jacobians(x_m(:,t+1),val) ;
    ht = h(x_p);
    x_p = x_p';
    y_m(:,t) = ht;
    % x_p = x_p(:, t);
    [~,~,Ht,~] = Jacobians(x_p, val) ;
    e_y = y_true(:,t+1) - y_m(:,t) ;
    innovation(:,t) = e_y;
    Kt = P_p * Ht' * (Ht * P_p * Ht' + R)^-1 ;
    x_est(:, t+1) = x_p + Kt * e_y;
    P_m = (eye(6)-Kt*Ht)*P_p ;
    sigma(:,t) = sqrt(diag(P_m)) ;

    %NEES Test
    e_x = x_true(:,t+1)-x_est(:,t+1) ;
    error(:,t) = e_x ;
    epsilon_x(:,t) = e_x'*((P_m)^-1)*e_x ;

    %NIS Test
    S = Ht*P_p*Ht'+R ;
    epsilon_y(t+1) = e_y'*(S^-1)*e_y ;
end
end

