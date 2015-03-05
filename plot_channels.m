function plot_channels(channels, f_s, varargin)
    titles = cell(length(channels), 1);
    show_axis_labels = 1;
    ymin = 'dynamic';
    ymax = 'dynamic';

    varargin

    for i = 1:2:length(varargin)
        if length(varargin) < i + 1
            break;
        end
        if strcmp(varargin{i}, 'AxisLabels')
            show_axis_labels = varargin{i+1};
        elseif strcmp(varargin{i}, 'Titles')
            titles = varargin{i+1};
        elseif strcmp(varargin{i}, 'YMin')
            ymin = varargin{i+1};
        elseif strcmp(varargin{i}, 'YMax')
            ymax = varargin{i+1};
        end
    end


    num_channels = length(channels);
    if num_channels == 2
        factors = [1 2];
    else
        factors = factor(num_channels);
        if length(factors) == 1
            if max(factors(1) == [3 5])
                factors = [1 factors];
            else
                factors = factor(num_channels + 1);
            end
        end
        while length(factors) > 2
            [val, idx] = min(factors);
            factors(idx) = [];
            [o_val, o_idx] = min(factors);
            factors(o_idx)  = val*o_val;
        end
    end

    plot_min = 100;
    plot_max = -100;
    figure;
    for i=1:num_channels
        subplot(factors(1), factors(2), i);
        plot_spectrum(channels{i}, f_s(i), 1024, show_axis_labels);
        this_limit = ylim;
        if this_limit(1) < plot_min
            plot_min = this_limit(1);
        end
        if this_limit(2) > plot_max
            plot_max = this_limit(2);
        end
        title(titles{i});
    end

    if strcmp(ymin, 'dynamic')
        ymin = plot_min;
    end
    if strcmp(ymax, 'dynamic')
        ymax = plot_max;
    end

    for i=1:num_channels
        subplot(factors(1), factors(2), i);
        ylim([ymin ymax]);
    end
end
