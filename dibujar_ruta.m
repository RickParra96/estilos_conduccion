%clc; clear all;
%% poder ingresar cualquier tipo de ruta
name = 'openstreetmap';
url = 'http://a.tile.openstreetmap.org/${z}/${x}/${y}.png';
copyright = char(uint8(169));
attribution = copyright + "OpenStreetMap contributors";
addCustomBasemap(name,url,'Attribution',attribution)
%data = load('matlab.mat');
latitude = load('Latcf.mat');
longitude= load('Longcf.mat');
% data= [latitude.Latcf,longitude.Longcf]; 
velocida = load ('VSSf.mat');
velocidad = interp1((1:numel(velocida.VSSf)), velocida.VSSf, linspace(1, numel(velocida.VSSf), numel(latitude.Latcf)), 'linear')'; % crea un vector del mismo tamaño que Latcf
zoomLevel = 16;
%player = geoplayer(latitude.Latcf(1),longitude.Longcf(1),zoomLevel);
%plotRoute(player,latitude.Latcf,longitude.Longcf);
player.Basemap = 'openstreetmap';
%plotRoute(player,latitude.Latcf,longitude.Longcf,'LineWidth',3,'Color',[.6 1 0]);  %imprimir la ruta

%% divide la velocidad en colores
nBins = 15;
binSpacing = (max(velocidad) - min(velocidad))/nBins; 
binRanges = min(velocidad):binSpacing:max(velocidad)-binSpacing; 
% Add an inf to binRanges to enclose the values above the last bin.
binRanges(end+1) = inf;
% |histc| determines which bin each speed value falls into.
[~, spdBins] = histc(velocidad, binRanges);

latitude.Latcf = latitude.Latcf';
longitude.Longcf = longitude.Longcf';
spdBins = spdBins';

% Create a geographical shape vector, which stores the line segments as
% features.
s = geoshape();

for k = 1:nBins
    
    % Keep only the lat/lon values which match the current bin. Leave the 
    % rest as NaN, which are interpreted as breaks in the line segments.
    latValid = NaN(1,length(latitude.Latcf));
    latValid(spdBins==k) = latitude.Latcf(spdBins==k);
    
    lonValid = nan(1, length(longitude.Longcf));
    lonValid(spdBins==k) = longitude.Longcf(spdBins==k);    

    % To make the path continuous despite being segmented into different
    % colors, the lat/lon values that occur after transitioning from the
    % current speed bin to another speed bin will need to be kept.
    transitions = [diff(spdBins) 0];
    insertionInd = find(spdBins==k & transitions~=0) + 1;

    % Preallocate space for and insert the extra lat/lon values.
    latSeg = zeros(1, length(latValid) + length(insertionInd));
    latSeg(insertionInd + (0:length(insertionInd)-1)) = latitude.Latcf(insertionInd);
    latSeg(~latSeg) = latValid;
    
    lonSeg = zeros(1, length(lonValid) + length(insertionInd));
    lonSeg(insertionInd + (0:length(insertionInd)-1)) = longitude.Longcf(insertionInd);
    lonSeg(~lonSeg) = lonValid;

    % Add the lat/lon segments to the geographic shape vector.
    s(k) = geoshape(latSeg, lonSeg);
    
end
%Colocar un marcador en el inicio del mapa
wm = webmap('Open Street Map');
mwLat = latitude.Latcf (1);
mwLon = longitude.Longcf(1);
wmmarker(mwLat, mwLon);

colors = jet(nBins);
wmline(s, 'Color', colors, 'Width', 5);
wmzoom(14);