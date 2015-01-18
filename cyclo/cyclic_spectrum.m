function [cyc_spec] = cyclic_spectrum(data, alpha, fft_size, F_S, method, averaging)
% cyclic_spectrum - Estimate SCD at a given alpha using one of two methods
%       data           - 2D vector of frequency data. Result will be averaged
%                        across the time dimension
%       alpha          - cyclic frequency to compute
%       fft_size       - FFT size
%       F_S            - sample rate of data that f_data was generated from
%       method         - either 'one_fft' (frequency shift in frequency domain
%                        using circular shift of the FFT), or 'freq_shift'
%                        (frequency shift in the time domain, requires two
%                        FFTs)
%       averaging      - Number of FFT frames to average together

    if nargin < 6
        averaging = 1;
    end
    
    if strcmp(method, 'freq_shift')
        data_reshape = reshape(data(1:fft_size*averaging), fft_size, averaging);
        t = 0:1/F_S:(fft_size*averaging - 1)/F_S;
        t = reshape(t, fft_size, averaging);
        d_right = data_reshape.*exp( j*2*pi*alpha/2*t);
        d_left  = data_reshape.*exp(-j*2*pi*alpha/2*t);
        cyc_spec = mean(fftshift(fft(d_left, [], 1), 1).*...
                        conj(fftshift(fft(d_right, [], 1), 1)), 2);
    elseif strcmp(method, 'one_fft')
        cyc_fft = compute_cyclo_fft(data, fft_size, averaging);
        cyc_spec = single_fft_cyclo(cyc_fft, alpha, F_S);
    else
        cyc_spec = 0;
    end
end
