%% In The Name of God
% Alireza Qazavi | 9913904
% a.qazavi@cc.iut.ac.ir
% SDR_HW2
% Dr Omidi - IUT
%% 1
clc;clear all;close all;
Fs = 200000; % 200K sampel/sec
Fc = 5000; %carrier frequency in Hz
t = 0 : 1/Fs : 25/Fc-1/Fs;
% y_bb = sin(2*pi*Fc*t);
y_bb = sin(2*pi*Fc*t)+wgn(1,1000,mag2db(0.01));
plot(t,y_bb);title('a sinusodial with Fs = 200K sampel/sec & Fc = 5000 Hz');grid;
xlabel('time(sec)');ylabel('y(t)');
% [f,h]=spectrum(y,Fs);
fft_calc(Fs,numel(y_bb),y_bb);
%psd
[Pxx,F] = periodogram(y_bb,[],length(y_bb),Fs);
figure
plot(F,10*log10(Pxx))
grid on
title('Periodogram PSD Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
%% 2
% T=1/Fs;
% [i,q]=cor2();
% y_if = y_bb .* i;
% fft_calc(Fs,numel(y_if),y_if);
Up_Down = 0;
f_IF = 50000;
n = 1000;
Num_of_Iter = 23;
[i,q]=cor2(y_bb,zeros(1,1000),Up_Down,f_IF,n,Fs,Num_of_Iter);
L = n;
fft_calc(Fs,L,i);
figure
periodogram(i,[],n,Fs);

Up_Down = 1;
[i,q]=cor2(i,0,Up_Down,f_IF,n,Fs,Num_of_Iter);
L = n;
s = i;
fft_calc(Fs,L,s);
figure
periodogram(s,[],n,Fs);
