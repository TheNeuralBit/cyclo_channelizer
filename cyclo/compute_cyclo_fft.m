function [cyc_fft] = compute_cyclo_fft(data, fft_size, averaging)
% compute_cyclo_fft - Computes FFT of input data, for use in cyclo detection
%       data           - 1D vector of time domain data. Wideband signal to
%                        perform detection on.
%       fft_size       - FFT size
%       averaging      - Number of FFT frames to average together
    if nargin < 3
        averaging = 1;
    end
    
    data_reshape = reshape(data(1:fft_size*averaging), fft_size, averaging);
    cyc_fft = fftshift(fft(data_reshape, [], 1), 1);
end
