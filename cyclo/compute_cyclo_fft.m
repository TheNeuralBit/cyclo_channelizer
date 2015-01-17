function [cyc_fft] = compute_cyclo_fft(data, fft_size, averaging)
    if nargin < 3
        averaging = 1;
    end
    
    data_reshape = reshape(data(1:fft_size*averaging), fft_size, averaging);
    cyc_fft = fftshift(fft(data_reshape, [], 1), 1);
end
