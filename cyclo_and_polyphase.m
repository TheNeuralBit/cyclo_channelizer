function [channels output_f_s freqs] = cyclo_and_overlap_save(data, bauds_to_check, samps_per_sym)
    configuration;
    threshold = CYCLO_PEAK_THRESH;
    min_spacing = CYCLO_PEAK_MIN_SPACING;
    fft_size = 1024;

    potential_decimations = F_S./bauds_to_check./samps_per_sym;
    [freqs, bauds] = cyclo_detect(data, bauds_to_check, threshold, min_spacing, fft_size, F_S)
    decimations = F_S./bauds./samps_per_sym
    channels = polyphase_channelizer(data, freqs, decimations, F_S);
    output_f_s = F_S./decimations;
end
