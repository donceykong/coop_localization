run Nonlin_Simulation.m
% Nonlinear Sim w/o perturbations
[t, x_base] = ode45(@(t,x) NL_ODE(t, x, u, L), T, x_0);
x_sim = x_base';

%Linearized Dynamics Simulation
xd = perturb_x0 ;
xf = x_sim(:,1)+perturb_x0 ;
[Ft,Gt,Ht,Omega_t] = Jacobians(x_sim(:,1),val) ;

for t = 1:1000
    xd(:,t+1) = Ft*xd(:,t) ;
    [Ft,Gt,Ht,Omega_t] = Jacobians(x_sim(:,t),val) ;
    xf(:,t+1) = xd(:,t+1)+x_sim(:,t+1) ;
end


% Plot all the states
figure(3)
subplot(6,1,1)
plot(tn, xf(1,:))

subplot(6,1,2)
plot(tn, xf(2,:))

subplot(6,1,3)
plot(tn, wrapToPi(xf(3,:)))

subplot(6,1,4)
plot(tn, xf(4,:))

subplot(6,1,5)
plot(tn, xf(5,:))

subplot(6,1,6)
plot(tn, wrapToPi(xf(6,:)))

%Plot perturbations

figure(4)
subplot(6,1,1)
plot(tn, xd(1,:))

subplot(6,1,2)
plot(tn, xd(2,:))

subplot(6,1,3)
plot(tn, wrapToPi(xd(3,:)))

subplot(6,1,4)
plot(tn, xd(4,:))

subplot(6,1,5)
plot(tn, xd(5,:))

subplot(6,1,6)
plot(tn, wrapToPi(xd(6,:)))
