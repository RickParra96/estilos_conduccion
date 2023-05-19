

Features = table();

% Specify the directory path

rootdir =  './Datos rutas';
fileList = dir(fullfile(rootdir, '**/*.mat'));  %get list of files and folders in any subfolder


for kk=1:numel(fileList)
    clearvars -except Features row fileList directory kk
    close all;
    %load("./Datos rutas/08-05-23/casa-trabajo/25.mat")
    fileName = fullfile(fileList(kk).folder, fileList(kk).name);
    fileinfo = fileList(kk);
    disp(fileName);
    load(fileName);
    tutoria;
    row = table(fileinfo, RPA, VA95percentile, RCS, consumo_total, ...
                VSSf_media, VSSf_std,  VSSf_sk, ...
                TPSf_media, TPSf_std,  TPSf_sk, ...
                RPMSf_media, RPMSf_std,  RPMSf_sk, ...
                MAPf_media, MAPf_std,  MAPf_sk, ...
                flujohr_media, flujohr_std,  flujohr_sk, ...
                aceleracion_media, aceleracion_std,  aceleracion_sk, ...
                VA_media, VA_std, VA_sk);
    Features = [Features; row];
end