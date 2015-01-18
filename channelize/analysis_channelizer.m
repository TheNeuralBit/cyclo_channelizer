function [channels] = analysis_channelizer(data, num_channels)
% analysis_channelizer - Split a wideband signal into D channels each samples
%                        at fs/D
% Input:  data         - 1D vector of time domain data. Wideband signal to
%                        be filtered.
%         num_channels - Number of channels to produce, D
%
% Output: channels     - 1xD cell array of time domain data for each channel.
%                        item at index k has center frequency -fs/2 + kfs/D
    FFT_SIZE = num_channels;
    
    channels = cell(num_channels, 1);
    
    %% DESIGN THE FILTER
    disp('Designing the filter...')
    b = design_filter(num_channels);
    
    fvtool(b, 1);
    
    % zero pad
    b = [b zeros(1, FFT_SIZE - (mod(length(b) - 1, FFT_SIZE) + 1))];
    b = reshape(b, FFT_SIZE, []);
    
    %% FILTER THE DATA
    disp('Performing polyphase filtering...')
    %zero pad
    data = [data zeros(1, FFT_SIZE - (mod(length(data) - 1, FFT_SIZE) + 1))];
    % put data into a matrix by rows, so we can compute filters across each row
    data_2d = flipud(reshape(data, FFT_SIZE, []));
    
    filt_output = zeros(size(data_2d));
    for i=1:FFT_SIZE
        filt_output(i, :) = filter(b(i,:), 1, data_2d(i, :));
    end
    
    %% FFT
    disp('Performing FFT...')
    % compute fft of each column
    channels = flipud(fftshift(fft(filt_output, FFT_SIZE, 1), 1));
    
    channels = num2cell(channels, 2);
end
