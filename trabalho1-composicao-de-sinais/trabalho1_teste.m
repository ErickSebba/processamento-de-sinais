% Definindo os parâmetros
Fs = 20000;
t = 0:1/Fs:0.02; % Vetor de tempo (20 ms de duração) ciclo de 50Hz

% Componente 1: V = 10 V, f = 50 Hz
V1 = 10 * sin(2*pi*50*t);

% Componente 2: V = 5 V, f = 200 Hz, ϕ = 60°
V2 = 5 * sin(2*pi*200*t + deg2rad(60));

% Componente 3: V = 7.5 V, f = 4000 Hz, ϕ = 45° 
V3 = 7.5 * sin(2*pi*4000*t + deg2rad(45));

% Sinal total
sinal_original = V1 + V2 + V3;

% Plotando o sinal original
figure;
plot(t,sinal_original);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;
%%
%2 e 3
% Frequência de amostragem
Fs_amostragem = 10000; % 10 kHz

% Criando o vetor de n amostragem (intervalo com amostragem discreta)
n_amostra = 0:1/Fs_amostragem:0.02; % 20 ms, mesma duração que o sinal original

% Sinal amostrado
sinal_amostrado = 10 * sin(2*pi*50*n_amostra) + ...
5 * sin(2*pi*200*n_amostra + deg2rad(60)) + ...
7.5 * sin(2*pi*4000*n_amostra + deg2rad(45));

% Plotando o sinal original e o sinal amostrado
figure;
subplot(2,1,1);
plot(t,sinal_original);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

subplot(2,1,2);
stem(n_amostra, sinal_amostrado, 'Marker', 'o'); % Usando stem para mostrar amostras discretas
title('Sinal Amostrado');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

%% Passo 4: Digitalização com A/D de 12 bits
% Considerando um conversor bipolar: entrada varia de -V_ref até +V_ref.
V_ref = max(sinal_amostrado); % Tensão de referência
qtd_degraus = 4095;
% Mapeamento do sinal de -V_ref a +V_ref para o intervalo [0, 4095]
sinal_normalizado = floor((sinal_amostrado + V_ref) * (qtd_degraus/(2*V_ref)));

% Conversão para representação binária de 12 bits
sinal_digitalizado_bin = dec2bin(sinal_normalizado, 12);


%% Passo 5: Reconstrução do sinal a partir dos valores digitalizados
% Relação inversa: mapeamento de 0 --> -V_ref e 4095 --> +V_ref
sinal_reconstruido = (sinal_normalizado/qtd_degraus) * (2*V_ref) - V_ref;
t_reconstruido = n_amostra; % Mesmo vetor de tempo da amostragem

%% Passo 6: Comparação entre o sinal original e o sinal reconstruído
figure;
plot(t, sinal_original, 'b');
hold on;
stem(t_reconstruido, sinal_reconstruido, 'r--', 'MarkerFaceColor', 'r');
hold off;
title('Comparação entre Sinal Original e Reconstruído');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;
legend('Sinal Original', 'Sinal Reconstruído');

%%
% Passo 7: Aplicação da FFT
N = 200; % Número de pontos da FFT
fft_result = fft(sinal_reconstruido, N); % Aplicando a FFT

% Frequências correspondentes aos pontos da FFT
f = (0:N-1)*(Fs_amostragem/N);

%%
%
% Passo 8: Cálculo do módulo e fase
magnitudesSemAjustes = abs(fft_result); % Módulo da FFT
phaseSemAjustes = angle(fft_result); % Fase da FFT

% Ajustando as amplitudes e fases conforme a teoria
magnitude0 = magnitudesSemAjustes(1);
magnitude = magnitudesSemAjustes / (N/2); % Ajuste das amplitudes
magnitude(1) = magnitude0(1)/N; % Ajuste para a componente DC
phase = rad2deg(phaseSemAjustes); % Convertendo a fase para graus
phase = phase + 90; % Ajuste da fase

phase(magnitude < 1) = 0; %remover as componentes de ruido
magnitude(magnitude < 1) = 0; %remover as componentes de ruido

phaseSemAjustes = rad2deg(phaseSemAjustes); % Convertendo a fase para graus (sem ajustes)
phaseSemAjustes(magnitudesSemAjustes < 1.1) = 0; %remover as componentes de ruido (sem ajustes)
magnitudesSemAjustes(magnitudesSemAjustes < 1.1) = 0; %remover as componentes de ruido (sem ajustes)

half_N = floor(N/2);
f_half = f(1:half_N);
phase_half = phase(1:half_N);
magnitude_half = magnitude(1:half_N);
magnitude_sem_ajustes_half = magnitudesSemAjustes(1:half_N);
phase_sem_ajustes_half = phaseSemAjustes(1:half_N);

%%
%
% Passo 9: Plot gráficos de amplitude e fase
% Sinais sem os ajustes

figure;
subplot(2,1,1);
stem(f_half, magnitude_sem_ajustes_half);
title('Magnitude das Componentes Sem Ajuste');
xlabel('Frequência (Hz)');
ylabel('Magnitude (V)');
grid on;
legend('Magnitude Sem Ajustes');

subplot(2,1,2);
stem(f_half, phase_sem_ajustes_half);
title('Fase das Componentes Sem Ajuste');
xlabel('Frequência (Hz)');
ylabel('Fase (Graus)');
grid on;
legend('Fase Sem Ajustes');

% Sinais com os ajustes
figure;
subplot(2,1,1);
stem(f_half, magnitude_half);
title('Magnitude das Componentes Ajustadas');
xlabel('Frequência (Hz)');
ylabel('Magnitude (V)');
grid on;
legend('Magnitude Ajustada');

subplot(2,1,2);
stem(f_half, phase_half);
title('Fase das Componentes Ajustadas');
xlabel('Frequência (Hz)');
ylabel('Fase (Graus)');
grid on;
legend('Fase Ajustada');