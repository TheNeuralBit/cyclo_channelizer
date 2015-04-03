function [channels] = analysis_channelizer(data, num_channels)
% analysis_channelizer - Split a wideband signal into M channels each sampled
%                        at fs/D, D=M/2
% Input:  data         - 1D vector of time domain data. Wideband signal to
%                        be filtered.
%         num_channels - Number of channels to produce, M
%
% Output: channels     - 1xD cell array of time domain data for each channel.
%                        item at index k has center frequency -fs/2 + kfs/D
    FFT_SIZE = num_channels;
    
    decimation = num_channels/2;
    channels = cell(num_channels, 1);
    M = num_channels;
    D = decimation;
    
    %% DESIGN THE FILTER
    disp('Designing the filter...')
    b = design_filter(num_channels);
   
    fvtool(b, 1);
    
    % zero pad
    partition_b = partition_filter(b, M, D);

    %% FILTER THE DATA
    disp('Performing polyphase filtering...')
    %zero pad
    data = [data zeros(1, FFT_SIZE - (mod(length(data) - 1, FFT_SIZE) + 1))];
    % put data into a matrix by rows, so we can compute filters across each row
    data_2d = flipud(reshape(data, M/2, []));

    filt_output = zeros(M, length(data)/D);
    for i=1:M
        filt_output(i, :) = filter(partition_b{i}, 1, data_2d(mod(i - 1, M/2) + 1, :));
    end

    for j=2:2:size(filt_output, 2)
        filt_output(:, j) = circshift(filt_output(:, j), M/2);
    end

    %% FFT
    disp('Performing FFT...')
    % compute fft of each column
    channels = circshift(ifft(filt_output, FFT_SIZE, 1), M/2 - 1, 1);
    
    channels = num2cell(channels, 2);
end
