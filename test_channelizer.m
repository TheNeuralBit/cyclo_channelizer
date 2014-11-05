close all;
configuration;

numbits = 2048*100;
input_bits = randn(1, numbits)<0;
PN = 40;
bauds = [F_S/8, F_S/16, F_S/4, F_S/16];
UP = length(bauds);

tx = gen_test_sig(input_bits, PN, bauds);
t = 0:(1/F_S):((length(tx)-1)/F_S);
tx = tx.*exp(1i.*pi.*2.5E6.*t); %Perform frequency shift 

plot_spectrum(tx, F_S*UP);

channels = channelizer(tx, length(bauds), F_S*UP);

%% Plot results
disp('Plotting results...')
figure(3);
for i=1:length(bauds)
    subplot(2, 2, i);
    plot_spectrum(channels(i, 1:1024), F_S*UP/length(bauds));
end

disp('Done.')
