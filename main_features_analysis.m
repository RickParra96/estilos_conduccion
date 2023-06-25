clear all
close all
clc

load('Features.mat')
rng(10)
filtrofilas = setdiff(1:51, [19, 21, 42, 22]);
filtrocol = setdiff(Features.Properties.VariableNames,{'fileinfo', 'RCS', 'consumo_total', 'aceleracion_media', 'label', 'dist_r'});
data2 = Features(filtrofilas,:);
data = Features(filtrofilas, filtrocol);
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
%  'MAPf_media'
%  'RPA'
%  'RPMSf_media'     
%  'TPSf_media'
%  'VA95percentile'
%  'VA_media'
%  'VSSf_media'
%  'aceleracion_std'
%  'flujohr_media'
var_para_graficar = 'flujohr_media'; %modificar esto
label_grafica = 'flujohr_media'; %modificar esto
scatter(score(:, 1), score(:, 2), [], data(:,var_para_graficar).Variables , 'filled');
xlabel('Component 1');
ylabel('Component 2');
title('tsne - Visualisation');
colormap jet
a = colorbar;
a.Label.String  = label_grafica;

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

%% box plot 2
d2 = data(:,{'flujohr_media', 'flujohr_std',...
    'flujohr_sk','RPMSf_media', ...
    'aceleracion_std', 'TPSf_media', ...
    'MAPf_media', 'VA_media', ...
    'VA95percentile','VSSf_media','RPA'})

d3 = renamevars(d2, ["flujohr_media", "flujohr_std",...
    "flujohr_sk","RPMSf_media", ...
    "aceleracion_std", "TPSf_media", ...
    "MAPf_media", "VA_media", ...
    "VA95percentile","VSSf_media","RPA"], ...
    ["Fm", "Fstd",...
    "Fsk","RPMm", ...
    "Accstd", "TPSm", ...
    "MAPm", "VAm", ...
    "VA95","Vm","RPA"])
figure,[R,PValue] = corrplot(d3),ax=gca;

%%
d4 = data(:,{...
    'RPMSf_media', ...
    'aceleracion_std', 'TPSf_media', ...
    'MAPf_media', 'VA_media', ...
    'VA95percentile','VSSf_media','RPA'});
X = d4.Variables;

Xn = zscore(X);
%Xn2 = [ones(size(Xn,1),1), Xn];
[beta,Sigma,E,CovB,logL] = mvregress(Xn, data.flujohr_media);

%% box plot
figure
subplot(3,2,1)
[h, pvalue] = ttest2(data.flujohr_media(et=="Normal"), data.flujohr_media(et=="Agresivo"));
boxplot(data.flujohr_media, et)
title(['flujo de combustible, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('Flujo de combustible');

subplot(3,2,2)
[h, pvalue] = ttest2(data.RPMSf_media(et=="Normal"), data.RPMSf_media(et=="Agresivo"));
boxplot(data.RPMSf_media, et)
title(['RPMS media, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('RPMS media');

subplot(3,2,3)
[h, pvalue] = ttest2(data.RPA(et=="Normal"), data.RPA(et=="Agresivo"));
boxplot(data.RPA, et)
title(['RPA, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('RPA');

subplot(3,2,4)
[h, pvalue] = ttest2(data.VA95percentile(et=="Normal"), data.VA95percentile(et=="Agresivo"));
boxplot(data.VA95percentile, et)
title(['VA95, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('VA 95 PERCENTIL');
%boxplot(data.RPA, et)

subplot(3,2,5)
[h, pvalue] = ttest2(data.RPMSf_std(et=="Normal"), data.RPMSf_std(et=="Agresivo"));
boxplot(data.RPMSf_std, et)
title(['RPM std, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('RPM STD');

subplot(3,2,6)
[h, pvalue] = ttest2(data.aceleracion_std(et=="Normal"), data.aceleracion_std(et=="Agresivo"));
boxplot(data.aceleracion_std, et)
title(['Std aceleracion, pvalue = ', num2str(pvalue)]);
% Agregar nombres a los ejes
xlabel('Estilo de condución');
ylabel('ACELERACION STD');
%two sample indepn ttest




