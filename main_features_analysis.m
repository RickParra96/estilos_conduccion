clear all
close all
clc
load('Features.mat')

data = Features(setdiff(1:51, [19, 21, 42, 22]),{'RPA', 'RPMSf_media', 'VA95percentile', 'MAPf_media','flujohr_media', 'TPSf_media','VA_media','VSSf_media'});
[coeff, score] = pca(zscore(data.Variables), 'NumComponents', 2);


[idx, centroids] = kmeans(zscore(data.Variables), 2);

% Plot the reduced data
scatter(score(:, 1), score(:, 2),40, data.RPA, "filled");
xlabel('PC1');
ylabel('PC2');
title('PCA - Reduced Data');
colormap jet
colorbar

%%
figure
x = data.VA95percentile;
histogram(x(idx==1))
hold on
histogram(x(idx==2))
%histogram(x(idx==3))

mean(x(idx==1))
mean(x(idx==2))
%mean(x(idx==3))


