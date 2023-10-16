function PSTH=customPSTH(bins_n, spikes, channel, stimuli, start, stimType, experiment)

% compute psth with custom number of bars
stimulus = stimuli{experiment}{1};
% cd ('figures/Rasterplots/' + string(stimType{experiment}))


if experiment == 7 % give start as the vector of starting point, not the array with all stimulations    
    length_trial = 30000;
    tshift = 800;
    
    for i=1:length(start)
        index_bottom = spikes < start(i)/30 + tshift + length_trial/30;
        index_top = spikes > start(i)/30 + tshift;

        index = (index_bottom == index_top);

        spikes_trial{i} = spikes(index);
        spikes_trial{i} = spikes_trial{i}/1000 - (start(i)/30+tshift)/1000; %align to 0 each trial
    end
    
    % --------------------- PSTH plot in bottom subplot ------------------
    
    sum_tmp = zeros(1,bins_n);
    for j=1:length(start)
        sum_tmp = sum_tmp + histcounts(spikes_trial{j}, bins_n, 'BinLimits', [0,(length_trial/30000)]);
%         stim_bin(1,:) = stim_bin(1,:) + histcounts(find(stimuli{1,6}{1}(start{experiment}:start{experiment}+72007)), bins_n, 'BinLimits', [0,72007]);
 
    end
    PSTH=sum_tmp/length(start); %divide by the number of trials
    
    % transform PSTH from spikes to spikes/s
    bin_time = length_trial/30000 /bins_n;
    PSTH = PSTH/bin_time;
    
    
% Plot figure
    figure
    title('PSTH')
    x = (1:bins_n)*bin_time;
    bar(x, PSTH, 'EdgeColor','none', 'FaceColor',[0 0.4470 0.7410])
    ylabel('Spk/s')
    xlabel('Time [s]')
end


if experiment == 8
    % Compute raster plot
    for i=1:6
        index_bottom = spikes < start{experiment}(i)/30;
        index_top = spikes > start{experiment}(i)/30+2500;

        index = (index_bottom == index_top);

        spikes_trial{i} = spikes(index);
        spikes_trial{i} = spikes_trial{i}/1000 - (start{experiment}(i)/30)/1000; %align to 0 each trial
    end
    
    % Compute PSTH
    
    sum_tmp = zeros(1,bins_n);
    for j=1:6
        sum_tmp = sum_tmp + histcounts(spikes_trial{j}, bins_n, 'BinLimits', [0,60000/30000]);
%         stim_bin(1,:) = stim_bin(1,:) + histcounts(find(stimuli{1,6}{1}(start{experiment}:start{experiment}+72007)), bins_n, 'BinLimits', [0,72007]);

    end
    PSTH=sum_tmp/6.; %divide by the number of trials
    
    % transform PSTH from spikes to spikes/s
    bin_time = 2 /bins_n; %2seconds divided by bin number
    PSTH = PSTH/bin_time;
    
    %--------------------Plot result if wanted----------------------------
    % Plot figure
    figure
    title('PSTH')
    x = (1:bins_n)*bin_time;
    bar(x, PSTH, 'EdgeColor','none', 'FaceColor',[0 0.4470 0.7410])
    ylabel('Spk/s')
    xlabel('Time [s]')
end

if experiment == 6
    
    % Compute raster plot
    for i=1:30
        index_bottom = spikes < start{experiment}/30+i*60000/30;
        index_top = spikes > start{experiment}/30+(i-1)*60000/30;

        index = (index_bottom == index_top);

        spikes_trial{i} = spikes(index);
        spikes_trial{i} = spikes_trial{i}/1000 - (start{experiment}/30+(i-1)*60000/30)/1000; %align to 0 each trial
    end
    
    % Compute PSTH
    
    sum_tmp = zeros(1,bins_n);
    for j=1:30
        sum_tmp = sum_tmp + histcounts(spikes_trial{j}, bins_n, 'BinLimits', [0,60000/30000]);
%         stim_bin(1,:) = stim_bin(1,:) + histcounts(find(stimuli{1,6}{1}(start{experiment}:start{experiment}+72007)), bins_n, 'BinLimits', [0,72007]);

    end
    PSTH=sum_tmp/30.; %divide by the number of trials
    
    % transform PSTH from spikes to spikes/s
    bin_time = 2 /bins_n; %2seconds divided by bin number
    PSTH = PSTH/bin_time;
    
    
    
    % Plot figure
    figure
    title('PSTH')
    x = (1:bins_n)*bin_time;
    bar(x, PSTH, 'EdgeColor','none', 'FaceColor',[0 0.4470 0.7410])
    ylabel('Spk/s')
    xlabel('Time [s]')
    
end

if experiment < 6
    % compute raster plot
    for i=1:90
        index_bottom = spikes < start{experiment}(i)/30+60000/30;
        index_top = spikes > start{experiment}(i)/30;

        index = (index_bottom == index_top);

        spikes_trial{i} = spikes(index);
        spikes_trial{i} = spikes_trial{i}/1000 - start{experiment}(i)/30000; %align to 0 each trial
    end
    
    % Compute PSTH
    
    sum_tmp = zeros(1,bins_n);
    for j=1:90
        sum_tmp = sum_tmp + histcounts(spikes_trial{j}, bins_n, 'BinLimits', [0,60000]/30000);
%         stim_bin(1,:) = stim_bin(1,:) + histcounts(find(stimuli{1,experiment}{1}(start{experiment}(3)-3000 : start{experiment}(3)+63000)), bins_n, 'BinLimits', [0,66000]);

    end
    PSTH = sum_tmp/90; % divide by number of trial to get a normalised spike frequency
    
    % transform PSTH from spikes to spikes/s
    bin_time = 2 /bins_n; %2seconds divided by bin number
    PSTH = PSTH/bin_time;
    
    %------------------Display plot if wanted------------------
    
    % Plot figure
    figure
    title('PSTH')
    x = (1:bins_n)*bin_time;
    bar(x, PSTH, 'EdgeColor','none', 'FaceColor',[0 0.4470 0.7410])
    ylabel('Spk/s')
    xlabel('Time [s]')
        
        
    end
end



% 
% 
% 
% 
% % plot PSTH by itself with bars value as input
% 
% x = linspace(0, 2, size(bars,2));
% 
% figure
% bar(x, bars, 'EdgeColor','none', 'FaceColor',[0 0.4470 0.7410])
% 
% xlim([0.7 1.7])
% xlabel('Time [s]')
% ylabel('Spike/s')
% 
% box off
% set(gca, 'fontSize', 20)
% 
% 
% end