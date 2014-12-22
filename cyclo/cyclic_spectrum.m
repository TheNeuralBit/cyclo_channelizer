function [cyc_spec] = cyclic_spectrum(data, alpha, fft_size, F_S, method, averaging)
if nargin < 6
    averaging = 1;
end

data_reshape = reshape(data(1:fft_size*averaging), fft_size, averaging);
if strcmp(method, 'freq_shift')
    t = 0:1/F_S:(fft_size*averaging - 1)/F_S;
    t = reshape(t, fft_size, averaging);
    d_right = data_reshape.*exp( j*2*pi*alpha/2*t);
    d_left  = data_reshape.*exp(-j*2*pi*alpha/2*t);
    cyc_spec = mean(fftshift(fft(d_left, [], 1), 1).*conj(fftshift(fft(d_right, [], 1), 1)), 2);
elseif strcmp(method, 'one_fft')
    num_bins = alpha/2.0/(F_S/fft_size);
    if floor(num_bins) ~= num_bins
        disp('WARNING: non integer number of bins required.')
        disp('Suggest changing FFT size or using frequency shift method.')
        num_bins = round(num_bins);
    end
    s_right = circshift(fftshift(fft(data_reshape, [], 1), 1), [num_bins, 0]);
    s_left = circshift(s_right, [-num_bins*2, 0]);
    cyc_spec = mean(s_right.*conj(s_left), 2);
else
    cyc_spec = 0;
end

end
