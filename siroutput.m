%%  This function takes three inputs

% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit

%x = x0;
%data = coviddata;
function f = siroutput(x,t,data)
load COVIDdata.mat

%becase the siroutput_full function does the same thing as this function I
%justed called siroutput_full to make the code more readable.

prediction = siroutput_full(x,t);

%% Orginze the data to be comparable to the prediction.

%as of yet there are not reinfection caluclated.

population = STLmetroPop*100000;
% normalizer = 0.001;

predict_cases = prediction(:,2) + prediction(:,3) + prediction(:,4);
predict_death = prediction(:,4);

predict_cases = population * predict_cases;
predict_death = population * predict_death;
actual_cases = data(:,1);
actual_death = data(:,2);

case_weight = 1;
death_weight = 6400;

case_diff = predict_cases - actual_cases;
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

f = case_error * case_weight + death_error * death_weight;

end