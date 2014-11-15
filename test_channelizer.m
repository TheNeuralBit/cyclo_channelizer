close all;
default_config;

numbits = 2048*10;
input_bits = text_file_to_binary('tale_of_two_cities.txt');
input_bits = input_bits(1:numbits);
PN = 10;
bauds = [F_S/4 F_S/4];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);
t = 0:(1/F_S):((length(tx)-1)/F_S);
tx = tx.*exp(1i.*pi.*5E6.*t); %Perform frequency shift 

plot_spectrum(tx, F_S*UP);

%bits = MyReceiver(tx);
%binary_to_text_file(bits, 'test_0.txt');


channels = channelizer(tx, length(bauds), F_S*UP);

%% Plot results
disp('Plotting results...')
for i=1:length(bauds)
    figure;
    plot_spectrum(channels(i,:), F_S*UP/length(bauds));
    SAMPLES_PER_SYMBOL = F_S/bauds(i)
    recompute_configuration;
    bits = MyReceiver(channels(i,:));
    fname = sprintf('test_%d.txt', i);
    binary_to_text_file(bits, fname);
end

disp('Done.')
