clc;
close all;

t = myTE';
f = myMeanThroughSlices;
myFitType = fittype(@(a,b,t) a*exp(-t/b), ...
    'independent', 't', 'dependent', 'f',...
    'coefficients',{'a','b'});

figure;
myFit = fit(t, f, myFitType, 'StartPoint', [0.01,100]);
plot(myFit,'b',t,f, 'ko');

myT2 = myFit.b;

