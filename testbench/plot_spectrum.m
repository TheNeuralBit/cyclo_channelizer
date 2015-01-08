function plot_spectrum( samples, fs, nfft )
if nargin < 3
    nfft = length(samples);
end
samples = [samples zeros(1, nfft - (mod(length(samples) - 1, nfft) + 1))];
samples = reshape(samples, nfft, []);
size(samples)
f = fftshift(mean(fft(samples, [], 1), 2), 1);
size(f)
plot(linspace(-fs/2, fs/2, length(f)), 10*log(abs(f)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
xlim([-fs/2 fs/2]);

end
