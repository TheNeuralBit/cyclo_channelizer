function [ out_samples ] = simple_tx( input_bits )
%% Load the config file to adjust parameters %%
configuration;

%% Convert the encoded bits to symbols (at complex baseband) %%
modulated_samples = modulate(input_bits, MODULATION, SAMPLES_PER_SYMBOL);

%% Apply the pulse shaping %%
out_samples = apply_filt(modulated_samples, PULSE_SHAPE);

end

