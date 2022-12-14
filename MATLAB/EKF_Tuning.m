% run Simulation.m
%Set process noise statistics
clear
clc
close all, format compact
rng(100) 

load("data/parameters.mat")

Q = diag([1 1 0.1 1 1 .01]) ;
R = diag([20 20 10 1 10]) * 10;
mu = x_0 ;
P0 = diag([1 1 0.1 1 1 .01]) ;
x0_guess = x_0 + [0;-0.5;-1;0;0;0];

N = 20;
%Simulate multiple ground truth trajectories with process noise
[x_true_capt,y_true_capt] = MonteCarlo(mu,P0,Qtrue,Rtrue,perturb_x0,tvec,u_nom,L, N) ;

%NEES Test
n = 6 ;
alpha = .01 ;
r1_x = chi2inv(alpha/2,N*n)./N ;
r2_x = chi2inv(1-alpha/2,N*n)./N ;

%NIS Testx_m
p = 5 ;
r1_y = chi2inv(alpha/2,N*p)./N ;
r2_y = chi2inv(1-alpha/2,N*p)./N ;


%Apply EKF
P_p = eye(6) ;
for k = 1:length(x_true_capt)
    [x_est{k},y_m,e_y,epsilon_x{k},epsilon_y{k},sigma{k},innovation,error] = EKF( ...
        y_true_capt{k}, x0_guess, P0, val, R, Q, u_nom, x_true_capt{k}) ;
end

% figure
% subplot(3, 2, 1)
% plot(1:1000, error(1,:));
% title('error in x1')
% 
% subplot(3, 2, 2)
% plot(1:1000, error(2,:));
% title('error in x2')
% 
% subplot(3, 2, 3)
% plot(1:1000, error(3,:));
% title('error in x3')
% 
% subplot(3, 2, 4)
% plot(1:1000, error(4,:));
% title('error in x4')
% 
% subplot(3, 2, 5)
% plot(1:1000, error(5,:));
% title('error in x5')
% 
% subplot(3, 2, 6)
% plot(1:1000, error(6,:));
% title('error in x6')

%Analyze NEES Test
E_epsilon_x = mean(cell2mat(epsilon_x')) ;
var_epsilon_x = var(cell2mat(epsilon_x')) ;

%Analyze NIS Test
E_epsilon_y = mean(cell2mat(epsilon_y')) ;
var_epsilon_y = var(cell2mat(epsilon_y')) ;

tn = tvec;

%Plot KF Results
x_est = x_est{N} ;
x_true = x_true_capt{N} ;
y_sim = y_true_capt{N};
sig2 = 2*sigma{N};
T = tvec(2: 1001);

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


figure(7)
sgtitle('Extended Kalman Filter Simulation')
subplot(6,1,1)
plot(tn, x_est(1,:))
hold on
plot(tn,x_true(1,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\xi_g, m')

subplot(6,1,2)
plot(tn, x_est(2,:))
hold on
plot(tn,x_true(2,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\eta_g, m')

subplot(6,1,3)
plot(tn, wrapToPi(x_est(3,:)))
hold on
plot(tn,wrapToPi(x_true(3,:)))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\theta_g, rad')

subplot(6,1,4)
plot(tn, x_est(4,:))
hold on
plot(tn,x_true(4,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\xi_a, m')

subplot(6,1,5)
plot(tn, x_est(5,:))
hold on
plot(tn,x_true(5,:))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\eta_a, m')

subplot(6,1,6)
plot(tn, wrapToPi(x_est(6,:)))
hold on
plot(tn,wrapToPi(x_true(6,:)))
hold off
legend('estimated', 'simulated')
xlabel('time step k')
ylabel('\theta_a, rad')

%Plot NEES Test results
figure(8)
sgtitle('NEES Estimation Results')
scatter(tn(1, 2:1001), E_epsilon_x)
hold on
yline(r1_x)
yline(r2_x)
xlabel('Time Step, k (s)')
ylabel('NEES statistic, \epsilon_x')
% axis([0 20 -100 5000])

%Plot NIS Test results
figure(9)
sgtitle('NIS Estimation Results')
scatter(tn, E_epsilon_y)
hold on
yline(r1_y)
yline(r2_y)
xlabel('Time Step, k (s)')
ylabel('NIS statistic, \epsilon_y')
% axis([0 20 -100 5000])

%Plot State Errors vs. time
figure
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

%Plot innovations vs. time
% figure(11)
% sig2 = 2*sqrt(sigma{30}) ;
% plot(tn,innovation,'k')
% hold on
% plot(tn,sig2,'r--') ;
% hold off


%Plot State Errors vs. time
% figure(12)
% plot(tn,error(1,:))
% hold on
% plot(tn,error(2,:))
% hold on
% plot(tn,error(3,:))
% hold on
% plot(tn,error(4,:))
% hold on
% plot(tn,error(5,:))
% hold on
% plot(tn,error(6,:))
% hold on
% plot(tn,sig2(1,:),'b--') ;
% legend('1','2','3','4','5','6')
% hold off


 %% True Data Filter

 % [x_m,P_m,y_m,e_y,Kt,x_est,epsilon_x,epsilon_y,sigma,innovation,error] = EKF(ydata,P_p,perturb_x0,val,R,Q,x_true_capt{1}) ;







