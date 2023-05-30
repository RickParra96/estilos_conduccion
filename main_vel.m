clear all
close all
clc
load("vectores.mat")
load("Features.mat")
velg = []; veln = [];
flug = []; flun = [];
accg = []; accn = [];
rpmg = []; rpmn = [];
tpsg = []; tpsn = [];
mapg = []; mapn = [];
vag = []; van = [];

for kk=1:size(vel,1)
    if Features.label(kk) == "Agresivo"
        velg = [velg, vel{kk}];
        flug = [flug, flu{kk}];
        accg = [accg, acc{kk}];
        rpmg = [rpmg, rpm{kk}];
        tpsg = [tpsg, tps{kk}];
        mapg = [mapg, map{kk}];
        vag = [vag, va{kk}];
    else
        veln = [veln, vel{kk}];
        flun = [flun, flu{kk}];
        accn = [accn, acc{kk}];
        rpmn = [rpmn, rpm{kk}];
        tpsn = [tpsn, tps{kk}];
        mapn = [mapn, map{kk}];
        van = [van, va{kk}];
    end
end

%% urb=1, rur=2, car=3
th_urb = 60/3.6; 
th_rur = 75/3.6;
w = 600;


n_win_feat_all = get_features_all_win(veln, flun, accn, rpmn, tpsn, mapn, van, th_urb, th_rur,w);
g_win_feat_all = get_features_all_win(velg, flug, accg, rpmg, tpsg, mapg, vag, th_urb, th_rur,w);

% Map values to categories
labeln = ones(size(n_win_feat_all,1),1);
labelg = 2*ones(size(g_win_feat_all,1),1);
labelint = [labeln;labelg];
categories = {'Normal', 'Agresivo'};

Y = categorical(labelint, [1, 2], categories);

X = [n_win_feat_all; g_win_feat_all];

%t*ones(floor(size(x,2)/w),1),

%figure  
%plot(veln_urb*3.6)
%hold on
%plot(veln_rur*3.6)
%plot(veln_car*3.6)

%w = 2;
%s = size(v,2);


%vw = reshape(vg(1:floor(s/w)*w),[],w);

%histogram(v(v>0.1)*3.6)
%vmw = mean(vw,2);
%histogram(v(v<60))
%scatter(v(v<60), f(v<60))
%%
figure % urb
disp("URBANO")
fg_rde = flug(flug>0 & flug<10 & velg<th_urb);
fn_rde = flun(flun>0 & flun<10 & veln<th_urb);
histogram(fg_rde,'Normalization','pdf')
hold on
histogram(fn_rde,'Normalization','pdf')

[h, p] = ttest2(fg_rde, fn_rde);
disp(["Media Ag = ", num2str(mean(fg_rde)), " Media Nor = ", num2str(mean(fn_rde)), " p=", p])

%%
figure % rur
disp("RURAL")
fg_rde = flug(flug>0 & flug<10 & velg>th_urb & velg<th_rur);
fn_rde = flun(flun>0 & flun<10 & veln>th_urb & veln<th_rur);
histogram(fg_rde,'Normalization','pdf')
hold on
histogram(fn_rde,'Normalization','pdf')
[h, p] = ttest2(fg_rde, fn_rde);
disp(["Media Ag = ", num2str(mean(fg_rde)), " Media Nor = ", num2str(mean(fn_rde)), " p=", p])
%%
figure % urb
disp("CARRETERA")
fg_rde = flug(flug>0 & flug<10 & velg>th_rur);
fn_rde = flun(flun>0 & flun<10 & veln>th_rur);
histogram(fg_rde,'Normalization','pdf')
hold on
histogram(fn_rde,'Normalization','pdf')

[h, p] = ttest2(fg_rde, fn_rde);
disp(["Media Ag = ", num2str(mean(fg_rde)), " Media Nor = ", num2str(mean(fn_rde)), " p=", p])


%% Decision tree

load('trainedModel7.mat')

load('./test/10.mat')

tutoria;
Xtest = get_features_all_win(VSSf', flujohr', aceleracion', RPMSf', TPSf', MAPf', VA', th_urb, th_rur,w);

Ypred = trainedModel7.predictFcn(Xtest);
N = size(Ypred, 1);% num de ventanas

urb_g = sum(Ypred(Xtest.umbral_rde==1)=="Agresivo")/sum(Xtest.umbral_rde==1);
rur_g = sum(Ypred(Xtest.umbral_rde==2)=="Agresivo")/sum(Xtest.umbral_rde==2);
car_g = sum(Ypred(Xtest.umbral_rde==3)=="Agresivo")/sum(Xtest.umbral_rde==3);

flu_urb= mean(Xtest.flu_mean(Xtest.umbral_rde==1));
flu_rur= mean(Xtest.flu_mean(Xtest.umbral_rde==2));
flu_car= mean(Xtest.flu_mean(Xtest.umbral_rde==3));

if urb_g > 0.5
    urb_g_text = "Agresivo"
else
    urb_g_text = "Normal"
end

if rur_g > 0.5
    rur_g_text = "Agresivo"
else
    rur_g_text = "Normal"
end

if car_g > 0.5
    car_g_text = "Agresivo"
else
    car_g_text = "Normal"
end
fprintf('Urbano %s, consumo %f\n', urb_g_text, flu_urb);
fprintf('Rural %s, consumo %f\n', rur_g_text, flu_rur);
fprintf('Carretera %s, consumo %f\n', car_g_text, flu_car);
