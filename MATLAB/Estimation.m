clear
clc
close all, format compact
rng(100) 
load("data/parameters.mat")
x_0 = [eta_g_nom;
       zeta_g_nom;
       theta_g_nom;
       eta_a_nom;
       zeta_a_nom;
       theta_a_nom];
% u = [vg_nom;
%      phi_g_nom;
%      va_nom;
%      wa_nom];
% perturb_x0 = [0; 1; 0; 0; 0; 0.1];
% [~, x_p] = ode45(@(t,x) NL_ODE(t, x, u_nom, L, zeros(6, 1)), tvec, x_0);

LKF_P0 = eye(6,6) * 10; % # diag([.001 .001 deg2rad(1) .001 .001 deg2rad(1)]);
LKF_Q = diag([10 10 100 10 10 100]) * 100;
EKF_Q = 10*eye(6) ;
EKF_P0 = diag([1 1 .01 2 2 .01]) ;
R = eye(5) ;
% mu = x_0 ;

[LKF_deltax, LKF_sigma, LKF_x_est, LKF_epsilon_x, LKF_epsilon_y, LKF_innovation, LKF_error] =LKF( ...
    perturb_x0, LKF_Q, R, LKF_P0, ydata, y_nom, x_nom, val, zeros(6, 1001)) ;

[EKF_x_est, EKF_y, EKF_ey, EKF_epsilon_x, EKF_epsilon_y, EKF_sigma, EKF_innovation, EKF_error] =EKF( ...
    ydata, x_0 + perturb_x0, EKF_P0, val, R, EKF_Q, u_nom, zeros(6, 1001)) ;

figure
subplot(2,2,1)
title('LKF Estimation')
hold on
plot(tvec, LKF_x_est(1, :), tvec, LKF_x_est(1, :) + 2*LKF_sigma(1,:), 'red', tvec, LKF_x_est(1, :) - 2*LKF_sigma(1,:), 'red')
plot(tvec, EKF_x_est(1, :), tvec, EKF_x_est(1, :) + 2*EKF_sigma(1,:), 'green', tvec, EKF_x_est(1, :) - 2*EKF_sigma(1,:), 'green')
hold off