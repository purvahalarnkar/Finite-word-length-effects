clc
clear all
close all

%DIRECT FORM: INFINITE PRECISION
Fs=48000;
Fc=1000;
order=6;
[b,a] = butter(order,Fc/(Fs/2));
H=filt(b,a)
zplane(b,a)
title('Direct Form, infinite precision')
[h,w]=freqz(b,a);
figure
plot(w/pi*Fs/2,20*log10(abs(h)),'r'); 
title('Frequency Response: Direct Form, infinite precision')
ylabel('Magnitude [dB]')
xlabel('Frequency [Hz]')
 axis([0 5e3 -70 15])
 grid on
 
%DIRECT FORM, 24-BIT PRECISION
bm=abs(b);
am=abs(a);
N=23; %total N+1 bits
I=4; %integer bits
F=N-I; %Freaction bits

bq = bm./(2^I); 
bq = round(bq.*(2^N)); 
bq = sign(b).*bq*(2^(-F));

aq = am./(2^I); 
aq = round(aq.*(2^N)); 
aq = sign(a).*aq*(2^(-F));

H_24bit=filt(bq,aq)
figure
zplane(bq,aq)
title('Direct Form, 24-bit precision')
[hq,w]=freqz(bq,aq);
figure
plot(w/pi*Fs/2,20*log10(abs(hq)),'b'); 
title('Frequency Response: Direct Form, 24-bit precision')
ylabel('Magnitude [dB]')
xlabel('Frequency [Hz]')
axis([0 5e3 -70 15])
grid on

%SECOND ORDER SECTIONS, 24-BIT PRECISION
[sos,g]=tf2sos(b,a);
I1=2; %integer bits
F1=N-I1; %Freaction bits
sosm=abs(sos);
sosq = sosm./(2^I1); 
sosq = round(sosq.*(2^N)); 
sosq = sign(sos).*sosq*(2^(-F1));

bq1=sosq(1:1,1:3);
aq1=sosq(1:1,4:6);
bq2=sosq(2:2,1:3);
aq2=sosq(2:2,4:6);
bq3=sosq(3:3,1:3);
aq3=sosq(3:3,4:6);

H1=filt(bq1,aq1)
H2=filt(bq2,aq2)
H3=filt(bq3,aq3)
b_sos=[bq1;bq2;bq3];
a_sos=[aq1;aq2;aq3];
sos1=[b_sos,a_sos];

%plots
figure
subplot(3,1,1)
zplane(bq1,aq1)
title('Second order section: H1')
subplot(3,1,2)
zplane(bq2,aq2)
title('Second order section: H2')
subplot(3,1,3)
zplane(bq3,aq3)
title('Second order section: H3')

[hqsos,w]=freqz(sos1);
figure
plot(w/pi*Fs/2,20*log10(abs(hqsos)),'g');
title('Frequency Response: Cascade Form, 24 bit precision')
ylabel('Magnitude [dB]')
xlabel('Frequency [Hz]')
axis([0 8e3 -70 150])
grid on


