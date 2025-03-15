close all;
% Definindo os parâmetros
Fs = 20000; 
t = 0:1/Fs:0.02; % Vetor de tempo (20 ms de duração) civlo de 50Hz

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
Fs_amostragem = 10000; % 8 kHz

% Criando o vetor de tempo para amostragem (intervalo de tempo com amostragem discreta)
t_amostra = 0:1/Fs_amostragem:0.02; % 10 ms, mesma duração que o sinal original

% Sinal amostrado
sinal_amostrado = 10 * sin(2*pi*50*t_amostra) + ...
                  5 * sin(2*pi*200*t_amostra + deg2rad(60)) + ...
                  7.5 * sin(2*pi*4000*t_amostra + deg2rad(45));

% Plotando o sinal original e o sinal amostrado
figure;
subplot(2,1,1);
plot(t,sinal_original);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

subplot(2,1,2);
stem(t_amostra, sinal_amostrado, 'Marker', 'o'); % Usando stem para mostrar amostras discretas
title('Sinal Amostrado');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

%% Passo 4: Digitalização com A/D de 12 bits
% Considerando um conversor bipolar: entrada varia de -V_ref até +V_ref.
V_ref = 2048;  % Tensão de referência
% Mapeamento do sinal de -V_ref a +V_ref para o intervalo [0, 4095]
sinal_normalizado = floor((sinal_amostrado + V_ref) * (4095/(2*V_ref)));

% Conversão para representação binária de 12 bits
sinal_digitalizado_bin = dec2bin(sinal_normalizado, 12);

disp('Primeiras 10 amostras digitalizadas em binário:');
disp(sinal_digitalizado_bin(1:10, :));

%% Passo 5: Reconstrução do sinal a partir dos valores digitalizados
% Relação inversa: mapeamento de 0 --> -V_ref e 4095 --> +V_ref
sinal_reconstruido = (sinal_normalizado/4095) * (2*V_ref) - V_ref;
t_reconstruido = t_amostra;  % Mesmo vetor de tempo da amostragem

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
N = length(sinal_reconstruido); % Número de pontos da FFT
disp(N)
fft_result = fft(sinal_reconstruido, N); % Aplicando a FFT

% Frequências correspondentes aos pontos da FFT
f = (0:N-1)*(Fs_amostragem/N);

%%
%
% Passo 8: Cálculo do módulo e fase
magnitude = abs(fft_result); % Módulo da FFT
phase = angle(fft_result); % Fase da FFT

% Ajustando as amplitudes e fases conforme a teoria
magnitude = magnitude / (N/2); % Ajuste das amplitudes
magnitude(1) = magnitude(1) / 2; % Ajuste para a componente DC
phase = rad2deg(phase); % Convertendo a fase para graus
phase = phase - 90; % Ajuste da fase

