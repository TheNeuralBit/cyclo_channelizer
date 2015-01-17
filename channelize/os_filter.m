function [output] = os_filter(data_fft, freqs, decimations, F_S, fft_size, P, V)
    for idx = 1:length(freqs)
        freq = freqs(idx);
        decimation = decimations(idx);
        
        %% DESIGN THE FILTERS
        disp('Designing the filter...')
        filt_time = design_filter(decimation);
        % Zero pad so that filter is length P-1
        if length(filt_time) < P
            filt_time = [filt_time zeros(1, P - length(filt_time))];
        end
        filt_fft = fft(filt_time, fft_size);
    
        % Rotate FFT to desired center freq
        disp('Rotating FFT...')
        num_bins = -round(fft_size*freq/F_S/V)*V;
        rot_fft = circshift(data_fft, num_bins, 1);
        
        % Filter FFT
        disp('Filtering FFT...')
        filt_data_fft = zeros(size(rot_fft));
        for i = 1:size(rot_fft, 2)
            filt_data_fft(:,i) = filt_fft'.*rot_fft(:,i);
        end
        %rot_fft.*repmat(filt_fft', size(rot_fft, 1));
        
        disp('Decimating and Returning to Time Domain...')
        inv_fft = ifft(filt_data_fft, [], 1);
        tmp = buffer(inv_fft(:), fft_size - (P - 1), -(P - 1));
        tmp = tmp(:).';
        output{idx} = tmp(1:decimation:end);
    end
end
