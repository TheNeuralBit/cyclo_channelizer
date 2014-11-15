function [channels] = channelizer(data, num_channels, F_S)
FFT_SIZE = num_channels;

%% DESIGN THE FILTER
disp('Designing the filter...')
filt_cutoff = F_S/FFT_SIZE/2

rp = 3;           % Passband ripple
rs = 50;          % Stopband ripple
f = [0.75*filt_cutoff filt_cutoff];    % Cutoff frequencies
a = [1 0];        % Desired amplitudes

% Compute deviations
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 

c = firpmord( f, a, dev, F_S, 'cell');
b = firpm(c{:});

%b=remez(511,[0 96 160 192*32]/(192*32),[1 1 0 0],[1 13]);
%b(1)=b(2)/4;
%b(2)=b(2)/2;
%b(512)=b(1);
%b(511)=b(2);

figure(2);
plot_spectrum(b, F_S);

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
channels = fftshift(fft(filt_output, FFT_SIZE, 1));

end
