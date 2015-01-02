close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 40;
bauds = [1/8 1/16 1/4].*F_S./4;
UP = length(bauds);

freqs = (-(length(bauds) - 1)/2:(length(bauds) - 1)/2).*(F_S/(length(bauds) + 1))

tx = gen_test_sig(input_bits, PN, bauds, freqs);

plot_spectrum(tx, F_S);

output_samps_per_sym = 4;
bauds_to_check = sort(unique(bauds))
channels = cyclo_and_overlap_save(tx, bauds_to_check, output_samps_per_sym, F_S);
plot_channels(channels, ones(length(channels), 1).*(F_S*4));

fprintf('\n');
disp('Demodulating Each Channel');
disp('-------------------------');
SAMPLES_PER_SYMBOL = output_samps_per_sym;
recompute_configuration;
for i=1:length(channels)
    fprintf('CHANNEL %d\n', i);

    bits = MyReceiver(channels{i});
    fname = sprintf('channel_%d.bits', i);
    fprintf('Writing %s...\n', fname);
    % Trim down to numbits, because we know anything after that is garbage
    % in the higher baud rate signals
    if length(bits) > numbits
        bits = bits(1:numbits);
    end
    binary_to_text_file(bits, fname);
end
