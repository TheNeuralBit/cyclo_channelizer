function [output] = overlap_save_channelizer(data, freqs, decimations, F_S, fft_size)
% overlap_save_channelizer - Use overlap-save filter bank to output channels at
%                            each desired center frequency
% Input:  data        - 1D vector of time domain data. Wideband signal to
%                       be filtered.
%         freqs       - List of output center frequencies
%         decimations - List of corresponding decimation factors
%         F_S         - input sample rate
%         fft_size    - FFT size
% Output: output      - 1xD cell array of time domain data for each channel.
%                       item at index k has center frequency -fs/2 + kfs/D
    [data_fft, P, V] = os_fft(data, decimations, fft_size);
    output = os_filter(data_fft, freqs, decimations, F_S, fft_size, P, V);
end
