function [channels] = cyclo_and_overlap_save(data, bauds_to_check, samps_per_sym)
    configuration;
    threshold = CYCLO_PEAK_THRESH;
    min_spacing = CYCLO_PEAK_MIN_SPACING;
    nfft = 1024;

    [freqs, bauds] = cyclo_detect(data, bauds_to_check, threshold, min_spacing, nfft, F_S)
    decimations = F_S./bauds./samps_per_sym

    channels = overlap_save_channelizer(data, freqs, decimations, F_S, nfft);
end
