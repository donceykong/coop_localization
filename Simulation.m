run Nonlin_Simulation.m
% Nonlinear Sim w/o perturbations
[t, x_base] = ode45(@(t,x) NL_ODE(t, x, u, L, w), T, x_0) ;
x_sim = x_base' ;   %x_sim = NO NOISE
[y_sim] = Nonlin_Meas(x_sim,v) ;

%Linearized Dynamics Simulation
xd = perturb_x0 ;
xf = x_sim(:,1)+perturb_x0 ;
[Ft,Gt,Ht,Omega] = Jacobians(x_sim(:,1),val) ;

for t = 1:1000
    xd(:,t+1) = Ft*xd(:,t) ;
    [Ft,Gt,Ht,Omega] = Jacobians(x_sim(:,t),val) ;
    xf(:,t+1) = xd(:,t+1)+x_sim(:,t+1) ;
end


% Plot all the states
figure(3)
sgtitle('States vs. Time, Linearized Approx. Dynamics Simulation')
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