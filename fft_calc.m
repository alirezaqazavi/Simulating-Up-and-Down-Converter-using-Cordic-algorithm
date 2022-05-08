function fft_calc(Fs,L,i)
%---------FFT calculation---------------
% Fs = 200000;                  % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(i,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

figure
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
grid on;
hold off
end