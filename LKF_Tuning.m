run Simulation.m
%Set process noise statistics
qk = randn(5,1001) ;
P0 = diag([.001 .001 deg2rad(1) .001 .001 deg2rad(1)]) ;
Q = 10*Qtrue ;
R = Rtrue ;
mu = x_0 ;
w = zeros(6,1) ;
w1 = chol(Q,'lower') ;
v = zeros(5,1) ;
v1 = chol(R,'lower') ;

% Monte Carlo will prove std dis of vals
[x_true_capt,y_true_capt] = MonteCarlo(mu,P0,perturb_x0,T,u,L,w1,v1) ;

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
[deltax_p_capt{k}, sigma{k},x_est{k},epsilon_x{k},epsilon_y{k}] = LKF(perturb_x0,Q,R,P0,...
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