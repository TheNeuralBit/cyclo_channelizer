function [channels] = cyclo_and_overlap_save(data, bauds_to_check, samps_per_sym, f_s)
    threshold = 80;
    min_spacing = 2E6;
    nfft = 1024;

    [freqs, bauds] = cyclo_detect(data, bauds_to_check, threshold, min_spacing, nfft, f_s)
    decimations = f_s./bauds./samps_per_sym

    channels = overlap_save_channelizer(data, freqs, decimations, f_s, nfft);
end
