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
Af = ones(1,6);
bf = 2;

%% set up upper and lower bound constraints
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
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


t2 = 265;
mockdatarest = mockdata(101:365, :);
sirafun= @(x)vaccine_sirafun(x,t2,mockdatarest);
[x,fval] = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
disp(x)
disp(fval)

figure();
Y_fit = vaccine_sir(x,t2);
Y_fit = [Y_fit_100; Y_fit];
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

