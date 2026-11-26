close all;
clear;
clc;

% Carregar o sinal de ECG fetal
load filtro1.mat;
load sinal.mat ; % Carrega o arquivo
n =  length(sinal);
Fs = 1000;

t = (0:n-1)/Fs;
figure;
plot(t, sinal);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Sinal Carregado do Arquivo')
grid on

%%
N = 2000;
f = (0:N-1)*(Fs/N); % Vetor de frequências

% FFT do sinal original
fft_original = fft(sinal,N);
magnitude_original = abs(fft_original)/N; % Normalizando a magnitude


% Plotando as magnitudes no domínio da frequência
figure;
subplot(2,1,1);
bar(f(1:N/2), magnitude_original(1:N/2)); % Frequências positivas
title('Magnitude da FFT do Sinal Original');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;

%%
%

sinal_filtrado = filter(filtro1,sinal);

figure;
subplot(2,1,1);
plot(t,sinal); % Frequências positivas
title('sinal original');
xlabel('Tempo (s)');
ylabel('amplitude');
grid on;

subplot(2,1,2);
plot(t, sinal_filtrado); % Frequências positivas
title('sinal filtrado');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

%%
%
fft_filtrado = fft(sinal_filtrado,N);
magnitude_filtrado = abs(fft_filtrado)/N; % Normalizando a magnitude

figure;
subplot(2,1,1);
bar(f(1:N/2), magnitude_filtrado(1:N/2)); % Frequências positivas
title('Magnitude da FFT do Sinal filtrado');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;