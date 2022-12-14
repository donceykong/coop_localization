run Simulation.m

% u = [vg_nom;
%      phi_g_nom;
%      va_nom;
%      wa_nom];
% perturb_x0 = [0; 1; 0; 0; 0; 0.1];
% [~, x_p] = ode45(@(t,x) NL_ODE(t, x, u_nom, L, zeros(6, 1)), tvec, x_0);

LKF_P0 = diag([0.1 0.1 1 1 1 0.1]);
LKF_Q = diag([10 10 1 10 10 0.01]) * 50;
LKF_R = diag([10 10 10 1 10]) * 1000;

EKF_Q = diag([1 1 0.1 1 1 .01]) ;
EKF_P0 = diag([1 1 0.1 1 1 .01]);
R =  diag([20 20 10 1 10]) * 10 ;

[LKF_deltax, LKF_sigma, LKF_x_est, LKF_epsilon_x, LKF_epsilon_y, LKF_innovation, LKF_error] =LKF( ...
    perturb_x0 + [2;2;0;0;0;0], LKF_Q, LKF_R, LKF_P0, ydata, y_nom, x_nom, val, zeros(6, 1001)) ;

[EKF_x_est, EKF_y, EKF_ey, EKF_epsilon_x, EKF_epsilon_y, EKF_sigma, EKF_innovation, EKF_error] =EKF( ...
    ydata, x_0 + [0;-0.5;-1;0;0;0], EKF_P0, val, R, EKF_Q, u_nom, zeros(6, 1001)) ;

T = tvec(2:1001);
LKF_x1 = LKF_x_est(1, 2:1001);
LKF_x2 = LKF_x_est(2, 2:1001);
LKF_x3 = LKF_x_est(3, 2:1001);
LKF_x4 = LKF_x_est(4, 2:1001);
LKF_x5 = LKF_x_est(5, 2:1001);
LKF_x6 = LKF_x_est(6, 2:1001);
EKF_x1 = EKF_x_est(1, 2:1001);
EKF_x2 = EKF_x_est(2, 2:1001);
EKF_x3 = EKF_x_est(3, 2:1001);
EKF_x4 = EKF_x_est(4, 2:1001);
EKF_x5 = EKF_x_est(5, 2:1001);
EKF_x6 = EKF_x_est(6, 2:1001);

figure
subplot(6,1,1)
plot(T, LKF_x1, 'red', T, LKF_x1 + 2*LKF_sigma(1,:), 'blue', T, LKF_x1 - 2*LKF_sigma(1,:), 'blue')
xlabel('time step k')
ylabel('\xi_g, m')
title('LKF Estimates with 2\sigma bounds')

subplot(6,1,2)
title('x2')
plot(T, LKF_x2, 'red', T, LKF_x2 + 2*LKF_sigma(2,:), 'blue', T, LKF_x2 - 2*LKF_sigma(2,:), 'blue')
xlabel('time step k')
ylabel('\eta_g, m')

subplot(6,1,3)
title('x2')
plot(T, LKF_x3, 'red', T, LKF_x3 + 2*LKF_sigma(3,:), 'blue', T, LKF_x3 - 2*LKF_sigma(3,:), 'blue')
xlabel('time step k')
ylabel('\theta_g, rad')

subplot(6,1,4)
title('x2')
plot(T, LKF_x4, 'red', T, LKF_x4 + 2*LKF_sigma(4,:), 'blue', T, LKF_x4 - 2*LKF_sigma(4,:), 'blue')
xlabel('time step k')
ylabel('\xi_a, m')

subplot(6,1,5)
title('x2')
plot(T, LKF_x5, 'red', T, LKF_x5 + 2*LKF_sigma(5,:), 'blue', T, LKF_x5 - 2*LKF_sigma(5,:), 'blue')
xlabel('time step k')
ylabel('\eta_a, m')

subplot(6,1,6)
title('x2')
plot(T, LKF_x6, 'red', T, LKF_x6 + 2*LKF_sigma(6,:), 'blue', T, LKF_x6 - 2*LKF_sigma(6,:), 'blue')
xlabel('time step k')
ylabel('\theta_a, m')

figure
subplot(6,1,1)
plot(T, EKF_x1, 'red', T, EKF_x1 + 2*EKF_sigma(1,:), 'blue', T, EKF_x1 - 2*EKF_sigma(1,:), 'blue')
title('EKF Estimates with 2\sigma bounds')
xlabel('time step k')
ylabel('\xi_g, m')

subplot(6,1,2)
plot(T, EKF_x2, 'red', T, EKF_x2 + 2*EKF_sigma(2,:), 'blue', T, EKF_x2 - 2*EKF_sigma(2,:), 'blue')
xlabel('time step k')
ylabel('\eta_g, m')

subplot(6,1,3)
plot(T, EKF_x3, 'red', T, EKF_x3 + 2*EKF_sigma(3,:), 'blue', T, EKF_x3 - 2*EKF_sigma(3,:), 'blue')
xlabel('time step k')
ylabel('\theta_g, rad')

subplot(6,1,4)
plot(T, EKF_x4, 'red', T, EKF_x4 + 2*EKF_sigma(4,:), 'blue', T, EKF_x4 - 2*EKF_sigma(4,:), 'blue')
xlabel('time step k')
ylabel('\xi_a, m')

subplot(6,1,5)
plot(T, EKF_x5, 'red', T, EKF_x5 + 2*EKF_sigma(5,:), 'blue', T, EKF_x5 - 2*EKF_sigma(5,:), 'blue')
xlabel('time step k')
ylabel('\eta_a, m')

subplot(6,1,6)
plot(T, EKF_x6, 'red', T, EKF_x6 + 2*EKF_sigma(6,:), 'blue', T, EKF_x6 - 2*EKF_sigma(6,:), 'blue')
xlabel('time step k')
ylabel('\theta_a, m')

% subplot(2,2,2)
% title('EKF Estimation')
