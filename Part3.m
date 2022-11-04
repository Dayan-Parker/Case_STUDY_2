close all,clc,clear
load mockdata.mat
mockdata = [newInfections.',cumulativeDeaths.']; % TO SPECIFY
t = length(newInfections); % TO SPECIFY


% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)vaccine_sirafun(x,t,mockdata);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = ones(1,7);
bf = 2;

%% set up upper and lower bound constraints
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = ones(1,7);
lb = zeros(1,7);

% Specify some initial parameters for the optimizer to start from
x0 = [0.01,0.002,0.07,0.001,0.005,0.04,0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
[x,fval] = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
disp(x)
disp(fval)

figure();
Y_fit = vaccine_sir(x,t);
plot(Y_fit);
xlabel('Time')
legend('model_S','model_I','model_R','model_D','model_V', 'model_N')
title('part3 model')

Y_fit= [Y_fit, mockdata];
Y_compare = [4 6 7 8];
Y_compare = Y_fit(:, Y_compare);
figure();
plot(Y_compare);
xlabel('Time')
legend('model_D', 'model_N','measured N','measured D')

