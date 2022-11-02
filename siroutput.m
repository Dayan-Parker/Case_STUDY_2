%%  This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit

data = [COVID_STLmetro.cases,COVID_STLmetro.deaths];
%function f = siroutput(x,t,data)

%becase the siroutput_full function does the same thing as this function I
%justed called siroutput_full to make the code more readable.

%prediction = siroutput_full(x,t);

%% Orginze the data to be comparable to the prediction.

%as of yet there are not reinfection caluclated.

%creata a population vector which changes based on covid related deaths 
population = zeros(798,1);
population(1:798,:) = STLmetroPop*100000;
for i = 1:798
    population(i,:)=population(i,:)-data(i,2);
end


%the recovered is given by the diffrence in the new population and the
%numer of new COVID cases.
recovered  = zeros(798,1);
%the first entry will be zero be there has not been enough time for anyone
%to recover.
for i = 2:798
    recovered(i,:)=(population(i,:)-(population(i-1,:)-(data(i,1)-data(i-1,1))))/(STLmetroPop*100000);
end

susceptible = zeros(798,1);

%the number of susceptible people is found by subtracting current
%population by the number of poeple recovered. 
for i = 1:798
    susceptible(i,:) = (population(i,:)-recovered(i,:))/(STLmetroPop*100000);
end

%create a infected variable by dividing the number of cases by the total
%population to create a precentage based infected vector.
infected = zeros(798,1);
for i = 1:798
    infected(i,:) = data(i,1)/(STLmetroPop*100000);
end

%create a "dead" vector using the same method as above
dead = zeros(798,1);
for i = 1:798
    dead(i,:) = data(i,2)/(STLmetroPop*100000);
end

data_SIRD = [susceptible,infected,recovered,dead];
%% return statment
% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!
f = 0;

%end