clc, clear all, close all, format compact

% Parameters & Nominal Values
L = .5 ;
dt = .10 ;
vg = 3 ;

%Nominal Values
eta_g_nom = 10 ;
zeta_g_nom = 0 ;
theta_g_nom = pi/2 ;
phi_g_nom = -pi/18 ;
eta_a_nom = -60 ;
zeta_a_nom = 0 ;
theta_a_nom = -pi/2 ;
va_nom = 12 ;
vg_nom = 2 ;
wa_nom = pi/25 ;
val = [va_nom vg_nom L phi_g_nom wa_nom zeta_a_nom zeta_g_nom eta_a_nom eta_g_nom] ;

%Data
data = importdata('cooplocalization_finalproj_KFdata.mat') ;
data = struct2array(data) ;
Qtrue = cell2mat(data(1,1)) ;
Rtrue = cell2mat(data(1,2)) ;
measLabels = cell2mat(data(1,3:7)) ;
tvec = cell2mat(data(1,8)) ;
ydata = cell2mat(data(1,9)) ;
ydata = [zeros(5,1) ydata(:,2:1001)] ;