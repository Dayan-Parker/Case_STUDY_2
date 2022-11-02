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

%create a infected variable by dividing the number of cases by the total
%population to create a precentage based infected vector.
infected = zeros(t,1);
for i = 1:t
    infected(i,:) = data(i,1)/(STLmetroPop*100000);
end

%create a "dead" vector using the same method as above
dead = zeros(t,1);
for i = 1:t
    dead(i,:) = data(i,2)/(STLmetroPop*100000);
end

data_compare = [infected,dead];
%% return statment
% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!

predict_infect = prediction(:,2)+prediction(:,3);
predict_deaths = prediction(:,4);
%%

f = sum(sum([predict_infect,predict_deaths]-data_compare));

end