function g = vaccine_sirafun_first100(x,t,data)

%becase the siroutput_full function does the same thing as this function I
%justed called siroutput_full to make the code more readable.

prediction = vaccine_sir_first100(x,t);

%% Orginze the data to be comparable to the prediction.

predict_infections = prediction(:,6);
predict_death = prediction(:,4);

actual_infections = data(:,1);
actual_death = data(:,2);

case_weight = 1;
death_weight = 1;

case_diff = predict_infections - actual_infections;
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
