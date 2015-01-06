function [channels] = cyclo_and_overlap_save(data, bauds_to_check, samps_per_sym)
    configuration;
    threshold = CYCLO_PEAK_THRESH;
    min_spacing = CYCLO_PEAK_MIN_SPACING;
    nfft = 1024;

    decimations = F_S./bauds./samps_per_sym

    [data_fft, P, V] = os_fft(data, decimations, fft_size);
    [freqs, bauds] = cyclo_detect(data_fft, bauds_to_check, threshold, min_spacing, nfft, F_S)
    channels = os_filter(data_fft, freqs, decimations, F_S, fft_size, P, V);
end
