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
data = importdata('data/cooplocalization_finalproj_KFdata.mat') ;
Qtrue = data.Qtrue ;
Rtrue = data.Rtrue ;
measLabels = data.measLabels ;
tvec = data.tvec ;
ydata = data.ydata ;
ydata = [zeros(5,1) ydata(:,2:1001)] ;