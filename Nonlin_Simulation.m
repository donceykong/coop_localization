%% Nonlinear System Simulation

% Load needed givens
% Could save as '.mat' and use load(), but want to continually edit
% and make sure everything is well commented
run Project_Parameters.m;

% Initial State Vector
T = 0:dt:100;
x_0 = [eta_g_nom;
       zeta_g_nom;
       theta_g_nom;
       eta_a_nom;
       zeta_a_nom;
       theta_a_nom];

perturb_x0 = [0; 1; 0; 0; 0; 0.1];

u = [vg_nom;
     phi_g_nom;
     va_nom;
     wa_nom];
w = zeros(6,1) ;

% Get total state vector vs time from NL ODE using ode45
% [tn, x_total_ode45] = ode45(@(t,x) NL_ODE(t,x,k), T, X0 + dX0);
[tn, x_total_ode45] = ode45(@(t,x) NL_ODE(t, x, u, L, w), T, x_0 + perturb_x0);

x = x_total_ode45';

% Plot all the states
figure(1)
sgtitle('States vs. Time, Full Nonlinear Dynamics Simulation')
subplot(6,1,1)
plot(tn, x(1,:))
xlabel('Time (s)')
ylabel('\zeta_g (m)')

subplot(6,1,2)
plot(tn, x(2,:))
xlabel('Time (s)')
ylabel('\eta_g (m)')

subplot(6,1,3)
plot(tn, wrapToPi(x(3,:)))
xlabel('Time (s)')
ylabel('\theta_g (rad)')

subplot(6,1,4)
plot(tn, x(4,:))
xlabel('Time (s)')
ylabel('\zeta_a (m)')

subplot(6,1,5)
plot(tn, x(5,:))
xlabel('Time (s)')
ylabel('\eta_a (m)')

subplot(6,1,6)
plot(tn, wrapToPi(x(6,:)))
xlabel('Time (s)')
ylabel('\theta_a (rad)')


%% MAKE FUNCTION using x_sim as input
v = zeros(5,1) ;
[y_nom] = Nonlin_Meas(x,v) ;

% Plot all the measurements
figure(2)
sgtitle('Full Nonlinear Model Data Simulation')
subplot(5,1,1)
plot (tn, wrapToPi(y_nom(1, :)))
xlabel('Time (s)')
ylabel('\gamma_{ag} (rad)')

subplot(5,1,2)
plot (tn, y_nom(2, :))
xlabel('Time (s)')
ylabel('\rho_{ga} (m)')

subplot(5,1,3)
plot (tn, wrapToPi(y_nom(3, :)))
xlabel('Time (s)')
ylabel('\gamma_{ga} (rad)')

subplot(5,1,4)
plot (tn, y_nom(4, :))
xlabel('Time (s)')
ylabel('\zeta_a (m)')

subplot(5,1,5)
plot (tn, y_nom(5, :))
xlabel('Time (s)')
ylabel('\eta_a (m)')