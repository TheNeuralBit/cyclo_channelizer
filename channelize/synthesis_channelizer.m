function [output] = synthesis_channelizer(data)
% synthesis_channelizer - Combine D channels into a single wideband signal at
%                         sample rate Dfs
% Input:  data         - 1xD cell array of time domain data for each channel.
%                        item at index k will be placed at center frequency
%                        -fs/2 + kfs/D
% Output: data         - 1D vector of wideband time domain data
    configuration;
    
    num_channels = length(data);
    data = cell2mat(data);
    FFT_SIZE = num_channels;
    
    %% DESIGN THE FILTER
    disp('Designing the filter...');
    b = design_filter(num_channels);
    
    % plot the filter
    if DEBUG_FIGURES
        fvtool(b, 1);
    end
    
    % zero pad the filter, split coefficients up
    b = [b zeros(1, FFT_SIZE - mod(length(b), FFT_SIZE))];
    b = reshape(b, FFT_SIZE, []);
    
    %% FFT
    disp('Performing FFT...')
    % compute fft of each column
    fft_out = ifft(fftshift(data, 1), FFT_SIZE, 1);
    
    %% FILTER THE DATA
    disp('Performing polyphase filtering...')
    
    %filt_output = conv2(data_2d, b);
    filt_output = zeros(size(fft_out));
    for i=1:FFT_SIZE
        filt_output(i, :) = filter(b(i,:), 1, fft_out(i, :));
    end
    
    output = reshape(filt_output, 1, []);
end
