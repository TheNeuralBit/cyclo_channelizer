% TODO if data is 2D then interpret it as an fft - nfft must match the fft
% dimension size
function [output_freqs, bauds] = cyclo_detect(data, bauds_to_check, threshold, peak_distance, nfft, f_s)

overall = tic;

configuration;
DEBUG_FIGURES = 1;

output_freqs = [];
bauds = [];

if size(data, 1) == nfft
    cyc_fft = data(:, 1:CYCLO_AVERAGING);
else
    cyc_fft = compute_cyclo_fft(data, nfft, CYCLO_AVERAGING);
end


freqs = linspace(-f_s/2, f_s/2, nfft);
spec = zeros(length(bauds), 1);
for idx = 1:length(bauds_to_check)
    spec = single_fft_cyclo(cyc_fft, bauds_to_check(idx), f_s);
    %spec = cyclic_spectrum(data, bauds_to_check(idx), nfft, f_s, CYC_SPEC_METHOD, CYCLO_AVERAGING);
    if DEBUG_FIGURES
        figure;
        plot(linspace(-f_s/2, f_s/2, nfft), 10*log(abs(spec)));
        title(sprintf('SCD at \\alpha = %d', bauds_to_check(idx)));
    end
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
disp('Overall');
toc(overall);
end
