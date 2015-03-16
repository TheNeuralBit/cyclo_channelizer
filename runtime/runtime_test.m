function [ runtime ] = runtime_test(type, num_trials)
    close all
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
    
    plot_spectrum(tx, F_S, 2^14);
    
    output_samps_per_sym = 4;
    bauds_to_check = sort(unique(bauds));
    
    runtimes = zeros(1, num_trials);
    for i=1:num_trials
        % TODO Make sure channelizer actually demodulated the correct
        % frequencies
        if strcmp(type, 'POLYPHASE')
            tic;
            [channels output_f_s freqs] = cyclo_and_polyphase(tx, bauds_to_check, output_samps_per_sym);
            runtimes(i) = toc;
        elseif strcmp(type, 'OVERLAP')
            tic;
            [channels output_f_s freqs] = cyclo_and_overlap_save(tx, bauds_to_check, output_samps_per_sym);
            runtimes(i) = toc;
        end
    
    end
    runtime = mean(runtimes)
end
