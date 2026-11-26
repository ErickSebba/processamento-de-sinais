clear all
close all
clc
%%
%impulso

delta= zeros(1,20);

for n=0:1:20

    if n==0
        delta(n+1)=1;
    else
        delta(n+1)=0;
    end

end

n=0:20;

subplot()
stem(n,delta);
title('sequencia')
xlabel('n')
%%
%Degral

for n=0:1:20

    if n>=0
        u(n+1)=1;
    else
        u(n+1)=0;

    end

end

n=0:20;
figure;
stem(n, u);
title('Degral')
xlabel('n')

%%
% 2*(0.5).^n
n=0:20;

a2 = 2*(0.5).^n;

figure;
subplot(2,2,1)
stem(n, a2);
title('x[n] = 2 * 0.5^n');
xlabel('n');


%%
% 2*(1.5).^n
b2 = 2*(1.5).^n;

subplot(2,2,2)
stem(n, b2);
title('x[n] = 2 * 1.5^n');
xlabel('n');

%%
% 2*(−0.5).^n
c2 = 2*(-0.5).^n;

subplot(2,2,3)
stem(n, c2);
title('x[n] = 2 * -0.5^n');
xlabel('n');

%%
% 2*(−1.5).^n
d2 = 2*(-1.5).^n;

subplot(2,2,4)
stem(n, d2);
title('x[n] = 2 * -1.5^n');
xlabel('n');

%%
% 2*cos ((pi/8) * n);
n = 0:32;

a3 = 2*cos ((pi/8) * n);

figure;
subplot(3,3,1)
stem(n, a3);
title('2*cos ((pi/8) * n');
xlabel('n');

%%
% 2*cos (((pi/8) * n) - (pi/2));

%%
% 2*sin ((pi/8) * n);


%%
% 2*cos (((pi/8) * n) + (pi/2));

%%
% 2*cos ((pi/4) * n);

%%
% 2*cos (pi * n);

%%
% 2*cos (((7*pi)/4) * n);

%%
% 2*cos (((15*pi)/4)* n);

%%
% 2*cos ((2*pi) * n);
