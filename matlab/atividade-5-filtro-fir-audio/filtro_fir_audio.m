close all;
clear all;
clc;

%% Passo a
% Carregar o arquivo de áudio com ruído

[y, x] = audioread('sinal_audio.wav');
Fs = 16000; % Frequência de amostragem
t = (1:length(y))/Fs;
% Exibir o sinal original no domínio do tempo
figure;
plot(t, y); % Eixo x em segundos
title('Sinal Original no Domínio do Tempo');
xlabel('Tempo [s]');
ylabel('Amplitude');
grid on;

%% Passo b: Projeto de um filtro FIR passa-baixas por janelamento usando o filterDesing do Matlab
% Parametros do filtro:
% FIR, N=99, FS =16.000 , Fc = 850, Window:hamming
load("FiltroFIR.mat")

%% Passo c
% 1/2 - Aplique o filtro FIR ao sinal utilizando a função filter./Plote o sinal filtrado no domínio do tempo. 

sinal_original = y;
sinal_filtrado = FiltroFIR.filter(sinal_original);
figure;
plot(t, sinal_filtrado); % Eixo x em segundos
title('Sinal Filtrado no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

% 3 - Compare os sinais no domínio do tempo.

figure;
plot(t, y, 'b');
hold on;
plot(t, sinal_filtrado, 'r');
hold off;
title('Comparação entre Sinal Original e Filtrado no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;
xlim([1 1.02]);
legend('Sinal Original', 'Sinal Filtrado');

%% Passo d
% 1 - Calcule e plote a FFT do sinal original e do sinal filtrado. 

N = 800; % Números de pontos na FFT (a cada 20 Hz)
f = (0:N-1)*(Fs/N); % Vetor de frequências
half_N = floor(N/2);
f_half = f(1:half_N);

fft_result_sinal_original = fft(sinal_original, N);
magnitudes_sem_ajustes_sinal_original = abs(fft_result_sinal_original);

magnitude0_sinal_original = magnitudes_sem_ajustes_sinal_original(1);
magnitude_sinal_original = magnitudes_sem_ajustes_sinal_original / (N/2);
magnitude_sinal_original(1) = magnitude0_sinal_original(1)/N;

magnitude_sinal_original_metade = magnitude_sinal_original(1:half_N);

figure;
stem_sinal_original = stem(f_half, magnitude_sinal_original_metade);
set(stem_sinal_original, 'Marker', 'none');
title('Magnitude do Sinal Original');
xlabel('Frequência (Hz)');
ylabel('Magnitude (V)');
grid on;
legend('Magnitude Sinal Original');

fft_result_sinal_filtrado = fft(sinal_filtrado, N); % FFT do sinal filtrado
magnitudes_sem_ajustes_sinal_filtrado = abs(fft_result_sinal_filtrado);

magnitude0_sinal_filtrado = magnitudes_sem_ajustes_sinal_filtrado(1);
magnitude_sinal_filtrado = magnitudes_sem_ajustes_sinal_filtrado / (N/2);
magnitude_sinal_filtrado(1) = magnitude0_sinal_filtrado(1)/N;

magnitude_sinal_filtrado_metade = magnitude_sinal_filtrado(1:half_N);

figure;
stem_sinal_filtrado = stem(f_half, magnitude_sinal_filtrado_metade);
set(stem_sinal_filtrado, 'Marker', 'none');
title('Magnitude do Sinal Filtrado');
xlabel('Frequência (Hz)');
ylabel('Magnitude (V)');
grid on;
legend('Magnitude Sinal Filtrado');

% 2 - Compare os espectros, destacando a remoção das componentes de ruído. 

figure;
stem_comparacao_sinal_original = stem(f_half, magnitude_sinal_original_metade);
set(stem_comparacao_sinal_original, 'Marker', 'none');
hold on;
stem_comparacao_sinal_filtrado = stem(f_half, magnitude_sinal_filtrado_metade);
set(stem_comparacao_sinal_filtrado, 'Marker', 'none');
hold off;
title('Comparação Espectro da Magnitude no Domínio da Frequência (Sinal Original x Sinal Filtrado)');
xlabel('Frequência (Hz)');
ylabel('Magnitude (V)');
grid on;
legend('Magnitude Sinal Original', 'Magnitude Sinal Filtrado');

% 3 - Mostre também os diagramas de ganho e fase do filtro projetado (Bode).

[numerador, denominador] = tf(FiltroFIR);        % obtém coeficientes da funcao de transf do filtro
Hd = tf(numerador, denominador, 1/Fs);         % cria sistema discreto com Ts = 1/Fs

opts = bodeoptions;
opts.FreqUnits = 'Hz';
opts.Grid = 'on';
opts.Title.String = 'Diagrama de Bode';

figure;
bode(Hd, opts);
