function [ runtime ] = runtime_test(type, num_trials, num_signals)
    close all
    default_config;
    
    numbits = 2048*10;
    input_bits = text_file_to_binary('tale_of_two_cities.txt');
    input_bits = input_bits(1:numbits);
    PN = 40;
    bauds = repmat([1/32].*F_S./4, 1, num_signals)
    UP = length(bauds);

    offset = F_S/num_signals/2;
    freqs = linspace(-F_S/2 + offset, F_S/2 - offset, num_signals)
    %freqs = freqs(2:end) + F_S/num_signals/2;
    %freqs = freqs - F_S/2;
    
    tx = gen_test_sig(input_bits, PN, bauds, freqs);
    
    plot_spectrum(tx, F_S, 2^14);
    
    output_samps_per_sym = 4;
    bauds_to_check = sort(unique(bauds));

    %mypool = parpool(2);
    
    runtimes = zeros(1, num_trials);
    for i=1:num_trials
        % TODO Make sure channelizer actually demodulated the correct
        % frequencies
        if strcmp(type, 'POLYPHASE')
            tic;
            [channels output_f_s detected_freqs] = cyclo_and_polyphase(tx, bauds_to_check, output_samps_per_sym);
            runtimes(i) = toc;
        elseif strcmp(type, 'OVERLAP')
            tic;
            [channels output_f_s detected_freqs] = cyclo_and_overlap_save(tx, bauds_to_check, output_samps_per_sym);
            runtimes(i) = toc;
        end
        if length(channels) ~= length(freqs)
            disp('detected wrong number of channels!')
            detected_freqs
            freqs
        else
            distance_metric = mean(abs(sort(detected_freqs) - freqs));
            if  distance_metric > 10E3
                disp('!!!!!!! OH CRAP !!!!!!!!!!!!!!!');
                distance_metric
                detected_freqs
                freqs
            end
        end
    end
    runtime = mean(runtimes);
    %delete(gcp);
end
