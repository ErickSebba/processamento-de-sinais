close all;
clear all;
clc;

opts = bodeoptions;
opts.FreqUnits = 'Hz';
opts.Grid = 'on';
%%
%passo 1
% Definindo os parâmetros do sinal
Fs = 100000; % Frequência de amostragem (100 kHz)
t = 0:1/Fs:0.02; 

V1 = 10 * sin(2*pi*100*t);

V2 = 5 * sin(2*pi*200*t);

V3 = 20 * sin(2*pi*250*t);

V4 = 7 * sin(2*pi*300*t);

V5 = 12 * sin(2*pi*3000*t);

sinal_original = V1 + V2 + V3 + V4 + V5;

% Plotando o sinal original
figure;
plot(t, sinal_original);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

%%
% passo 4
C1 = 15.4*10^-9;
C2 = 13.3 * 10^-9;
R1 = 15.8 * 10^3;
R2 = 7870;

G = tf([C1*C2*R1*R2,0,0],[C1*C2*R1*R2, R2*(C1+C2),1]);
%%
figure;
bode(G,opts);

freq = [2*pi*100, 2*pi*200, 2*pi*250, 2*pi*300, 2*pi*3000];
[mag,phase]= bode(G,freq);
mag1 = squeeze(mag);
phase1 = squeeze(phase);

figure;
[sinal_filtrado, t2] = lsim(G,sinal_original,t);

figure;
plot(t, V5);
hold on;
plot(t2, sinal_filtrado);
xlim([0 0.006])
grid on;

%%
%10 11 12
Gt = G  * G;


figure;
bode(Gt, opts);
title('Bode do Filtro de Quarta Ordem');
grid on;

[sinal_filtrado_quarta_ordem, t3] = lsim(Gt, sinal_original, t);

figure;
subplot(3,1,1);
plot(t, V5);
xlim([0 0.006])
title('Sinal 3k');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

subplot(3,1,2);
plot(t3, sinal_filtrado);
xlim([0 0.006])
title('Sinal Filtrado (2ª Ordem)');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

subplot(3,1,3);
plot(t3, sinal_filtrado_quarta_ordem);
xlim([0 0.006])
title('Sinal Filtrado (4ª Ordem)');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

%%
%fft
N = 2000;
f = (0:N-1)*(Fs/N); % Vetor de frequências

% FFT do sinal original
fft_original = fft(sinal_original,N);
magnitude_original = abs(fft_original)/N; % Normalizando a magnitude

% FFT do sinal filtrado (4ª ordem)
fft_filtrado_quarta_ordem = fft(sinal_filtrado_quarta_ordem,N);
magnitude_filtrado_quarta_ordem = abs(fft_filtrado_quarta_ordem)/N; % Normalizando a magnitude

% Plotando as magnitudes no domínio da frequência
figure;
subplot(2,1,1);
plot(f(1:N/2), magnitude_original(1:N/2)); % Frequências positivas
title('Magnitude da FFT do Sinal Original');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(f(1:N/2), magnitude_filtrado_quarta_ordem(1:N/2)); % Frequências positivas
title('Magnitude da FFT do Sinal Filtrado (4ª Ordem)');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;


