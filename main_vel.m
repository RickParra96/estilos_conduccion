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
th_rur = 80/3.6;
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
fgmayor60 = flug(flug>0 & flug<10 & velg>60/3.6);
fnmayor60 = flun(flun>0 & flun<10 & veln>60/3.6);
histogram(fgmayor60,'Normalization','pdf')
hold on
histogram(fnmayor60,'Normalization','pdf')


[h, p] = ttest2(fgmayor60, fnmayor60)
disp("Agresivo")
 mean(fgmayor60)
 disp("Normal")
mean(fnmayor60)