function f = vaccine_sir(x,t)

% set up transmission constants
k_infections = x(1);
k_fatality = x(2);
k_recover = x(3);
k_vaccinated = x(4);
k_vaccinated_infection = x(5);
k_recover_unwell = x(6);

% calculate contants need for matrix operation
k_still_v = 1 - k_vaccinated_infection;
k_still_s = 1 - k_infections - k_vaccinated;
k_still_i = 1 - k_recover - k_fatality - k_recover_unwell;

% use the fitted stats at day 100 as initial conditions
ic_susc = 0.4253;
ic_inf = 0.0061;
ic_rec = 0.5167;
ic_fatality = 0.0450;
ic_vaccine = 0;
ic_new_infection = 0.0068;

% Set up SIRDVN within-population transmission matrix
% new states V for vaccinated and N for new infection at that day
A = [k_still_s k_recover_unwell 0 0 0 0; ...
    0 k_still_i 0 0 0 1; ...
    0 k_recover 1 0 0 0; ...
    0 k_fatality 0 1 0 0; ...
    k_vaccinated 0 0 0 k_still_v 0; ...
    k_infections 0 0 0 k_vaccinated_infection 0];

% The next line creates a zero vector that will be used a few steps.
B = zeros(6,1);

% Set up the vector of initial conditions
x0 = [ic_susc, ic_inf, ic_rec, ic_fatality, ic_vaccine, ic_new_infection];

% Simulate a linear dynamical system.
sys_sir_base = ss(A,B,eye(6),zeros(6,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return the output of the simulation
f = y;
end