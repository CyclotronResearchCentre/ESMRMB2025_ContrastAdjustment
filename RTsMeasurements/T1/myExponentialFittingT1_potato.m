clc;
close all;

t = myTI';
f = myMeanThroughSlices;
myFitType = fittype(@(a,b,t) abs(a*((1-2*exp(-t/b)))),...
    'independent', 't', 'dependent', 'f',...
    'coefficients',{'a','b'});

figure;
myFit = fit(t, f, myFitType, 'StartPoint', [1,1800]);
plot(myFit,'b',t,f, 'ko');

myT1 = myFit.b;

