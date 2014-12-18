function [output] = overlap_save_channelizer(data, freq, decimation, F_S, fft_size)

%% DESIGN THE FILTERS
disp('Designing the filters...')
filt = design_filter(F_S, decimation);
% Zero pad so that P-1 is a multiple of D
%filt = [filt zeros(1, decimation - mod(length(filt) - 1, decimation))];
filt = [filt zeros(1, 21)];
size(filt)
filt_fft = fft(filt, fft_size);

V = round(fft_size/(length(filt) - 1));

% Compute FFT
data_fft = fft(buffer(data, fft_size, (length(filt) - 1)), [], 1);
size(data_fft)

% Rotate FFT to desired center freq
num_bins = -round(fft_size*freq/F_S/V)*V;
num_bins
rot_fft = circshift(data_fft, num_bins, 1);
size(rot_fft)

% Filter FFT
filt_data_fft = zeros(size(rot_fft));
for i = 1:size(rot_fft, 2)
    filt_data_fft(:,i) = filt_fft'.*rot_fft(:,i);
end
size(filt_data_fft)
%rot_fft.*repmat(filt_fft', size(rot_fft, 1));

inv_fft = ifft(filt_data_fft, [], 1);
size(inv_fft)
output = buffer(inv_fft(:), fft_size - (length(filt) - 1), -(length(filt) - 1));
output = output(:).';
output = output(1:decimation:end);

end
