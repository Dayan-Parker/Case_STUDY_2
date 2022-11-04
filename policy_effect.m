x= [0.0013    0.0032    0.9881    2737140    1    0    0];
t = 798;

% mask
mask = x;
mask(1) = mask(1)*0.8;
mask_sir = siroutput_full(mask,t);
figure();
plot(mask_sir);

% lockdown
lockdown = x;
lockdown(1) = mask(1)*0.6;
lockdown_sir = siroutput_full(lockdown,t);
figure();
plot(lockdown_sir);

% vaccination
vaccine = x;
vaccine(1) = mask(1)*0.5;
vaccine(2) = mask(2)*0.5;
vaccine(3) = mask(3)*2;
vaccine_sir = siroutput_full(vaccine,t);
figure();
plot(vaccine_sir);


% 3.5 b) should be vaccine, because policy like mask and lockdown should
% not be able to reduce death rate.