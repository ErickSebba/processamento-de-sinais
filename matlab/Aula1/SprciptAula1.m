clear all
close all
clc

R = 3;
L = 1;
C = 0.5;

%%
%corrente como saída

num = [C 0];
den = [L*C R*C 1];
G = tf(num,den);

%%
%Tensão sobre o capacitor como Saída

num2 = 1;
den2 = [L*C R*C 1];
G2 = tf(num2,den2);

%%
% Plots
step(G)
hold on
step(G2)
legend('Corrente','Tensão')
grid

%%
%Resposta ao sinal quadrado

t = 0:0.0001:10;
f = 0.1;
x = square(2*pi*f*t);

figure
lsim(G,x,t)
hold on
lsim(G2,x,t)

%%
%Resposta ao Seno

t = 0:0.0001:10;
f = 0.1;
x = sin(2*pi*f*t);

figure
subplot(2,1,1)
lsim(G,x,t)
subplot(2,1,2)
lsim(G2,x,t)

