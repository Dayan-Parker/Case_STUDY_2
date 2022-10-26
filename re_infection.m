% a scenario in which re-infections are possible
A = [0.95 0.04 0 0; 0.05 0.85 0.1 0; 0 0.1 0.9 0; 0 0.01 0 1];

% initial conditions (i.e., values of S, I, R, D at t=0).
x0 = [0.9; 0.1; 0; 0];

x1 = A* x0;

% time as days
t = 200;

% matrix x
x = zeros(4,t);
x(:,1) = x0;

for i = 2:t
    x(:,i) = A*x(:,i-1);
end


% plot the output trajectory
Y = x.';
plot(Y);
legend('S','I','R','D');
xlabel('Time')
ylabel('Percentage Population');