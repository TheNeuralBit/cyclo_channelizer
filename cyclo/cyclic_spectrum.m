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
    cyc_fft = compute_cyclo_fft(data, fft_size, averaging);
    cyc_spec = single_fft_cyclo(cyc_fft, alpha, F_S);
else
    cyc_spec = 0;
end

end
