function [cyc_spec] = cyclic_spectrum(data, alpha, fft_size, F_S)
t = 0:1/F_S:(fft_size - 1)/F_S;
s_right = data(1:fft_size).*exp( j*2*pi*alpha/2*t);
s_left  = data(1:fft_size).*exp(-j*2*pi*alpha/2*t);
cyc_spec = fftshift(fft(s_left)).*conj(fftshift(fft(s_right)));
end
