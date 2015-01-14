close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 40;
bauds = [1/8, 1/16, 1/4].*F_S./4;
UP = length(bauds);

freqs = -F_S/2:F_S/4:F_S/2;
freqs = freqs(1:end-2) + F_S/4;

tx = gen_test_sig(input_bits, PN, bauds, freqs);

plot_spectrum(tx, F_S);

output_samps_per_sym = 4;
bauds_to_check = sort(unique(bauds))
CYCLO_PEAK_MIN_SPACING = F_S/4/2;
[channels output_f_s freqs] = cyclo_and_overlap_save(tx, bauds_to_check, output_samps_per_sym);
titles = cell(size(freqs));
for i=1:length(freqs)
    titles{i} = sprintf('%.3f MHz', freqs(i)/1E6);
end
plot_channels(channels, output_f_s, 'Titles', titles);

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
