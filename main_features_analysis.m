clear all
close all
clc

load('Features.mat')
rng(10)
filtrofilas = setdiff(1:51, [19, 21, 42, 22]);
data = Features(filtrofilas, ...
    {'RPA', 'RPMSf_media', 'VA95percentile', 'MAPf_media','flujohr_media', ...
    'TPSf_media','VA_media', 'aceleracion_std', 'aceleracion_sk', ...
    'MAPf_std', 'MAPf_sk', 'RPMSf_std', 'RPMSf_sk', 'TPSf_std'});
label = Features(filtrofilas, 'label');
[score, loss] = tsne(zscore(data.Variables), 'NumDimensions', 3);
fileidx = Features(filtrofilas, {'fileinfo'});

[idx, centroids] = kmeans(zscore(data.Variables), 2);
labelint = grp2idx(label.Variables);
% Plot the reduced data
%quitarNinguno = ~(label.Variables == "Ninguno");
et = label.Variables;
%et =idx
%gscatter(score(:, 1), score(:, 2), data.RPMSf_media);
figure
scatter(score(:, 1), score(:, 2),[], idx, 'filled');
xlabel('PC1');
ylabel('PC2');
title('PCA - Reduced Data');
colormap jet
colorbar

figure
scatter(score(:, 1), score(:, 2), [], data.VA95percentile , 'filled');
xlabel('PC1');
ylabel('PC2');
title('PCA - Reduced Data');
colormap jet
colorbar
figure
gscatter(score(:, 1), score(:, 2),  et);
%%
figure
x = data.VA95percentile;
histogram(x(labelint==2))
hold on
histogram(x(labelint==3))
%histogram(x(idx==3))

mean(x(idx==1))
mean(x(idx==2))
%mean(x(idx==3))

%% box plot
figure
boxplot(data.flujohr_media, idx)
figure
boxplot(data.flujohr_media, et)
figure
boxplot(data.RPMSf_media, et)
figure
boxplot(data.RPA, et)
figure
boxplot(data.VA95percentile, idx)
boxplot(data.RPA, et)
figure
boxplot(data.RPMSf_std, et)
%two sample indepn ttest
[h, pvalue] = ttest2(data.flujohr_media(et=="Normal"), data.flujohr_media(et=="Agresivo"))
[h, pvalue] = ttest2(data.RPMSf_media(et=="Normal"), data.RPMSf_media(et=="Agresivo"))
[h, pvalue] = ttest2(data.RPA(et=="Normal"), data.RPA(et=="Agresivo"))
[h, pvalue] = ttest2(data.VA95percentile(et=="Normal"), data.VA95percentile(et=="Agresivo"))
[h, pvalue] = ttest2(data.RPMSf_std(et=="Normal"), data.VA95percentile(et=="Agresivo"))

%% 
