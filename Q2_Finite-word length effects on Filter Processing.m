clc
clear all
close all

%y[n]=x[n]+0.875y[n-1]-0.75y[n-2]
%infinite precision
a=[1 -0.875 0.75];
b=1;
zplane(b,a)
title('Pole-zero plot: Infinite Precision')
figure
freqz(b,a)
title('Frequency response: Infinite Precision')

n=-10:10;
for i = 1 : length(n)
    x(i) = 0.375*delta(n(i));
end
figure
stem(n,x)
xlabel('n')
ylabel('Delta Function')
title('Input Sequence')

y=filter(b,a,x);
figure
stem(n,y)
xlabel('n')
ylabel('Delta Function')
title('Output Sequence')

%two's complement
B=4;
sb=sign(b); %sign of b
sb_bit=(sb<0);
b2=(1-sb_bit).*b+sb_bit.*(2^B+b);
sa=sign(a); %sign of a
sa_bit=(sa<0);
a2=(1-sa_bit).*a+sa_bit.*(2^B+a);

figure
zplane(b2,a2)
title('Pole-zero plot: 4-bit Precision')
figure
freqz(b2,a2)
title('Frequency response: 4-bit Precision')

%rounding
bqr = round(b2);
aqr=round(a2);
yr=filter(bqr,aqr,x);
figure
stem(n,yr)
xlabel('n')
ylabel('Delta Function')
title('Output Sequence: rounding')

%truncation
bqt =fix(b2);
aqt=fix(a2);
yt=filter(bqt,aqt,x);
figure
stem(n,yt)
xlabel('n')
ylabel('Delta Function')
title('Output Sequence: truncation')
