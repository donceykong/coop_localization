
run Simulation.m

%Set process noise statistics
P0 = diag([.001 .001 deg2rad(1) .001 .001 deg2rad(1)]) ;
Q = diag([100 500 100 100 100 500]) ;
R = eye(5) ;
mu = x_0 ;


% Monte Carlo will prove std dis of vals
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


%Apply LKF
%perturb_x0,Q,R,P_p,y_true,y_nom,x_nom,val,x_true
for k = 1:length(x_true_capt)
[deltax_p_capt{k}, sigma{k},x_est{k},epsilon_x{k},epsilon_y{k},innovation,error] = LKF(perturb_x0,Q,R,P0,...
    y_true_capt{k},y_nom,x_nom,val,x_true_capt{k}) ;
end

%Analyze NEES Test
E_epsilon_x = mean(cell2mat(epsilon_x')) ;
var_epsilon_x = var(cell2mat(epsilon_x')) ;

%Analyze NIS Test
E_epsilon_y = mean(cell2mat(epsilon_y')) ;
var_epsilon_y = var(cell2mat(epsilon_y')) ;

x_estimate = x_est{1} ;
x_truth = x_true_capt{30} ;
%Plot KF Results
figure(5)
sgtitle('Linear Kalman Filter Simulation')
subplot(6,1,1)
plot(T, x_estimate(1,:))
hold on
plot(T, x_truth(1,:))
hold off
legend('estimate','truth')

subplot(6,1,2)
plot(T, x_estimate(2,:))
hold on
plot(T, x_truth(2,:))
hold off

subplot(6,1,3)
plot(T, wrapToPi(x_estimate(3,:)))
hold on
plot(T, wrapToPi(x_truth(3,:)))
hold off

subplot(6,1,4)
plot(T, x_estimate(4,:))
hold on
plot(T, x_truth(4,:))
hold off

subplot(6,1,5)
plot(T, x_estimate(5,:))
hold on
plot(T, x_truth(5,:))
hold off

subplot(6,1,6)
plot(T, wrapToPi(x_estimate(6,:)))
hold on
plot(T, wrapToPi(x_truth(6,:)))
hold off

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
figure(8)
sig2_p = 2*sqrt(sigma{30})+x_estimate ;
sig2_m = -2*sqrt(sigma{30})+x_estimate ;

% plot(tn,innovation,'k')
% hold on
% plot(tn,sig2,'r--') ;
% hold off


%Plot State Errors vs. time
figure(9)
subplot(6,1,1)
plot(tn,error(1,:))
hold on
plot(tn,sig2_p(1,:),'r--') ;
plot(tn,sig2_m(1,:),'b--') ;

subplot(6,1,2)
plot(tn,error(2,:))
hold on
plot(tn,sig2_p(2,:),'r--') ;
plot(tn,sig2_m(2,:),'r--') ;

subplot(6,1,3)
plot(tn,error(3,:))
hold on
plot(tn,sig2_p(3,:),'r--') ;
plot(tn,sig2_m(3,:),'r--') ;

subplot(6,1,4)
plot(tn,error(4,:))
hold on
plot(tn,sig2_p(4,:),'r--') ;
plot(tn,sig2_m(4,:),'r--') ;

subplot(6,1,5)
plot(tn,error(5,:))
hold on
plot(tn,sig2_p(5,:),'r--') ;
plot(tn,sig2_m(5,:),'r--') ;

subplot(6,1,6)
plot(tn,error(6,:))
hold on
plot(tn,sig2_p(6,:),'r--') ;
plot(tn,sig2_m(6,:),'r--') ;



%% True State Trajectory

[deltax_p_capt, sigma,x_est,epsilon_x,epsilon_y,innovation,error] = LKF(perturb_x0,Q,R,P0,ydata,y_nom,x_nom,val,x_true_capt{30}) ;

figure(10)
plot(tn,ydata(1,:),'kx')


