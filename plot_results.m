function plot_results(glob)
    close all;
    
    colors = ['-ks'; '-b*'; '-ro'; '-gx'; '-m+'; '-cv'];

    results_dir = [pwd '/results/'];
    files = dir([results_dir glob '.mat']);
    legend_data = cell(1,length(files));

    for idx = 1:length(files)
        filename = files(idx).name;
        legend_data(idx) = {filename};
        load([results_dir, filename])

        figure(1);
        if idx > 1
            hold on;
        end
        plot(num_signals, runtimes, colors(mod(idx - 1, length(colors)) + 1,:));
        if idx > 1
            hold off;
        end
    end

    figure(1);
    hold on;
    legend(legend_data);
    title('Runtime')
    xlabel('Number of Signals')
    ylabel('Average Runtime (s)')
    hold off;
end
