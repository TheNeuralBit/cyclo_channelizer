function [output] = synthesis_channelizer(data, F_S)
% data: dimension 1 = time
%       dimension 2 = channel
num_channels = size(data, 1);
FFT_SIZE = num_channels;

%% DESIGN THE FILTER
disp('Designing the filter...')
b = design_filter(F_S, num_channels)

% plot the filter
figure(2);
plot_spectrum(b, F_S);

% zero pad the filter, split coefficients up
b = [b zeros(1, FFT_SIZE - mod(length(b), FFT_SIZE))];
b = reshape(b, FFT_SIZE, []);

%% FFT
disp('Performing FFT...')
% compute fft of each column
fft_out = fftshift(fft(data, FFT_SIZE, 1));

%% FILTER THE DATA
disp('Performing polyphase filtering...')

%filt_output = conv2(data_2d, b);
filt_output = zeros(size(fft_out));
for i=1:FFT_SIZE
    filt_output(i, :) = filter(b(i,:), 1, fft_out(i, :));
end

output = filt_output;

end
