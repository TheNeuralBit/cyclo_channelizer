function [output] = overlap_save_channelizer(data, freqs, decimations, F_S, fft_size)
    [data_fft, P, V] = os_fft(data, decimations, fft_size);
    output = os_filter(data_fft, freqs, decimations, F_S, fft_size, P, V);
end
