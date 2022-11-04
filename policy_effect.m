% rates from base_sir_fit.m and actual initial data
x= [0.0003    0.0147    0.9850    2737140    1    0    0];
load COVIDdata.mat
coviddata = [COVID_STLmetro.cases,COVID_STLmetro.deaths];
t = length(COVID_STLmetro.date);

% mask
mask = x;
mask(1) = mask(1)*0.8;
mask_sir = siroutput_full(mask,t);
mask_cumulative = zeros(798,1);
for i = 1:798
    mask_cumulative(i,1)=(mask_sir(i,2)+mask_sir(i,3)+mask_sir(i,4));
end
mask_sir = [mask_sir, mask_cumulative, coviddata];
figure();
plot(mask_sir);
legend('model_S','model_I','model_R','model_D','model_cumulative_cases', 'measure_cases', 'measure_deaths');



% lockdown
lockdown = x;
lockdown(1) = mask(1)*0.6;
lockdown_sir = siroutput_full(lockdown,t);
lockdown_cumulative = zeros(798,1);
for i = 1:798
    lockdown_cumulative(i,1)=(lockdown_sir(i,2)+lockdown_sir(i,3)+lockdown_sir(i,4));
end
lockdown_sir = [lockdown_sir, lockdown_cumulative, coviddata];
figure();
plot(lockdown_sir);
legend('model_S','model_I','model_R','model_D','model_cumulative_cases', 'measure_cases', 'measure_deaths');


% vaccination
vaccine = x;
vaccine(1) = mask(1)*0.5;
vaccine(2) = mask(2)*0.5;
vaccine(3) = mask(3)*2;
vaccine_sir = siroutput_full(vaccine,t);
vaccine_cumulative = zeros(798,1);
for i = 1:798
    vaccine_cumulative(i,1)=(vaccine_sir(i,2)+vaccine_sir(i,3)+vaccine_sir(i,4));
end
vaccine_sir = [vaccine_sir, vaccine_cumulative, coviddata];
figure();
plot(vaccine_sir);
legend('model_S','model_I','model_R','model_D','model_cumulative_cases', 'measure_cases', 'measure_deaths');



% 3.5 b) should be vaccine, because policy like mask and lockdown should
% not be able to reduce death rate.