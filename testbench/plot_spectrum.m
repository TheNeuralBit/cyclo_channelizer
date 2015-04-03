function plot_spectrum( samples, fs, nfft, show_axis_labels)
if nargin < 3
    nfft = length(samples);
end
if nargin < 4
    show_axis_labels = 1;
end

samples = [samples zeros(1, nfft - (mod(length(samples) - 1, nfft) + 1))];
samples = reshape(samples, nfft, []);
f = fftshift(mean(fft(samples, [], 1), 2), 1);
plot(linspace(-fs/2, fs/2, length(f)), 10*log(abs(f)))
if show_axis_labels
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
end
xlim([-fs/2 fs/2]);

end
