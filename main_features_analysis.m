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

%[idx, centroids] = kmeans(zscore(data.Variables), 2);
%labelint = grp2idx(label.Variables);

% Plot the reduced data
%quitarNinguno = ~(label.Variables == "Ninguno");
et = label.Variables;
%et =idx
%gscatter(score(:, 1), score(:, 2), data.RPMSf_media);
%figure
%scatter(score(:, 1), score(:, 2),[], idx, 'filled');
%xlabel('Component 1');
%ylabel('Component 2');
%title('PCA - Reduced Data');
%colormap jet
%colorbar

figure
scatter(score(:, 1), score(:, 2), [], data.RPMSf_media , 'filled');
xlabel('Component 1');
ylabel('Component 2');
title('tsne - Visualisation');
colormap jet
a = colorbar;
a.Label.String  = 'VA 95 percentile';

figure
gscatter(score(:, 1), score(:, 2),  et);
xlabel('Component 1');
ylabel('Component 2');
title('tsne - Visualisation');
%%
%figure
%x = data.VA95percentile;
%histogram(x(labelint==2))
%hold on
%histogram(x(labelint==3))
%histogram(x(idx==3))

%mean(x(idx==1))
%mean(x(idx==2))
%mean(x(idx==3))

%% box plot
figure
subplot(2,3,1)
[h, pvalue] = ttest2(data.flujohr_media(et=="Normal"), data.flujohr_media(et=="Agresivo"));
boxplot(data.flujohr_media, et)
title(['flujo de combustible, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('Flujo de combustible');

subplot(2,3,2)
[h, pvalue] = ttest2(data.RPMSf_media(et=="Normal"), data.RPMSf_media(et=="Agresivo"));
boxplot(data.RPMSf_media, et)
title(['RPMS media, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('RPMS media');

subplot(2,3,3)
[h, pvalue] = ttest2(data.RPA(et=="Normal"), data.RPA(et=="Agresivo"));
boxplot(data.RPA, et)
title(['RPA, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('RPA');

subplot(2,3,4)
[h, pvalue] = ttest2(data.VA95percentile(et=="Normal"), data.VA95percentile(et=="Agresivo"));
boxplot(data.VA95percentile, et)
title(['VA95, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('VA 95 PERCENTIL');
%boxplot(data.RPA, et)

subplot(2,3,5)
[h, pvalue] = ttest2(data.RPMSf_std(et=="Normal"), data.RPMSf_std(et=="Agresivo"));
boxplot(data.RPMSf_std, et)
title(['RPM std, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('RPM STD');

subplot(2,3,6)
[h, pvalue] = ttest2(data.aceleracion_std(et=="Normal"), data.aceleracion_std(et=="Agresivo"));
boxplot(data.aceleracion_std, et)
title(['Std aceleracion, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('ACELERACION STD');
%two sample indepn ttest




