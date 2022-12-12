run Simulation.m
%Set process noise statistics
Q = 10*eye(6) ;
R = eye(5) ;
mu = x_0 ;
P0 = diag([1 1 .01 2 2 .01]) ;


%Simulate multiple ground truth trajectories with process noise
[x_true_capt,y_true_capt] = MonteCarlo(mu,P0,Q,R,perturb_x0,T,u,L) ;

%NEES Test
n = 6 ;
N = 30 ;
alpha = .05 ;
r1_x = chi2inv(alpha/2,N*n)./N ;
r2_x = chi2inv(1-alpha/2,N*n)./N ;

%NIS Test
p = 5 ;
r1_y = chi2inv(alpha/2,N*p)./N ;
r2_y = chi2inv(1-alpha/2,N*p)./N ;


%Apply EKF
P_p = eye(6) ;
for k = 1:length(x_true_capt)
    [x_m,P_m,y_m,e_y,Kt,x_p{k},epsilon_x{k},epsilon_y{k},sigma{k},innovation,error] = EKF(y_true_capt{k},P_p,perturb_x0,val,R,Q,x_true_capt{k}) ;
end

%Analyze NEES Test
E_epsilon_x = mean(cell2mat(epsilon_x')) ;
var_epsilon_x = var(cell2mat(epsilon_x')) ;

%Analyze NIS Test
E_epsilon_y = mean(cell2mat(epsilon_y')) ;
var_epsilon_y = var(cell2mat(epsilon_y')) ;

%Plot KF Results
x_p = x_p{30} ;
x_true = x_true_capt{30} ;
figure(7)
sgtitle('Extended Kalman Filter Simulation')
subplot(6,1,1)
plot(tn, x_p(1,:))
hold on
plot(tn,x_true(1,:))
hold off

subplot(6,1,2)
plot(tn, x_p(2,:))
hold on
plot(tn,x_true(2,:))
hold off

subplot(6,1,3)
plot(tn, wrapToPi(x_p(3,:)))
hold on
plot(tn,wrapToPi(x_true(3,:)))
hold off

subplot(6,1,4)
plot(tn, x_p(4,:))
hold on
plot(tn,x_true(4,:))
hold off

subplot(6,1,5)
plot(tn, x_p(5,:))
hold on
plot(tn,x_true(5,:))
hold off

subplot(6,1,6)
plot(tn, wrapToPi(x_p(6,:)))
hold on
plot(tn,wrapToPi(x_true(6,:)))
hold off

%Plot NEES Test results
figure(8)
sgtitle('NEES Estimation Results')
scatter(tn, E_epsilon_x)
hold on
yline(r1_x)
yline(r2_x)
xlabel('Time Step, k (s)')
ylabel('NEES statistic, \epsilon_x')
% axis([0 20 -100 5000])

%Plot NEES Test results
figure(9)
sgtitle('NIS Estimation Results')
scatter(tn, E_epsilon_y)
hold on
yline(r1_y)
yline(r2_y)
xlabel('Time Step, k (s)')
ylabel('NIS statistic, \epsilon_y')
% axis([0 20 -100 5000])

%Plot innovations vs. time
figure(11)
sig2 = 2*sqrt(sigma{30}) ;
plot(tn,innovation,'k')
hold on
plot(tn,sig2,'r--') ;
hold off


%Plot State Errors vs. time
figure(12)
plot(tn,error(1,:))
hold on
plot(tn,error(2,:))
hold on
plot(tn,error(3,:))
hold on
plot(tn,error(4,:))
hold on
plot(tn,error(5,:))
hold on
plot(tn,error(6,:))
hold on
plot(tn,sig2(1,:),'b--') ;
legend('1','2','3','4','5','6')
hold off


 %% True Data Filter

 [x_m,P_m,y_m,e_y,Kt,x_p,epsilon_x,epsilon_y,sigma,innovation,error] = EKF(ydata,P_p,perturb_x0,val,R,Q,x_true_capt{1}) ;







