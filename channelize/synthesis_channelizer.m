function [output] = synthesis_channelizer(data)
% synthesis_channelizer - Combine M channels into a single wideband signal at
%                         sample rate Dfs
% Input:  data         - 1xM cell array of time domain data for each channel.
%                        item at index k will be placed at center frequency
%                        -fs/2 + kfs/D
% Output: output       - 1D vector of wideband time domain data
    configuration;
    
    num_channels = length(data);
    data = cell2mat(data);
    FFT_SIZE = num_channels;

    decimation = num_channels/2;
    M = num_channels
    D = decimation
    
    %% DESIGN THE FILTER
    disp('Designing the filter...');
    b = design_filter(num_channels);
    
    % plot the filter
    if DEBUG_FIGURES
        fvtool(b, 1);
    end
    
    % partiton filter
    partition_b = partition_filter(b, M, D);
    
    %% FFT
    size(data)
    %data(4,:) = zeros(1, size(data, 2));
    %data(3,:) = zeros(1, size(data, 2));
    %data(2,:) = zeros(1, size(data, 2));
    %data(1,:) = zeros(1, size(data, 2));
    
    disp('Performing FFT...')
    % compute fft of each column
    fft_out = ifft(circshift(data, M/2, 1), FFT_SIZE, 1);
    
    fft_out(:,1:4)
    for j=2:2:size(fft_out, 2)
        fft_out(:, j) = circshift(fft_out(:, j), M/2);
    end
    fft_out(:,1:4)
    
    %% FILTER THE DATA
    disp('Performing polyphase filtering...')
    
    %filt_output = conv2(data_2d, b);
    filt_output = zeros(size(fft_out));
    for i=1:M
        filt_output(i, :) = filter(partition_b{i}, 1, fft_out(i, :));
    end
    
    % dual port output commutator
    output = filt_output(1:M/2,:) + filt_output(M/2+1:end,:);
    output = reshape(output, 1, []);
end
