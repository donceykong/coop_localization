%% Project Parameters
%{
Group: Bethany Calvert, Anna Zavei-boroda, Doncey Albin
Project: Cooprative Localization
%}

% Clear Workspace and Command Window
clc 
clear 
close all
format compact

% If want to clear cached variables:
% clear all

% Given data
L = .5;                             %
delta_t = 0.1;                      %


phi_g_bounds = -5*pi/12:5*pi/12;    %
v_g_max = 3;                        % Top ground speed of UGV

v_a_bounds = 10:20;                 %
omega_a_bounds = -pi/6: pi/6;       %

% Nominal Operating Conditions
eta_g_nom = 10;                     %
zeta_g_nom = 0;                     %
theta_g_nom = pi/2;                 %
phi_g = -pi/18;                     % Constant input
v_g = 2;                            % Constant input

eta_a_nom = -60;                    %
zeta_a_nom = 0;                     %
theta_a_nom = -pi/2;                %
v_a = 12;                           % Constant input
omega_a = pi/25;                    % Constant input