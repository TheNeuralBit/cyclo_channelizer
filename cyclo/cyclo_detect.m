function [output_freqs, bauds] = cyclo_detect(data, bauds_to_check, threshold, peak_distance, nfft, f_s)
% cyclo_detect - Perform cyclostationary detection on input data vector
%       data           - 1D vector of time domain data. Wideband signal to
%                        perform detection on.
%       bauds_to_check - 1D vector of floats. List of baud rates to search for
%       threshold      - Threshold, in dB, for peak search
%       peak_distance  - Minimum peak separation, in Hz
%       nfft           - FFT size
%       f_s            - sample rate of data

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
end
