function [output] = synthesis_channelizer(data, F_S)
% data: dimension 1 = channel
%       dimension 2 = time
num_channels = length(data);
data = cell2mat(data);
FFT_SIZE = num_channels;

%% DESIGN THE FILTER
disp('Designing the filter...');
b = design_filter(num_channels);

% plot the filter
fvtool(b, 1);

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
