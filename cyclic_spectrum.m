function [cyc_spec] = cyclic_spectrum(data, alpha, fft_size, F_S)

%cyc_spec = zeros(1, fft_size);
%t = 0:1/F_S:(length(data) - 1)/F_S;
%for idx = 1:500
%    cyc_spec = cyc_spec + ...
%                conv( ...
%    fftshift(fft(data(idx:idx+fft_size-1).*exp( j*2*pi*alpha/2*t(idx:idx+fft_size-1)))), ...
%    fftshift(fft(data(idx:idx+fft_size-1).*exp(-j*2*pi*alpha/2*(idx:idx+fft_size-1)))), ...
%               'same' )/500;
%end
t = 0:1/F_S:(length(data) - 1)/F_S;
cyc_spec = cpsd(data.*exp( j*2*pi*alpha/2*t), ...
                data.*exp(-j*2*pi*alpha/2*t), ...
                [], fft_size/2, fft_size);
cyc_spec = fftshift(cyc_spec);
%t = 0:1/F_S:(fft_size - 1)/F_S;
%s_right = data(1:fft_size).*exp( j*2*pi*alpha/2*t);
%s_left  = data(1:fft_size).*exp(-j*2*pi*alpha/2*t);
%cyc_spec = fftshift(fft(s_left)).*conj(fftshift(fft(s_right)));

end
