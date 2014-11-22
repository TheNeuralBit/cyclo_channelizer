function [channels] = analysis_channelizer(data, num_channels, F_S)
FFT_SIZE = num_channels;

%% DESIGN THE FILTER
disp('Designing the filter...')
b = design_filter(F_S, num_channels)

fvtool(b, 1);

% zero pad
b = [b zeros(1, FFT_SIZE - mod(length(b), FFT_SIZE))];
b = reshape(b, FFT_SIZE, []);

%% FILTER THE DATA
disp('Performing polyphase filtering...')
%zero pad
data = [data zeros(1, FFT_SIZE - mod(length(data), FFT_SIZE))];
% put data into a matrix by rows, so we can compute filters across each row
data_2d = reshape(data, FFT_SIZE, []);

%filt_output = conv2(data_2d, b);
filt_output = zeros(size(data_2d));
for i=1:FFT_SIZE
    filt_output(i, :) = filter(b(i,:), 1, data_2d(i, :));
end

%% FFT
disp('Performing FFT...')
% compute fft of each column
channels = fftshift(fft(filt_output, FFT_SIZE, 1), 1);

end
