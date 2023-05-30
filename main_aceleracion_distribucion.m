clear all
close all
clc

load ("vectores.mat")
load ("Features.mat")

ag = [];
an = [];
cag = 1;
can = 1;
for kk=1:size(acc,1)
    temp = acc{kk};
%temp = temp(vel{kk}<60/3.6);
    if Features.label(kk) == "Agresivo"
        
        tempag = temp; 
        cag = cag + 1;
        ag = [ag, temp];
    else
        
        an = [an, temp];
            tempan = temp; 
        can = can+1;
    end
end
%an=an(end-50000:end);

%ag=ag(end-50000:end);

th = 0.1
histogram(ag(abs(ag)>th),'Normalization','pdf')
hold on
mu = mean(ag);
sigma = std(ag);
% Define the Gaussian function
gaussian = @(x, mu, sigma) (1 / (sigma * sqrt(2*pi))) * exp(-0.5 * ((x - mu) / sigma).^2);

maxx = 6
x = linspace(-maxx, maxx, 1000);
y = gaussian(x, mu, sigma);
%plot(x,y)
xlim([-maxx, maxx])
prctile(ag,95)

%figure
histogram(an(abs(an)>th),'Normalization','pdf')
%figure
%boxplot(an(abs(an)>th))
%hold on
%boxplot(ag(abs(ag)>th))
%xlim([-maxx, maxx])
%% 
%figure
%histogram(tempag(abs(tempag)>th),'Normalization','pdf')
%hold on
%histogram(tempan(abs(tempan)>th),'Normalization','pdf')
%xlim([-maxx, maxx])

%%
%figure
%histogram(Features.aceleracion_std(Features.label=="Normal"), 'Normalization','pdf')
%hold on
%histogram(Features.aceleracion_std(Features.label=="Agresivo"), 'Normalization','pdf')

%%

[h ,p] = ttest2(an,ag)