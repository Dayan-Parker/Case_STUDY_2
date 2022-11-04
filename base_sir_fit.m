close all,clc,clear
load COVIDdata.mat
coviddata = [COVID_STLmetro.cases,COVID_STLmetro.deaths]; % TO SPECIFY
t = length(COVID_STLmetro.date); % TO SPECIFY

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x,t,coviddata);

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
x0 = [0.01,0.002,0.07,2737143,1,0,0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
[x,fval] = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
disp(x)
disp(fval)

figure(1);
Y_fit = siroutput_full(x,t);
Y_fit = 2747143 * Y_fit;
plot(Y_fit);
legend('S','I','R','D');
xlabel('Time')

figure(2);
plot(coviddata);