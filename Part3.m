close all,clc,clear
load mockdata.mat
mockdata = [newInfections.',cumulativeDeaths.']; % TO SPECIFY
t = length(newInfections); % TO SPECIFY

function f = vaccine_sir(x,t)

% set up transmission constants
k_infections = x(1);
k_fatality = x(2);
k_recover = x(3);
k_vaccinated = x(4);
k_vaccinated_infection = x(5);
k_vaccinated_fatality = x(6);
k_vaccinated_recover = x(7);

k_still_v = 1 - k_vaccinated_infection;
k_still_s = 1 - k_infections;
k_still_i = 1 - k_recover - k_fatality - 0.004;

% set up initial conditions
ic_susc = 1;
ic_inf = 0;
ic_rec = 0;
ic_fatality = 0;

% Set up SIRD within-population transmission matrix
% if recover can still get infected as covid did
% A = [k_still_s 0.004 0.01 0; k_infections k_still_i 0 0; 0 k_recover 0.99 0; 0 k_fatality 0 1];
A = [k_still_s 0.004 0 0 0; k_infections k_still_i 0 0 k_vaccinated_infection; 0 k_recover 1 0 0; 0 k_fatality 0 1 0; k_vaccinated 0 0 0 k_still_v];

% The next line creates a zero vector that will be used a few steps.
B = zeros(5,1);

% Set up the vector of initial conditions
x0 = [ic_susc, ic_inf, ic_rec, ic_fatality, 0];

% Here is a compact way to simulate a linear dynamical system.
% Type 'help ss' and 'help lsim' to learn about how these functions work!!
sys_sir_base = ss(A,B,eye(5),zeros(5,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return the output of the simulation
f = y;
end

function g = vaccine_sirafun(x,t,data)

%becase the siroutput_full function does the same thing as this function I
%justed called siroutput_full to make the code more readable.

prediction = vaccine_sir(x,t);

%% Orginze the data to be comparable to the prediction.

predict_infections = prediction(:,2);
predict_death = prediction(:,4);

actual_infections = data(:,1);
actual_death = data(:,2);

case_weight = 1;
death_weight = 1;

case_diff = predict_cases - actual_infections;
death_diff = predict_death - actual_death;

case_sqr = case_diff.^2;
death_sqr = death_diff.^2;

case_error = sum(case_sqr);
death_error = sum(death_sqr);


%% return statment
% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!

%%

g = case_error * case_weight + death_error * death_weight;

end

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)vaccine_sirafun(x,t,coviddata);

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
Y_cumulative = zeros(798,1);
for i = 1:798
    Y_cumulative(i,1)=(Y_fit(i,2)+Y_fit(i,3)+Y_fit(i,4));
end
Y_fit = [Y_fit, Y_cumulative, coviddata];
plot(Y_fit);
legend('model_S','model_I','model_R','model_D','model cumulative cases', 'measure cases', 'measure deaths');
xlabel('Time')
title('optimized model')