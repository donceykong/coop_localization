%% Linearization of Nonlinear System

% Run to get system parameters
run Project_Parameters.m

% Non-linear Continuous-Time Matrices
A = [0 0 -v_g*sin(theta_g_nom) 0 0 0; 
     0 0  v_g*cos(theta_g_nom) 0 0 0; 
     0 0  0                   0 0 0; 
     0 0  0 0 0 -v_a*sin(theta_a_nom); 
     0 0 0 0 0 v_a*cos(theta_a_nom); 
     0 0 0 0 0 0]; 
B = [cos(theta_g_nom) 0 0 0; 
     sin(theta_g_nom) 0 0 0; 
     1/L*tan(phi_g) v_g/(L*cos(phi_g)^2) 0 0; 
     0 0 cos(theta_a_nom) 0; 
     0 0 sin(theta_a_nom) 0; 
     0 0 0 1];


C = [(zeta_a_nom-zeta_g_nom)/(((zeta_a_nom-zeta_g_nom)^2/(eta_a_nom-eta_g_nom)^2+1)*(eta_a_nom-eta_g_nom)^2) -1/((eta_a_nom-eta_g_nom)*((zeta_a_nom-zeta_g_nom)^2/(eta_a_nom-eta_g_nom)^2+1)) -1 -(zeta_a_nom-zeta_g_nom)/((eta_a_nom-eta_g_nom)^2*((zeta_a_nom-zeta_g_nom)^2/(eta_a_nom-eta_g_nom)^2+1)) 1/((eta_a_nom-eta_g_nom)*((zeta_a_nom-zeta_g_nom)^2/(eta_a_nom-eta_g_nom)^2+1)) 0; (eta_g_nom-eta_a_nom)/sqrt((eta_g_nom-eta_a_nom)^2+(zeta_g_nom-zeta_a_nom)^2) (zeta_g_nom-zeta_a_nom)/sqrt((zeta_g_nom-zeta_a_nom)^2+(eta_g_nom-eta_a_nom)^2) 0 -(eta_g_nom-eta_a_nom)/sqrt((eta_g_nom-eta_a_nom)^2+(zeta_g_nom-zeta_a_nom)^2) -(zeta_g_nom-zeta_a_nom)/sqrt((eta_g_nom-eta_a_nom)^2+(zeta_g_nom-zeta_a_nom)^2) 0; -(zeta_g_nom-zeta_a_nom)/((eta_g_nom-eta_a_nom)^2*((zeta_g_nom-zeta_a_nom)^2/(eta_g_nom-eta_a_nom)^2+1)) 1/((eta_g_nom-eta_a_nom)*((zeta_g_nom-zeta_a_nom)^2/(eta_g_nom-eta_a_nom)^2+1)) 0 (zeta_g_nom-zeta_a_nom)/(((zeta_g_nom-zeta_a_nom)^2/(eta_g_nom-eta_a_nom)^2+1)*(eta_g_nom-eta_a_nom)^2) -1/((eta_g_nom-eta_a_nom)*((zeta_g_nom-zeta_a_nom)^2/(eta_g_nom-eta_a_nom)^2+1)) 0; 0 0 0 1 0 0; 0 0 0 0 1 0];
Ah = [A B; zeros(4,10)];
expAh = expm(Ah*dt);

% DT Matrices
F = expAh(1:6,1:6)
G = expAh(1:6, 7:10)
H = C; 
Ct = ctrb(F,G);
rc = rank(Ct);
eig_d = eig(F);

%Dynamics are fully controllable, therefore the system should be
%stabalizable, however because eigen values are positive, the system is
%unstable
Ob = obsv(F,H);
ro = rank(Ob');

%Measurement equations are fully observable