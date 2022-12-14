clear
clc
close all, format compact
rng(100)

run Simulation.m

%Set process noise statistics
P0 = diag([0.1 0.1 1 1 1 0.1]);
Q = diag([10 10 1 10 10 0.01]) * 50 ;
R = diag([10 10 10 1 10]) * 1000;
mu = x_0 ;
x0_guess = perturb_x0 + [2;2;0;0;0;0];
N=10;
% Monte Carlo will prove std dis of vals
[x_true_capt,y_true_capt] = MonteCarlo(mu,P0,Qtrue,Rtrue,perturb_x0,tvec,u_nom,L,N) ;

%NEES Test
n = 6 ;
% N = 30 ;
alpha = .01 ;
r1_x = chi2inv(alpha/2,N*n)./N ;
r2_x = chi2inv(1-alpha/2,N*n)./N ;

%NIS Test
p = 5 ;
r1_y = chi2inv(alpha/2,N*p)./N ;
r2_y = chi2inv(1-alpha/2,N*p)./N ;


%Apply LKF
%perturb_x0,Q,R,P_p,y_true,y_nom,x_nom,val,x_true
for k = 1:length(x_true_capt)
[deltax_p_capt{k}, sigma{k},x_est{k},epsilon_x{k},epsilon_y{k},innovation,error] = LKF(x0_guess,Q,R,P0,...
    y_true_capt{k},y_nom,x_nom,val,x_true_capt{k}) ;
end

%Analyze NEES Test
E_epsilon_x = mean(cell2mat(epsilon_x')) ;
var_epsilon_x = var(cell2mat(epsilon_x')) ;

%Analyze NIS Test
E_epsilon_y = mean(cell2mat(epsilon_y')) ;
var_epsilon_y = var(cell2mat(epsilon_y')) ;

x_estimate = x_est{N}(:,2:1001) ;
x_truth = x_true_capt{N}(:,2:1001) ;
y_sim = y_true_capt{N};
T = tvec(2:1001);
%Plot KF Results
figure(5)
sgtitle('Linear Kalman Filter Simulation')
subplot(6,1,1)
plot(T, x_estimate(1,:))
hold on
plot(T, x_truth(1,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\xi_g, m')

subplot(6,1,2)
plot(T, x_estimate(2,:))
hold on
plot(T, x_truth(2,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\eta_g, m')

subplot(6,1,3)
plot(T, wrapToPi(x_estimate(3,:)))
hold on
plot(T, wrapToPi(x_truth(3,:)))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\theta_g, rad')

subplot(6,1,4)
plot(T, x_estimate(4,:))
hold on
plot(T, x_truth(4,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\xi_a, m')

subplot(6,1,5)
plot(T, x_estimate(5,:))
hold on
plot(T, x_truth(5,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\eta_a, m')

subplot(6,1,6)
plot(T, wrapToPi(x_estimate(6,:)))
hold on
plot(T, wrapToPi(x_truth(6,:)))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\theta_a, rad')

figure
sgtitle('EKF Simulated Measurements')
subplot(5,1,1)
plot(tn, y_sim(1,:))
xlabel('time step k')
ylabel('y_1, rad')

subplot(5,1,2)
plot(tn, y_sim(2,:))
xlabel('time step k')
ylabel('y_2, m')

subplot(5,1,3)
plot(tn, y_sim(3,:))
xlabel('time step k')
ylabel('y_3, rad')

subplot(5,1,4)
plot(tn, y_sim(4,:))
xlabel('time step k')
ylabel('y_4, m')

subplot(5,1,5)
plot(tn, y_sim(5,:))
xlabel('time step k')
ylabel('y_5, m')

%Plot NEES Test results
figure(6)
sgtitle('NEES Estimation Results')
scatter(tn, E_epsilon_x,'.')
hold on
yline(r1_x)
yline(r2_x)
xlabel('Time Step, k (s)')
ylabel('NEES statistic, \epsilon_x')
% axis([0 20 -100 5000])

%Plot NEES Test results
figure(7)
sgtitle('NIS Estimation Results')
scatter(tn, E_epsilon_y)
hold on
yline(r1_y)
yline(r2_y)
xlabel('Time Step, k (s)')
ylabel('NIS statistic, \epsilon_y')
% axis([0 20 -100 5000])

%Plot innovations vs. time
% figure(8)
sig2 = 2*sigma{N};

% plot(tn,innovation,'k')
% hold on
% plot(tn,sig2,'r--') ;
% hold off


%Plot State Errors vs. time
figure(9)
subplot(6,1,1)
plot(T,error(1,:))
hold on
plot(T,sig2(1,:),'r--') ;
plot(T,-sig2(1,:),'r--') ;
xlabel('time step k')
ylabel('e_{\xi_g}, m')

subplot(6,1,2)
plot(T,error(2,:))
hold on
plot(T,sig2(2,:),'r--') ;
plot(T,-sig2(2,:),'r--') ;
xlabel('time step k')
ylabel('e_{\eta_g}, m')

subplot(6,1,3)
plot(T,error(3,:))
hold on
plot(T,sig2(3,:),'r--') ;
plot(T,-sig2(3,:),'r--') ;
xlabel('time step k')
ylabel('e_{\theta_g}, rad')

subplot(6,1,4)
plot(T,error(4,:))
hold on
plot(T,sig2(4,:),'r--') ;
plot(T,-sig2(4,:),'r--') ;
xlabel('time step k')
ylabel('e_{\xi_a}, m')

subplot(6,1,5)
plot(T,error(5,:))
hold on
plot(T,sig2(5,:),'r--') ;
plot(T,-sig2(5,:),'r--') ;
xlabel('time step k')
ylabel('e_{\eta_a}, m')

subplot(6,1,6)
plot(T,error(6,:))
hold on
plot(T,sig2(6,:),'r--') ;
plot(T,-sig2(6,:),'r--') ;
xlabel('time step k')
ylabel('e_{\theta_a}, rad')



%% True State Trajectory

%[deltax_p_capt, sigma,x_est,epsilon_x,epsilon_y,innovation,error] = LKF(perturb_x0,Q,R,P0,ydata,y_nom,x_nom,val,x_true_capt{30}) ;
% 
% figure(10)
% plot(tn,ydata(1,:),'kx')


