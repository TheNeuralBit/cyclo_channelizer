function [output_freqs, bauds] = cyclo_detect(data, bauds_to_check, threshold, peak_distance, nfft, f_s)

configuration;

output_freqs = [];
bauds = [];

freqs = linspace(-f_s/2, f_s/2, nfft);
spec = zeros(length(bauds), 1);
for idx = 1:length(bauds_to_check)
    spec = cyclic_spectrum(data, bauds_to_check(idx), nfft, f_s, CYC_SPEC_METHOD, CYCLO_AVERAGING);
    figure;
    plot(abs(spec));
    [pks, locs] = findpeaks(abs(spec), 'MinPeakHeight', threshold, ...
                                       'MinPeakDistance', round(peak_distance/(f_s/nfft)));
    % Iterate through the peaks
    % If one of them is close to a peak we already found, overwrite that one
    % with the new frequency and baud rate
    % Otherwise add the new frequency and baud rate
    for loc = locs'
        freq = freqs(loc);
        [val, nearest_idx] = min(abs(output_freqs - freq));
        if length(output_freqs) > 0 && val < peak_distance
            output_freqs(nearest_idx) = freq;
            bauds(nearest_idx) = bauds_to_check(idx);
        else
            output_freqs = [output_freqs, freq];
            bauds = [bauds bauds_to_check(idx)];
        end
    end
end
