%% Nonlinear System Simulation

% Load needed givens
% Could save as '.mat' and use load(), but want to continually edit
% and make sure everything is well commented
run Project_Parameters.m;

% Initial State Vector
T = 0:delta_t:100;
x_0 = [eta_g_nom;
       zeta_g_nom;
       theta_g_nom;
       eta_a_nom;
       zeta_a_nom;
       theta_a_nom];

perturb_x0 = [0; 1; 0; 0; 0; 0.1];

u = [v_g;
     phi_g;
     v_a;
     omega_a];

% Get total state vector vs time from NL ODE using ode45
% [tn, x_total_ode45] = ode45(@(t,x) NL_ODE(t,x,k), T, X0 + dX0);
[tn, x_total_ode45] = ode45(@(t,x) NL_ODE(t, x, u, L), T, x_0 + perturb_x0);

x = x_total_ode45';

% Plot all the states
figure(1)
subplot(6,1,1)
plot(tn, x(1,:))

subplot(6,1,2)
plot(tn, x(2,:))

subplot(6,1,3)
plot(tn, wrapToPi(x(3,:)))

subplot(6,1,4)
plot(tn, x(4,:))

subplot(6,1,5)
plot(tn, x(5,:))

subplot(6,1,6)
plot(tn, wrapToPi(x(6,:)))

% Calculate all Meaurements
y = zeros(6,1001);

column = 1;
for time = delta_t:delta_t:100
    y(1, column) = atan2(x(5, column) - x(2, column), x(4, column) - x(1, column)) - x(3, column);
    y(2, column) = sqrt((x(1, column) - x(4, column))^2 + (x(2, column) - x(5, column))^2);
    y(3, column) = atan2(x(2, column) - x(5, column), x(1, column) - x(4, column)) - x(6, column);
    y(4, column) = x(4, column);
    y(5, column) = x(5, column);

    column = column + 1;
end

% Plot all the measurements
figure
subplot(5,1,1)
plot (tn, wrapToPi(y(1, :)))

subplot(5,1,2)
plot (tn, y(2, :))

subplot(5,1,3)
plot (tn, wrapToPi(y(3, :)))

subplot(5,1,4)
plot (tn, y(4, :))

subplot(5,1,5)
plot (tn, y(5, :))