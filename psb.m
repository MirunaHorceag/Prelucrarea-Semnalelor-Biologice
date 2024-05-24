x=load('100m.mat'); %incarcam continutul fisierului
fs=180; %frecventa de esantionare
tmax=60; %durata semnalului de 60 secunde
n=tmax*fs; % nr de esantioane
ts=1/fs; %perioada de esantionare
t=0:ts:tmax-ts; %intervalul
semnal=x.val(1,:); %luam din matricea semnalului
s=semnal(1:tmax*fs); %de la 1 la durata semnalului*frecv de esantionare
m=256;
figure;
subplot(3,2,1); plot(t, s, "Color","#FF00FF"); title('Semnal ECG în domeniul timp');
xlabel('Timp [s]'); ylabel('Amplitudine [mV]');
S=fft(s,m); %transformata Fourier
modS=abs(S)/(m/2); %modul ptc nu putem reprezenta nr complexe
fcorect=-fs/2:fs/m:fs/2-fs/m; %stabilim noul interval de frecventa
Scorect=fftshift(modS); % mutam valorile pe minus (indeplinim conditia Fs≥2Fmax)
subplot(3,2,2); plot(fcorect, Scorect, "Color","#FF00FF"); title('Semnal ECG în domeniul frecvență'); xlabel('Frecvență [Hz]'); ylabel('Amplitudine normalizată');
%filtrare
[B,A]=fir1(50,[8,50]/90,"bandpass");
semnal_filtrat=filter(B,A,s);
[H,W]=freqz(B,A,m,fs);
subplot(3,2,3); plot(t,semnal_filtrat); title('Semnal ECG filtrat în domeniul timp');
xlabel('Timp [s]'); ylabel('Amplitudine [mV]');
semnal_filtrat_frecv=fft(semnal_filtrat,m);
semnal_filtrat_frecv_corect=fftshift(abs(semnal_filtrat_frecv)/(m/2));
subplot(3,2,4); plot(fcorect,semnal_filtrat_frecv_corect); title('Semnal ECG filtrat în domeniul frecvență'); xlabel('Frecvență [Hz]'); ylabel('Amplitudine normalizată');
%caracteristica filtrului
subplot(3,2,5); plot(W, abs(H)); title('Reprezentarea modulului'); xlabel('Frecvență [Hz]'); ylabel('Amplitudine');
[phi,w] = phasez(B,A,m,fs);
subplot(3,2,6); plot(w,phi); title('Reprezentarea in faza'); xlabel(''); ylabel('');