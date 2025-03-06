close all;
% Passo 1: Criando o sinal com as componentes especificadas
Fs = 8000; % Frequência de amostragem (8 kHz)
t = 0:1/Fs:0.01; % Vetor de tempo (10 ms de duração)

% Componentes do sinal
V1 = 10 * sin(2*pi*50*t);
V2 = 5 * sin(2*pi*200*t + deg2rad(60));
V3 = 7.5 * sin(2*pi*4000*t + deg2rad(45));

% Sinal total
sinal_original = V1 + V2 + V3;

% Passo 2: Amostragem do sinal
Fs_amostragem = 8000; % Mesma taxa de amostragem para evitar aliasing
t_amostrado = 0:1/Fs_amostragem:0.01;
sinal_amostrado = 10 * sin(2*pi*50*t_amostrado) + 5 * sin(2*pi*200*t_amostrado + deg2rad(60)) + 7.5 * sin(2*pi*4000*t_amostrado + deg2rad(45));

% Passo 3: Plotando o sinal original e amostrado
figure;
subplot(2,1,1);
plot(t, sinal_original);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

subplot(2,1,2);
stem(t_amostrado, sinal_amostrado, 'r');
title('Sinal Amostrado');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;

% Passo 4: Digitalização do sinal (Conversor A/D de 12 bits)
N_bits = 12;
Vmax = max(sinal_original);
Niveis = 2^N_bits;

sinal_digitalizado = floor((sinal_original) * (Niveis / 2*Vmax));

% Conversão para binário
dados_binarios = dec2bin(sinal_digitalizado, N_bits);

% Passo 5: Reconstrução do sinal
t_reconstruido = t_amostrado;
sinal_reconstruido = 10 * sin(2*pi*50*t_reconstruido) + 5 * sin(2*pi*200*t_reconstruido + deg2rad(60)); % Simulando perda de alta frequência

% Passo 6: Plotando o sinal original e reconstruído
figure;
stem(t_reconstruido, sinal_reconstruido, 'r--');
hold off;
title('Comparação entre Sinal Original e Reconstruído');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');
grid on;
legend('Sinal Original', 'Sinal Reconstruído');
