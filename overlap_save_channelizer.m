function [output] = overlap_save_channelizer(data, freqs, decimations, F_S, fft_size)

output = cell(length(freqs), 1)

% Compute FFT
data_fft = fft(buffer(data, fft_size, (length(filt) - 1)), [], 1);
size(data_fft)

for idx = 1:length(freqs)
  freq = freqs(idx);
  decimation = decimations(idx);
  
  %% DESIGN THE FILTERS
  disp('Designing the filters...')
  filt_time = design_filter(F_S, decimation);
  % Zero pad so that P-1 is a multiple of D
  %filt = [filt zeros(1, decimation - mod(length(filt) - 1, decimation))];
  % TODO properly round this to nearest integer multiple
  filt_time = [filt_time zeros(1, 21)];
  filt_fft = fft(filt_time, fft_size);

  V = round(fft_size/(length(filt_time) - 1));

  % Rotate FFT to desired center freq
  num_bins = -round(fft_size*freq/F_S/V)*V;
  rot_fft = circshift(data_fft, num_bins, 1);
  
  % Filter FFT
  filt_data_fft = zeros(size(rot_fft));
  for i = 1:size(rot_fft, 2)
      filt_data_fft(:,i) = filt_fft'.*rot_fft(:,i);
  end
  %rot_fft.*repmat(filt_fft', size(rot_fft, 1));
  
  inv_fft = ifft(filt_data_fft, [], 1);
  tmp = buffer(inv_fft(:), fft_size - (length(filt) - 1), -(length(filt) - 1));
  tmp = tmp(:).';
  output{idx} = tmp(1:decimation:end);
end

end
