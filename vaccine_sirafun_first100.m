% almost the same as vaccine_sirafun.m, except use vaccine_sir_first100
% to simulate the model.
function g = vaccine_sirafun_first100(x,t,data)

%call vaccine_sir_first100 to simulate a model.
prediction = vaccine_sir_first100(x,t);

%% Orginze the data to be comparable to the prediction.

% extract the data from simulated model
predict_infections = prediction(:,6);
predict_death = prediction(:,4);

% extract the data from input
actual_infections = data(:,1);
actual_death = data(:,2);

% set weights for evaluate error
case_weight = 1;
death_weight = 1;

% calculate the sum of square difference as error
case_diff = predict_infections - actual_infections;
death_diff = predict_death - actual_death;

case_sqr = case_diff.^2;
death_sqr = death_diff.^2;

case_error = sum(case_sqr);
death_error = sum(death_sqr);


%% return statment

% return weighted error as cost
g = case_error * case_weight + death_error * death_weight;

end
