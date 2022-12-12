run Simulation.m
%Set process noise statistics
qk = randn(5,1001) ;
Sv = chol(Rtrue,'lower') ;
Q = eye(6) ;
mu = x_0 ;
P0 = diag([1 1 .01 2 2 .01]) ;
delta_x = x_sim(:,1)-x_0 ;
w = mvnrnd(zeros(6,1),Q) ;
v = mvnrnd(zeros(5,1),Rtrue) ;

%Simulate multiple ground truth trajectories with process noise
% Nonlinear Sim w/o perturbations
[t, x_base] = ode45(@(t,x) NL_ODE(t, x, u, L, w), T, x_0) ;
x_nom= x_base' ;
[y_nom] = Nonlin_Meas(x_sim,v) ;

% Monte Carlo will prove std dis of vals
for k = 1:30
    xinit1 = mvnrnd(mu,P0) ;
    [t, x_sim1] = ode45(@(t,x) NL_ODE(t, x, u, L,w), T, xinit1) ;
    y_sim1 = y_nom+Sv*qk ;
    xcapt{k} = x_sim1 ;
    ycapt{k} = y_sim1 ;
end
% x_sim1 = xcapt{1} ;

%NEES Test
n = 6 ;
N = 1000 ;
alpha = .05 ;
r1_x = chi2inv(alpha/2,N*n)./N ;
r2_x = chi2inv(1-alpha/2,N*n)./N ;

%NIS Test
p = 5 ;
r1_y = chi2inv(alpha/2,N*p)./N ;
r2_y = chi2inv(1-alpha/2,N*p)./N ;


%Apply EKF
P_p = eye(6) ;
[x_m,P_m,y_m,e_y,Kt,x_p,epsilon_x,epsilon_y] = EKF(y_nom,P_p,val,Rtrue,Qtrue,xf) ;

%Analyze NEES Test
E_epsilon_x = mean(epsilon_x) ;
var_epsilon_x = var(epsilon_x) ;

%Analyze NIS Test
E_epsilon_y = mean(epsilon_y) ;
var_epsilon_y = var(epsilon_y) ;

%Plot KF Results
figure(7)
sgtitle('Extended Kalman Filter Simulation')
subplot(6,1,1)
plot(t, x_p(1,:))

subplot(6,1,2)
plot(t, x_p(2,:))

subplot(6,1,3)
plot(t, wrapToPi(x_p(3,:)))

subplot(6,1,4)
plot(t, x_p(4,:))

subplot(6,1,5)
plot(t, x_p(5,:))

subplot(6,1,6)
plot(t, wrapToPi(x_p(6,:)))

%Plot NEES Test results
figure(8)
sgtitle('NEES Estimation Results')
scatter(tn, epsilon_x)
hold on
yline(r1_x)
yline(r2_x)
xlabel('Time Step, k (s)')
ylabel('NEES statistic, \epsilon_x')
% axis([0 20 -100 5000])

%Plot NEES Test results
figure(9)
sgtitle('NIS Estimation Results')
scatter(tn, epsilon_y)
hold on
yline(r1_y)
yline(r2_y)
xlabel('Time Step, k (s)')
ylabel('NIS statistic, \epsilon_y')
% axis([0 20 -100 5000])