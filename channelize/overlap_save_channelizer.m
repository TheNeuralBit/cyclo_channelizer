function [output] = overlap_save_channelizer(data, freqs, decimations, F_S, fft_size)

dec_lcm = lcms(decimations);
%dec_lcm = 32;

output = cell(length(freqs), 1);

longest_filt = design_filter(F_S, max(decimations));
P = length(longest_filt);

% TODO: allow frequency shifting in EITHER time or frequency
% If we are frequency shifting in the time domain then
% we only need to ensure that P is a multiple of the decimation
%P = P + dec_lcm - (mod((P - 1) - 1, dec_lcm) + 1);

% If shifting in the frequency domain we need to be a little more
% ensure that V is an integer
P = ldf(P-1, fft_size) + 1;

V = round(fft_size/(P - 1));

% Compute FFT
data_fft = fft(buffer(data, fft_size, (P - 1)), [], 1);

for idx = 1:length(freqs)
  freq = freqs(idx);
  decimation = decimations(idx);
  
  %% DESIGN THE FILTERS
  disp('Designing the filter...')
  filt_time = design_filter(F_S, decimation);
  % Zero pad so that filter is length P-1
  if length(filt_time) < P
      filt_time = [filt_time zeros(1, P - length(filt_time))];
  end
  filt_fft = fft(filt_time, fft_size);

  % Rotate FFT to desired center freq
  disp('Rotating FFT...')
  num_bins = -round(fft_size*freq/F_S/V)*V;
  rot_fft = circshift(data_fft, num_bins, 1);
  
  % Filter FFT
  disp('Filtering FFT...')
  filt_data_fft = zeros(size(rot_fft));
  for i = 1:size(rot_fft, 2)
      filt_data_fft(:,i) = filt_fft'.*rot_fft(:,i);
  end
  %rot_fft.*repmat(filt_fft', size(rot_fft, 1));
  
  disp('Decimating and Returning to Time Domain...')
  inv_fft = ifft(filt_data_fft, [], 1);
  tmp = buffer(inv_fft(:), fft_size - (P - 1), -(P - 1));
  tmp = tmp(:).';
  output{idx} = tmp(1:decimation:end);
end

end

function [rtrn] = ldf(k, n)
% ldf returns the lowest divisor of n that is greater than k
    if mod(n, k) == 0
        rtrn = k;
    elseif 2*k > n
        rtrn = n;
    else
        rtrn = ldf(k+1, n);
    end
end
