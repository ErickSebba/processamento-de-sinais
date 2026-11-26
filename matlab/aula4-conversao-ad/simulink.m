% Definir o intervalo de x
x = 0:0.05:0.5;

% Calcular o valor de sen(2*pi*2*x) para cada valor de x
y = 2.5*sin(2*pi*2*x);

% Exibir o vetor resultante
disp('Valores de sen(2*pi*2*x):');
disp(y);

k = 5 / (2^8 - 1);

% Calcular os valores de d usando d = y / k
d = (y / k) + 128;

% Exibir o vetor de d
disp('Valores de d (y/k):');
disp(d);

disp('Valores de d e suas partes inteiras em binário:');
for i = 1:length(d)
    % Extrair a parte inteira de d
    d_int = floor(d(i));
    
    % Converter a parte inteira de d para binário
    d_bin = dec2bin(d_int);
    
    % Exibir o valor de d e sua parte inteira em binário
    fprintf('d(%d) = %f -> Parte inteira binária: %s\n', i, d(i), d_bin);
end