function [cyc_spec] = cyclic_spectrum(data, alpha, fft_size, F_S, method)

if strcmp(method, 'freq_shift')
    t = 0:1/F_S:(fft_size - 1)/F_S;
    d_right = data(1:fft_size).*exp( j*2*pi*alpha/2*t);
    d_left  = data(1:fft_size).*exp(-j*2*pi*alpha/2*t);
    cyc_spec = fftshift(fft(d_left)).*conj(fftshift(fft(d_right)));
elseif strcmp(method, 'one_fft')
    num_bins = alpha/2.0/(F_S/fft_size);
    if floor(num_bins) ~= num_bins
        disp('WARNING: non integer number of bins required.')
        disp('Suggest changing FFT size or using frequency shift method.')
        num_bins = round(num_bins);
    end
    s_right = circshift(fftshift(fft(data, fft_size)), [0, num_bins]);
    s_left = circshift(s_right, [0, -num_bins*2]);
    cyc_spec = s_right.*conj(s_left);
else
    cyc_spec = 0;
end

end
