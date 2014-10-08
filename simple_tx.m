function [ out_samples ] = simple_tx( input_bits, modulation, samps_per_sym, F_S , RC_ROLLOFF)

%% Convert the encoded bits to symbols (at complex baseband) %%
modulated_samples = modulate(input_bits, modulation, samps_per_sym);

%% Apply the pulse shaping %%
T = samps_per_sym/F_S; % symbol time
if RC_ROLLOFF < 0
    pulse_shape = ones(1, samps_per_sym)./samps_per_sym;
else
    pulse_shape = generate_pulse_shaping_filt(F_S, T, RC_ROLLOFF);
end
out_samples = apply_filt(modulated_samples, pulse_shape);

end

