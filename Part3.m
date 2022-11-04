% load given mock data
close all,clc,clear
load mockdata.mat
mockdata = [newInfections.',cumulativeDeaths.']; 
t = length(newInfections); 

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
Af = ones(1,6);
bf = 2;

%% set up upper and lower bound constraints
% lb < x < ub
ub = ones(1,6);
lb = zeros(1,6);

% Specify some initial parameters for the optimizer to start from
x0 = [0.01,0.002,0.07,0.001,0.005,0.04]; 

% first 100 days without vaccine
t1 = 100;
mockdata100 = mockdata(1:100, :);
sirafun= @(x)vaccine_sirafun_first100(x,t1,mockdata100);
[x100,fval] = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
disp(x100)
disp(fval)
Y_fit_100 = vaccine_sir_first100(x100,t1);

% The rest 265 days with vaccine released
t2 = 265;
mockdatarest = mockdata(101:365, :);
sirafun= @(x)vaccine_sirafun(x,t2,mockdatarest);
[x,fval] = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
disp(x)
disp(fval)
Y_fit = vaccine_sir(x,t2);

% concanate the results and plot
Y_fit = [Y_fit_100; Y_fit];
figure();
plot(Y_fit);
xlabel('Time')
legend('model_S','model_I','model_R','model_D','model_V', 'model_N')
title('vaccined model')

% compare the model with the given mock data
Y_fit= [Y_fit, mockdata];
Y_compare = [4 6 7 8];
Y_compare = Y_fit(:, Y_compare);
figure();
plot(Y_compare);
xlabel('Time')
legend('model_D', 'model_N','measured N','measured D')
title('compare mock')

