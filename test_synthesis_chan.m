close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);

PN = 40;
D = 8;
bauds = [1/4, 1/8, 1/16, 1/4, 1/8, 1/16, 1/4].*F_S./4;
UP = length(bauds);

freqs = -F_S/2:F_S/D:F_S/2;
freqs = freqs(1:end-2) + F_S/D;

tx = gen_test_sig(input_bits, PN, bauds, freqs);

plot_spectrum(tx, F_S);
%perfect_bits = MyReceiver(tx);
%binary_to_text_file(perfect_bits, 'perfect.bits');
%sum(abs(input_bits-perfect_bits'))/numbits*100

num_splits = 8;
channels = analysis_channelizer(tx, num_splits, F_S);
split_f_s = F_S/num_splits;
plot_channels(channels, repmat([split_f_s], num_splits, 1));


output = synthesis_channelizer(channels(1:2), split_f_s);
out_f_s = split_f_s*2;

t = 0:(1/out_f_s):((length(output)-1)/out_f_s);
output = output.*exp(1i.*2.*pi.*split_f_s/2.*t); %Perform frequency shift 

figure;
plot_spectrum(output, F_S);

%reconstructed_bits = MyReceiver(output);
%binary_to_text_file(reconstructed_bits, 'reconstructed.bits');
%sum(abs(input_bits-reconstructed_bits(1:numbits)'))/numbits*100
