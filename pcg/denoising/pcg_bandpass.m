function signal_filtered = pcg_bandpass(signal, fs, f1, f2, order)
% design a bandpass filter

[b, a] = butter(order, [f1, f2]/(fs/2), 'bandpass');

% apply the filter
signal_filtered = filter(b, a, signal);


time = linspace(0, 10, length(signal_filtered));


% plot the filtered signal
figure;
plot(time, signal_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered PCG Signal');

% Plot the single-sided spectrum of the filtered signal
figure;
N = length(signal_filtered);
f = (0:N/2-1) * fs / N; % Frequency vector for single-sided spectrum
Y = fft(signal_filtered);
Y = Y(1:N/2); % Take only the first half of the spectrum
plot(f, abs(Y));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-Sided Spectrum of Filtered PCG Signal');