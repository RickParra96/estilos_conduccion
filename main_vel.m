clear all
close all
clc
load("vectores.mat")
load("Features.mat")
vg = [];
fg = [];
vn = [];
fn = [];
for kk=1:size(vel,1)
    temp = vel{kk};
    temp2 = flu{kk};
    if Features.label(kk) == "Agresivo"
        vg = [vg, temp];
        fg = [fg, temp2];
    else
        vn = [vn, temp];
        fn = [fn, temp2];
    end
end
%w = 2;
%s = size(v,2);


%vw = reshape(vg(1:floor(s/w)*w),[],w);

%histogram(v(v>0.1)*3.6)
%vmw = mean(vw,2);
%histogram(v(v<60))
%scatter(v(v<60), f(v<60))
%%
fgmayor60 = fg(fg>0 & fg<10 & vg>60/3.6);
fnmayor60 = fn(fn>0 & fn<10 & vn>60/3.6);
histogram(fgmayor60,'Normalization','pdf')
hold on
histogram(fnmayor60,'Normalization','pdf')


[h, p] = ttest2(fgmayor60, fnmayor60)
disp("Agresivo")
 mean(fgmayor60)
 disp("Normal")
mean(fnmayor60)