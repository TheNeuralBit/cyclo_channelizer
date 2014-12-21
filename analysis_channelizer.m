function [channels] = analysis_channelizer(data, num_channels, F_S)
FFT_SIZE = num_channels;

%% DESIGN THE FILTER
disp('Designing the filter...')
b = design_filter(F_S, num_channels)

fvtool(b, 1);

% zero pad
b = [b zeros(1, FFT_SIZE - (mod(length(b) - 1, FFT_SIZE) + 1))];
b = reshape(b, FFT_SIZE, []);

%% FILTER THE DATA
disp('Performing polyphase filtering...')
%zero pad
size(data)
data = [data zeros(1, FFT_SIZE - (mod(length(data) - 1, FFT_SIZE) + 1))];
size(data)
% put data into a matrix by rows, so we can compute filters across each row
data_2d = flipud(reshape(data, FFT_SIZE, []));
size(data_2d)

%filt_output = conv2(data_2d, b);
filt_output = zeros(size(data_2d));
for i=1:FFT_SIZE
    filt_output(i, :) = filter(b(i,:), 1, data_2d(i, :));
end

%% FFT
disp('Performing FFT...')
% compute fft of each column
channels = flipud(fftshift(fft(filt_output, FFT_SIZE, 1), 1));
% f_k = 2*pi/D
% channels(k,:) = channel at f_k

end
