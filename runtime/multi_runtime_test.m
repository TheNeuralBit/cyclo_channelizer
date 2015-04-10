function [ runtimes ] = multi_runtime_test(type, num_trials, num_signals, baud)
    runtimes = zeros(1, length(num_signals));
    for idx = 1:length(num_signals)
        num_sig = num_signals(idx);
        runtimes(idx) = runtime_test(type, num_trials, num_sig, baud);
    end
    filename  = sprintf('results/runtime_%s_%d_%d.mat', type, baud, num_trials);
    disp(filename);
    save(filename, 'runtimes', 'num_signals');
    plot(num_signals, runtimes);
end
