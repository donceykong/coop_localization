%% Linearized DT Simulation

% Load needed givens (from Project_Parameters.m)
load("data/parameters.mat")

% Nonlinear nom w/o perturbations
[t, x_base] = ode45(@(t,x) NL_ODE(t, x, u, L, w*0), T, x_0) ;
x_nom = x_base' ;   %x_nom = NO NOISE
[y_nom] = Nonlin_Meas(x_nom, zeros(5, 5)) ;

%Linearized Dynamics nomulation
xd = perturb_x0 ;
xf = x_nom(:,1)+perturb_x0 ;
[Ft,Gt,Ht,Omega] = Jacobians(x_nom(:,1),val) ;

for t = 1:1000
    xd(:,t+1) = Ft*xd(:,t) ;
    [Ft,Gt,Ht,Omega] = Jacobians(x_nom(:,t),val) ;
    xf(:,t+1) = xd(:,t+1)+x_nom(:,t+1) ;
end

% If want to plot outputs

% Plot all the states
figure(3)
sgtitle('States vs. Time, Linearized Approx. Dynamics nomulation')
subplot(6,1,1)
plot(tn, xf(1,:))
xlabel('Time (s)')
ylabel('\zeta_g (m)')

subplot(6,1,2)
plot(tn, xf(2,:))
xlabel('Time (s)')
ylabel('\eta_g (m)')

subplot(6,1,3)
plot(tn, wrapToPi(xf(3,:)))
xlabel('Time (s)')
ylabel('\theta_g (rad)')

subplot(6,1,4)
plot(tn, xf(4,:))
xlabel('Time (s)')
ylabel('\zeta_a (m)')

subplot(6,1,5)
plot(tn, xf(5,:))
xlabel('Time (s)')
ylabel('\eta_a (m)')

subplot(6,1,6)
plot(tn, wrapToPi(xf(6,:)))
xlabel('Time (s)')
ylabel('\theta_a (rad)')

%Plot perturbations

figure(4)
sgtitle('Linearized Approx. Perturbations vs. Time')
subplot(6,1,1)
plot(tn, xd(1,:))
xlabel('Time (s)')
ylabel('\zeta_g (m)')

subplot(6,1,2)
plot(tn, xd(2,:))
xlabel('Time (s)')
ylabel('\eta_g (m)')

subplot(6,1,3)
plot(tn, wrapToPi(xd(3,:)))
xlabel('Time (s)')
ylabel('\theta_g (rad)')

subplot(6,1,4)
plot(tn, xd(4,:))
xlabel('Time (s)')
ylabel('\zeta_a (m)')

subplot(6,1,5)
plot(tn, xd(5,:))
xlabel('Time (s)')
ylabel('\eta_a (m)')

subplot(6,1,6)
plot(tn, wrapToPi(xd(6,:)))
xlabel('Time (s)')
ylabel('\theta_a (rad)')