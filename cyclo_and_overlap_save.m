function [channels output_f_s freqs] = cyclo_and_overlap_save(data, bauds_to_check, samps_per_sym)
% cyclo_and_overlap_save - Combined cyclostationary detector and OS Filter Bank
% Input: data           - 1D vector of time domain data. Wideband signal to
%                         perform detection on and filter.
%        bauds_to_check - 1D vector of floats. List of baud rates to search for.
%        samps_per_sym  - Desired number of samples per sybol in each output
%                         channel
% Output: output        - 1xD cell array of time domain data for each channel.
%                         item at index k has center frequency -fs/2 + kfs/D
%         output_f_S    - array of sample rates for each output
%         freqs         - list of center frequencies for each output
    configuration;
    threshold = CYCLO_PEAK_THRESH;
    min_spacing = CYCLO_PEAK_MIN_SPACING;
    fft_size = 1024;


    potential_decimations = F_S./bauds_to_check./samps_per_sym;
    [data_fft, P, V] = os_fft(data, potential_decimations, fft_size);
    [freqs, bauds] = cyclo_detect(fftshift(data_fft, 1), bauds_to_check, threshold, min_spacing, fft_size, F_S);
    decimations = F_S./bauds./samps_per_sym;
    channels = os_filter(data_fft, freqs, decimations, F_S, fft_size, P, V);
    output_f_s = F_S./decimations;
end
