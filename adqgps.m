clear;clc;close all;
%% LECTURA DE DATOS
[filename, pathname] = uigetfile('*.*');
filename = fullfile(pathname, filename); % Une toda la ruta de acceso al archivo, pathname y filename
fid=fopen(filename);
Datos_O=textscan(fid,'%s %f %f %f','Delimiter',',');
PIDs=Datos_O{1,1}(:,1);
Valores=Datos_O{1,2}(:,1);
Valoresy=Datos_O{1,3}(:,1);
Valoresz=Datos_O{1,4}(:,1);
i1=1;i2=1;i3=1;i4=1;i5=1;i6=1;i7=1;i8=1;i9=1;i10=1;i11=1;i12=1;i13=1;i14=1;
Lat=0; Long=0;Alt=0;nGPS1=2; cGPS=2;    ic=1; Hr=0; Fch=0;
VSS=2; RPMS=2; TPS=2; ECT=2; IAT= 2; MAP=2; MAF=2; STFT=2; LTFT=2; O2=2; Ax=2; Ay=2; Az=2;

%% OBTENCION DEL VECTOR DE TIEMPO
for i=1:length(PIDs)
    %Vector de tiempo
    if strcmp(PIDs(i),'0')==1
        n1(i1,1)=i;
        Timer(i1,1)=Valores(i);
        i1=i1+1;
    end
end
Tiempo=Timer(2:end-1);
Tiempo0=(Tiempo-Tiempo(1));
% Reconocimiento de sensores y clasificación
for i=1:length(PIDs)
    if strcmp(PIDs(i),'10D')==1
        VSS(i2,1)=Valores(i);
        i2=i2+1;
    end
    if strcmp(PIDs(i),'10C')==1
        RPMS(i3,1)=Valores(i);
        i3=i3+1;
    end
    if strcmp(PIDs(i),'111')==1
        TPS(i4,1)=Valores(i);
        i4=i4+1;
    end
    if strcmp(PIDs(i),'105')==1
        ECT(i5,1)=Valores(i);
        i5=i5+1;
    end
    if strcmp(PIDs(i),'10F')==1
        IAT(i6,1)=Valores(i);
        i6=i6+1;
    end
    if strcmp(PIDs(i),'110')==1
        MAF(i7,1)=Valores(i);
        i7=i7+1;
    end
    if strcmp(PIDs(i),'10B')==1
        MAP(i8,1)=Valores(i);
        i8=i8+1;
    end

    if strcmp(PIDs(i),'106')==1
        STFT(i9,1)=Valores(i);
        i9=i9+1;
    end
    if strcmp(PIDs(i),'107')==1
        LTFT(i10,1)=Valores(i);
        i10=i10+1;
    end
    if strcmp(PIDs(i),'114')==1
        O2(i11,1)=Valores(i);
        i11=i11+1;
    end
    if strcmp(PIDs(i),'20')==1
        Ax(i12,1)=Valores(i);
        Ay(i12,1)=Valoresy(i);
        Az(i12,1)=Valoresz(i);
        i12=i12+1;
    end
    if strcmp(PIDs(i),'10')==1
        Hr(i13,1)=Valores(i);
        i13=i13+1;        
    end
    if strcmp(PIDs(i),'A')==1
        Lat(i14,1)=Valores(i);
        Long(i14,1)=Valores(i+1);
        Alt(i14,1)=Valores(i+2);
        nGPS1(i14,1)=i;
        i14=i14+1;        
    end
%     if strcmp(PIDs(i),'B')==1
%         Long(i14,1)=Valores(i);
%         i14=i14+1;
%     end
%     if strcmp(PIDs(i),'C')==1
%         Alt(i13,1)=Valores(i);
%         i13=i13+1;
%     end
end
% Datos obtenidos del Freematics
VSS=VSS(1:end-1);       VSScf=VSS;          VSSsf=VSS;
RPMS=RPMS(1:end-1);     RPMScf=RPMS;        RPMSsf=RPMS;
TPS=TPS(1:end-1);       TPScf=TPS;          TPSsf=TPS;
ECT=ECT(1:end-1);       ECTcf=ECT;          ECTsf=ECT;
IAT=IAT(1:end-1);       IATcf=IAT;          IATsf=IAT;
MAP=MAP(1:end-1);       MAPcf=MAP;          MAPsf=MAP;
MAF=MAF(1:end-1);       MAFcf=MAF;          MAFsf=MAF;
STFT=STFT(1:end-1);     STFTcf=STFT;        STFTsf=STFT;
LTFT=LTFT(1:end-1);     LTFTcf=LTFT;        LTFTsf=LTFT;
O2=O2(1:end-1);         O2cf=O2;            O2sf=O2;
Ax=Ax(1:end-1);         Axcf=Ax;            Axsf=Ax;
Ay=Ay(1:end-1);         Aycf=Ay;            Aysf=Ay;
Az=Az(1:end-1);         Azcf=Az;            Azsf=Az;
Lat=Lat(1:end-1);       Latcf=Lat;          Latsf=Lat/1000000;
Long=Long(1:end-1);     Longcf=Long;        Longsf=Long/1000000;
Alt=Alt(1:end-1);       Altcf=Alt;          Altsf=Alt;
Hr=Hr(1:end-1);
%% PRIMERA ETAPA DE FILTRADO - ELIMINACION DE RUIDO
Pen1=0;Pen2=0;Pen3=0;Pen4=0;Pen5=0;Pen6=0;Pen7=0;Pen8=0;Pen9=0;Pen10=0;Peen11=0;Pen13=0;
% VSS
for i=1:length(VSSsf)-1
    Pen1(i)=(VSScf(i+1)-VSScf(i))/((i+1)-i);
end
for i=1:length(Pen1)-1
    if abs(Pen1(i))+abs(Pen1(i+1))>9
        VSScf(i+1)=VSScf(i);
    end
end
%figure; plot(VSSsf); hold on; plot(VSS)
%max(abs(Pen1))
% REVOLUCIONES
for i=1:length(RPMSsf)-1
    Pen2(i)=(RPMScf(i+1)-RPMScf(i))/((i+1)-i);
end
for i=1:length(Pen2)-1
    if abs(Pen2(i))+abs(Pen2(i+1))>600
        RPMScf(i+1)=RPMScf(i);
    end
end
%figure; plot(RPMSsf); hold on; plot(RPMS)
%max(abs(Pen2))
% TPS
for i=1:length(TPSsf)-1
    Pen3(i)=(TPScf(i+1)-TPScf(i))/((i+1)-i);
end
for i=1:length(Pen3)-1
    if abs(Pen3(i))+abs(Pen3(i+1))>600
        TPScf(i+1)=TPScf(i);
    end
end
%figure; plot(TPSsf); hold on; plot(TPS)
%max(abs(Pen3))
% ECT
for i=1:length(ECTsf)-1
    Pen4(i)=(ECTcf(i+1)-ECTcf(i))/((i+1)-i);
end
for i=1:length(Pen4)-1
    if abs(Pen4(i))+abs(Pen4(i+1))>5
        ECTcf(i+1)=ECTcf(i);
    end
end
%figure; plot(ECTsf); hold on; plot(ECT)
%max(abs(Pen4))
% IAT
for i=1:length(IATsf)-1
    Pen5(i)=(IATcf(i+1)-IATcf(i))/((i+1)-i);
end
for i=1:length(Pen5)-1
    if abs(Pen5(i))+abs(Pen5(i+1))>5
        IATcf(i+1)=IATcf(i);
    end
end
%figure; plot(IATsf); hold on; plot(IAT)
%max(abs(Pen5))
% MAF
for i=1:length(MAFsf)-1
    Pen6(i)=(MAFcf(i+1)-MAFcf(i))/((i+1)-i);
end
for i=1:length(Pen6)-1
    if abs(Pen6(i))+abs(Pen6(i+1))>600
        MAFcf(i+1)=MAFcf(i);
    end
end
%figure; plot(MAFsf); hold on; plot(MAF)
%max(abs(Pen6))
% MAP
for i=1:length(MAPsf)-1
    Pen7(i)=(MAPcf(i+1)-MAPcf(i))/((i+1)-i);
end
for i=1:length(Pen7)-1
    if abs(Pen7(i))+abs(Pen7(i+1))>600
        MAPcf(i+1)=MAPcf(i);
    end
end
%figure; plot(MAPsf); hold on; plot(MAP)
%max(abs(Pen7))
% STFT
for i=1:length(STFTsf)-1
    Pen8(i)=(STFTcf(i+1)-STFTcf(i))/((i+1)-i);
end
for i=1:length(Pen8)-1
    if abs(Pen8(i))+abs(Pen8(i+1))>600
        STFTcf(i+1)=STFTcf(i);
    end
end
%figure; plot(STFTsf); hold on; plot(STFT)
%max(abs(Pen8))
% LTFT
for i=1:length(LTFTsf)-1
    Pen9(i)=(LTFTcf(i+1)-LTFTcf(i))/((i+1)-i);
end
for i=1:length(Pen9)-1
    if abs(Pen9(i))+abs(Pen9(i+1))>600
        LTFTcf(i+1)=LTFTcf(i);
    end
end
%figure; plot(LTFTsf); hold on; plot(LTFT)
%max(abs(Pen9))
% O2
for i=1:length(O2sf)-1
    Pen10(i)=(O2cf(i+1)-O2cf(i))/((i+1)-i);
end
for i=1:length(Pen10)-1
    if abs(Pen10(i))+abs(Pen10(i+1))>600
        O2cf(i+1)=O2cf(i);
    end
end
%figure; plot(O2sf); hold on; plot(O2)
%max(abs(Pen10))
% Ax
% for i=1:length(Axsf)-1
%     Pen11(i)=(Axcf(i+1)-Axcf(i))/((i+1)-i);
% end
% for i=1:length(Pen11)-1
%     if abs(Pen11(i))+abs(Pen11(i+1))>600
%         Axcf(i+1)=Axcf(i);
%     end
% end
%figure; plot(Axsf); hold on; plot(Ax)
%max(abs(Pen11))
% Ay
% for i=1:length(Aysf)-1
%     Pen12(i)=(Aycf(i+1)-Aycf(i))/((i+1)-i);
% end
% for i=1:length(Pen12)-1
%     if abs(Pen12(i))+abs(Pen12(i+1))>600
%         Aycf(i+1)=Aycf(i);
%     end
% end
%figure; plot(Aysf); hold on; plot(Ay)
%max(abs(Pen12))
% Az
for i=1:length(Azsf)-1
    Pen13(i)=(Azcf(i+1)-Azcf(i))/((i+1)-i);
end
for i=1:length(Pen13)-1
    if abs(Pen13(i))+abs(Pen13(i+1))>600
        Azcf(i+1)=Azcf(i);
    end
end
%figure; plot(Azsf); hold on; plot(Az)
%max(abs(Pen13))
%% PROCESAMIENTO DE SENALES 
i2=1;i3=1;i4=1;i5=1;i6=1;i7=1;i8=1;i9=1;i10=1;i11=1;i12=1;i13=1;i14=1;i13=1;i17=1;
n2=[2 2 2]; n3=[2 2 2]; n4=[2 2 2]; n5=[2 2 2]; n6=[2 2 2]; n7=[2 2 2];
n8=[2 2 2]; n9=[2 2 2]; n10=[2 2 2]; n13=[2 2 2]; n14=[2 2 2]; 
sust=-10000000000; % Valor temporal de sustitución
for i=1:length(Timer)
    if Timer(i)==Valores(nGPS1(1)-3)
        cGPS=i;
%        Fch=Valores(nGPS1(1)-2)
    end
end
for i=1:length(PIDs)
    if strcmp(PIDs(i),'11')==1
        Fch=Valores(i)
    end
end

%% OBTENCION DEL VSS
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'10D')==1
            VSS(i2,1)=VSScf(j2);
            i2=i2+1;
            if j2 == length(VSScf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   VSS(i2,1)=sust;
                   n2(k,1)=length(VSS);
                   i2=i2+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(VSS)
    if VSS(i)==sust
        VSS(i)=max(VSS(i-1:i));
    end
end
VSS=VSS(2:end);
VSSnor=VSS./max(VSS);
% FILTRO DE SENAL POR Savitzky-Golay
VSSf=sgolayfilt(VSS,1,3);
VSSfnor=VSSf./max(VSSf);

%% OBTENCION DEL RPM
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'10C')==1
            RPMS(i3,1)=RPMScf(j2);
            i3=i3+1;
            if j2 == length(RPMScf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   RPMS(i3,1)=sust;
                   n3(k,1)=length(RPMS);
                   i3=i3+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(RPMS)
    if RPMS(i)==sust
        RPMS(i)=max(RPMS(i-1:i));
    end
end
RPMS=RPMS(2:end);
% for i=1:length(RPMS)-1
%     %if VSS(i)==VSS(i+1)
%     RPMSn(i,1)=(RPMS(i)+RPMS(i+1))/2;
%     %else
% end
% for i=1:length(RPMSn)-1
%     A_RPMS(i,1)=(RPMSn(i+1)-RPMSn(i))/(Tiempo(i+1)-Tiempo(i));
% end
RPMnor=RPMS./max(RPMS);                                                   %RPMS normalizada

% FILTRO DE SENAL POR Savitzky-Golay
RPMSf=sgolayfilt(RPMS,1,3);                                                 %RPMS filtrada
RPMfnor=RPMSf./max(RPMSf);                                                  %RPMS filtrada normalizada

%% OBTENCION DEL TPS
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'111')==1
            TPS(i4,1)=TPScf(j2);
            i4=i4+1;
            if j2 == length(TPScf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   TPS(i4,1)=sust;
                   n4(k,1)=length(TPS);
                   i4=i4+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(TPS)
    if TPS(i)==sust
        TPS(i)=max(TPS(i-1:i));
    end
end
TPS=TPS(2:end);
TPSnor=TPS./max(TPS);
% FILTRO DE SENAL POR Savitzky-Golay
TPSf=sgolayfilt(TPS,1,3);
TPSfnor=TPSf./max(TPSf);

%% OBTENCION DEL ECT
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'105')==1
            ECT(i5,1)=ECTcf(j2);
            i5=i5+1;
            if j2 == length(ECTcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   ECT(i5,1)=sust;
                   n5(k,1)=length(ECT);
                   i5=i5+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(ECT)
    if ECT(i)==sust
        ECT(i)=max(ECT(i-1:i));
    end
end
ECT=ECT(2:end);
ECTnor=ECT./max(ECT);
% FILTRO DE SENAL POR Savitzky-Golay
ECTf=sgolayfilt(ECT,1,3);
ECTfnor=ECTf./max(ECTf);

%% OBTENCION DEL IAT
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'10F')==1
            IAT(i6,1)=IATcf(j2);
            i6=i6+1;
            if j2 == length(IATcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   IAT(i6,1)=sust;
                   n6(k,1)=length(IAT);
                   i6=i6+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(IAT)
    if IAT(i)==sust
        IAT(i)=max(IAT(i-1:i));
    end
end
IAT=IAT(2:end);
IATnor=IAT./max(IAT);
% FILTRO DE SENAL POR Savitzky-Golay
IATf=sgolayfilt(IAT,1,3);
IATfnor=IATf./max(IATf);

%% OBTENCION DEL MAP
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'10B')==1
            MAP(i7,1)=MAPcf(j2);
            i7=i7+1;
            if j2 == length(MAPcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   MAP(i7,1)=sust;
                   n7(k,1)=length(MAP);
                   i7=i7+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(MAP)
    if MAP(i)==sust
        MAP(i)=max(MAP(i-1:i));
    end
end
MAP=MAP(2:end);
MAPnor=MAP./max(MAP);
% FILTRO DE SENAL POR Savitzky-Golay
MAPf=sgolayfilt(MAP,1,3);
MAPfnor=MAPf./max(MAPf);

%% OBTENCION DEL MAF
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'110')==1
            MAF(i8,1)=MAFcf(j2);
            i8=i8+1;
            if j2 == length(MAFcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   MAF(i8,1)=sust;
                   n8(k,1)=length(MAF);
                   i8=i8+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(MAF)
    if MAF(i)==sust
        MAF(i)=max(MAF(i-1:i));
    end
end
MAF=MAF(2:end);
MAFnor=MAF./max(MAF);
% FILTRO DE SENAL POR Savitzky-Golay
MAFf=sgolayfilt(MAF,1,3);
MAFfnor=MAFf./max(MAFf);

%% OBTENCION DEL STFT
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'106')==1
            STFT(i9,1)=STFTcf(j2);
            i9=i9+1;
            if j2 == length(STFTcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   STFT(i9,1)=sust;
                   n9(k,1)=length(STFT);
                   i9=i9+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(STFT)
    if STFT(i)==sust
        STFT(i)=max(STFT(i-1:i));
    end
end
STFT=STFT(2:end);
STFTnor=STFT./max(STFT);
% FILTRO DE SENAL POR Savitzky-Golay
STFTf=sgolayfilt(STFT,1,3);
STFTfnor=STFTf./max(STFTf);

%% OBTENCION DEL LTFT
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'107')==1
            LTFT(i10,1)=LTFTcf(j2);
            i10=i10+1;
            if j2 == length(LTFTcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   LTFT(i10,1)=sust;
                   n10(k,1)=length(LTFT);
                   i10=i10+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(LTFT)
    if LTFT(i)==sust
        LTFT(i)=max(LTFT(i-1:i));
    end
end
LTFT=LTFT(2:end);
LTFTnor=LTFT./max(LTFT);
% FILTRO DE SENAL POR Savitzky-Golay
LTFTf=sgolayfilt(LTFT,1,3);
LTFTfnor=LTFTf./max(LTFTf);

%% OBTENCION DEL O2
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'114')==1
            O2(i11,1)=O2cf(j2);
            i11=i11+1;
            if j2 == length(O2cf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   O2(i11,1)=sust;
                   n11(k,1)=length(O2);
                   i11=i11+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(O2)
    if O2(i)==sust
        O2(i)=max(O2(i-1:i));
    end
end
O2=O2/200;
O2=O2(2:end);
O2nor=O2./max(O2);
% FILTRO DE SENAL POR Savitzky-Golay
O2f=sgolayfilt(O2,1,3);
O2fnor=O2f./max(O2f);



%% OBTENCION DEL ACELEROMETRO
k=1;j2=1;
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'20')==1
            Ax(i12,1)=Axcf(j2);
            Ay(i12,1)=Aycf(j2);
            Az(i12,1)=Azcf(j2);
            i12=i12+1;
            if j2 == length(Axcf)
            else
                    j2=j2+1;
            end
            ic=1;
           elseif j==n1(i+1)
                   Ax(i12,1)=sust;
                   Ay(i12,1)=sust;
                   Az(i12,1)=sust;
                   n12(k,1)=length(Ax);
                   i12=i12+1;
                   ic=1;
                   k=k+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(Ax)
    if Ax(i)==sust
        Ax(i)=max(Ax(i-1:i));
        Ay(i)=max(Ay(i-1:i));
        Az(i)=max(Az(i-1:i));
    end
end
Ax=Ax(2:end);
Ay=Ay(2:end);
Az=Az(2:end);
Ax=Ax/10;   Ay=Ay/10;   Az=Az/10;

AR=sqrt(Ax.^2+Ay.^2+Az.^2)-9.81;
Axnor=Ax./max(Ax);
Aynor=Ay./max(Ay);
Aznor=Az./max(Az);
ARnor=AR./max(AR);
%ARn=sqrt(Axn.^2+Ayn.^2+Azn.^2)-9.81; 
Axf=sgolayfilt(Ax,1,3);                                                %RPMS filtrada
Ayf=sgolayfilt(Ay,1,3);                                                %RPMS filtrada
Azf=sgolayfilt(Az,1,3);                                                %RPMS filtrada
ARf=sgolayfilt(AR,1,3);                                                %RPMS filtrada
Axfnor=Axf./max(Axf);                                                  %RPMS filtrada normalizada
Ayfnor=Ayf./max(Ayf);                                                  %RPMS filtrada normalizada
Azfnor=Azf./max(Azf);                                                  %RPMS filtrada normalizada
ARfnor=ARf./max(ARf);                                                  %RPMS filtrada normalizada


%% OBTENCION GPS
% Identificación y llenado de espacios vacíos por sust;
for i=1:length(Timer)-1
ic=0;
k1=1;
   for j=n1(i)+1:n1(i+1)
       while ic==0
           if strcmp(PIDs(j),'A')==1
            Hr(i13,1)=Valores(j-1);
            Lat(i13,1)=Valores(j);
            Long(i13,1)=Valores(j+1);
            Alt(i13,1)=Valores(j+2);
            i13=i13+1;
            ic=1;
           elseif j==n1(i+1)
                   Hr(i13,1)=sust;
                   Lat(i13,1)=sust;
                   Long(i13,1)=sust;
                   Alt(i13,1)=sust;
                   n13(k1,1)=length(Lat);
                   i13=i13+1;
                   ic=1;
                   k1=k1+1;
           else
                   j=j+1;
           end
       end
   end
end
% Sustitución de 0 por promedios
for i=2:length(Lat)
    if Lat(i)==sust
        Hr(i)=max(Hr(i-1:i));
        Lat(i)=max(Lat(i-1:i));
        Long(i)=max(Long(i-1:i));
        Alt(i)=max(Alt(i-1:i));
    end
end

for i=1:cGPS-1
    Hr(i)=Valores(nGPS1(1)-1);
    Lat(i)=Valores(nGPS1(1));
    Long(i)=Valores(nGPS1(1)+1);
    Alt(i)=Valores(nGPS1(1)+2);
end
Lat=Lat(2:end)./10^6;
Long=Long(2:end)./10^6;
Alt=Alt(2:end);
R=sqrt(Lat.^2+Long.^2+Alt.^2);
Latnor=Lat./max(Lat);
Longnor=Long./max(Long);
Altnor=Alt./max(Alt);

Latf=sgolayfilt(Lat,1,3);
Longf=sgolayfilt(Long,1,3);
Altf=sgolayfilt(Alt,1,3);
Latfnor=Latf./max(Latf);
Longfnor=Longf./max(Longf);
Altfnor=Altf./max(Altf);

%% HORA
Hr=Hr(2:end);
Hr=Hr-5000000;                                                             % Hora en Ecuador
j=1; k=1;
dant=0; dact=0; Han=0; Hac=0;
for i=1:length(Hr)
    if Hr(i)<0
        Han(j,1)=Hr(i)+24000000;
        j=j+1;
        dant=-1;
    else
        Hac(k,1)=Hr(i);
        k=k+1;
        dact=1;
    end
end
% Clasificación del día anterior
if dant == -1
    T1t=int2str(Han);
    [a1,b1]=size(T1t);
    for i=1:a1;
        if b1<=4
            Ns1(i,:)=(T1t(i,end-3:end));
            Nm1(i,:)=int2str(0);
            Nh1(i,:)=int2str(0);
        elseif b1>4&&b1<=6
            Ns1(i,:)=(T1t(i,end-3:end));
            Nm1(i,:)=(T1t(i,end-5:end-4));
            Nh1(i,:)=int2str(0);
        else
            Ns1(i,:)=(T1t(i,end-3:end));
            Nm1(i,:)=(T1t(i,end-5:end-4));
            Nh1(i,:)=(T1t(i,1:end-6));
        end
    end
    Ns1=str2num(Ns1);
    Nm1=str2num(Nm1);
    Nh1=str2num(Nh1);
    H1=[Ns1(1) Nm1(1) Nh1(1)];
    if length(Ns1)==length(Nh1)&&length(Ns1)==length(Nm1)
        for i=1:length(Nm1)
            T1(i)=Ns1(i)*10+Nm1(i)*60*1000+Nh1(i)*60*60*1000;
        end
    elseif length(Ns1)==length(Nm1)
        i=1;j=1;k=1;
        while i<=length(Ns1)-length(Nh1)
            T1(i)=Nm1(j)*60*1000+Ns1(i)*10;
            i=i+1; j=j+1;
        end
        while i<=length(Ns1)
            T1(i)=Nh1(k)*60*60*1000+Nm1(j)*60*1000+Ns1(i)*10;
            i=i+1; j=j+1; k=k+1;
        end
    elseif length(Ns1)==length(Nh1)
        i=1;j=1;k=1;
        while i<=length(Ns1)-length(Nm1)
        T1(i)=Nh1(k)*60*60*1000+Ns1(i)*10;
        i=i+1;
        end
        while i<=length(Ns1)
            T1(i)=Nh1(k)*60*60*1000+Nm1(j)*60*1000+Ns1(i)*10;
            i=i+1; j=j+1; k=k+1;
        end
    else
        i=1;j=1;k=1;
        while i<=length(Ns1)-length(Nm1)
            T1(i)=Ns1(i)*10;
            i=i+1;
        end
        while i<=length(Ns1)-length(Nh1)
            T1(i)=Nm1(j)*60*1000+Ns1(i)*10;
            i=i+1; j=j+1;
        end
        while i<=length(Ns1)
            T1(i)=Nh1(k)*60*60*1000+Nm1(j)*60*1000+Ns1(i)*10;
            i=i+1; j=j+1; k=k+1;
        end
    end
end
% Clasificación del día actual
if dact==1
    T2t=int2str(Hac);
    [a2,b2]=size(T2t);
    for i=1:a2;
        if b2<=4
            Ns2(i,:)=(T2t(i,end-3:end));
            Nm2(i,:)=int2str(0); 
            Nh2(i,:)=int2str(0);
        elseif b2>4&&b2<=6
            Ns2(i,:)=(T2t(i,end-3:end));
            Nm2(i,:)=(T2t(i,end-5:end-4));
            Nh2(i,:)=int2str(0);
        else
            Ns2(i,:)=(T2t(i,end-3:end));
            Nm2(i,:)=(T2t(i,end-5:end-4));
            Nh2(i,:)=(T2t(i,1:end-6));
        end
    end
    Ns2=str2num(Ns2);
    Nm2=str2num(Nm2);
    Nh2=str2num(Nh2);
    if dant == 0
        H1=[Ns2(1) Nm2(1) Nh2(1)];
    end
    Hf=[Ns2(end) Nm2(end) Nh2(end)];
    if length(Ns2)==length(Nh2)&&length(Ns2)==length(Nm2)
        for i=1:length(Nm2)
            T2(i)=Ns2(i)*10+Nm2(i)*60*1000+Nh2(i)*60*60*1000;
        end
    elseif length(Ns2)==length(Nm2)
        i=1;j=1;k=1;
        while i<=length(Ns2)-length(Nh2)
            T2(i)=Nm2(j)*60*1000+Ns2(i)*10;
            i=i+1; j=j+1;
        end
        while i<=length(Ns2)
            T2(i)=Nh2(k)*60*60*1000+Nm2(j)*60*1000+Ns2(i)*10;
            i=i+1; j=j+1; k=k+1;
        end
    elseif length(Ns2)==length(Nh2)
        i=1;j=1;k=1;
        while i<=length(Ns2)-length(Nm2)
        T2(i)=Nh2(k)*60*60*1000+Ns2(i)*10;
        i=i+1;
        end
        while i<=length(Ns2)
            T2(i)=Nh2(k)*60*60*1000+Nm2(j)*60*1000+Ns2(i)*10;
            i=i+1; j=j+1; k=k+1;
        end
    else
        i=1;j=1;k=1;
        while i<=length(Ns2)-length(Nm2)
            T2(i)=Ns2(i)*10;
            i=i+1;
        end
        while i<=length(Ns2)-length(Nh2)
            T2(i)=Nm2(j)*60*1000+Ns2(i)*10;
            i=i+1; j=j+1;
        end
        while i<=length(Ns2)
            T2(i)=Nh2(k)*60*60*1000+Nm2(j)*60*1000+Ns2(i)*10;
            i=i+1; j=j+1; k=k+1;
        end
    end
else
    Hf=[Ns1(end) Nm1(end) Nh1(end)];
end
if dact==1
    if dant==0
        T=T2-T2(1);
        d1=0;
        d2=0;        
    else
        T11=(T1-T1(1))';
        T22=(T2+T11(end))';
        T=[T11;T22];
        d1=-1;
        d2=0;
    end
else
    if dant == -1
        d1=-1;
        d2=-1;
    end        
    T=T1-T1(1);
end
Tf=T;
T=sgolayfilt(T,1,9);

%% FECHA 
% FECHA DE INICIO
if Fch==0;
    Fech=int2str(0);
    Anio1=str2num('0');
    Mess1=str2num('0');
    Diaa1=str2num('0');
    % FECHA DE FIN
    Anio2=str2num('0');
    Mess2=str2num('0');
    Diaa2=str2num('0');
else  
    Fech=int2str(Fch);
    Anio1=str2num(Fech(end-1:end));
    Mess1=str2num(Fech(end-3:end-2));
    Diaa1=str2num(Fech(1:end-4));
    % FECHA DE FIN
    Anio2=str2num(Fech(end-1:end));
    Mess2=str2num(Fech(end-3:end-2));
    Diaa2=str2num(Fech(1:end-4));
end
%% Distancia Recorrida
dist_r=trapz(T/1000,VSS/3.6);
%% Tiempo total de recorrido
TTR=Tf(end)/1000;
%% Velocidad media y máxima
Vmedia=(dist_r/TTR)*3.6;  % Velocidad media
Vmax=max(VSSf);     %Velocidad Máxima
%% Guardar las variables
save Latcf.mat %datos de latitud
save longcf.mat
save VSSf.mat
