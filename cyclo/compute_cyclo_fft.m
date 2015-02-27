function [cyc_fft] = compute_cyclo_fft(data, fft_size)
% compute_cyclo_fft - Computes FFT of input data, for use in cyclo detection
%       data           - 1D vector of time domain data. Wideband signal to
%                        perform detection on.
%       fft_size       - FFT size
    data_reshape = reshape(data(1:floor(length(data)/fft_size)*fft_size), fft_size, []);
    cyc_fft = fftshift(fft(data_reshape, [], 1), 1);
end
