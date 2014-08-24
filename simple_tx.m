function [ out_samples ] = simple_tx( input_bits, modulation, samps_per_sym, F_S )
RC_ROLLOFF = 0.25;          % Adjusts alpha of the RRC pulse shape

%% Convert the encoded bits to symbols (at complex baseband) %%
modulated_samples = modulate(input_bits, modulation, samps_per_sym);

%% Apply the pulse shaping %%
T = samps_per_sym/F_S; % symbol time
pulse_shape = generate_pulse_shaping_filt(F_S, T, RC_ROLLOFF);
out_samples = apply_filt(modulated_samples, pulse_shape);

end

