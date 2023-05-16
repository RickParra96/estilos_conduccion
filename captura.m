%% velocidad pero con captura de pantalla
recortar = imread('captura.png');
imshow(recortar);
I2 = histeq(recortar);
% figure
% imshow(I2)
colormap(jet);
c = colorbar;
caxis([min(velocidad) max(velocidad)]);
c.Label.String = 'Velociadad del vehiculo (km/h)';