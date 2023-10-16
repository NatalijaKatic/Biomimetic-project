
%% --------------------LFP analysis--------------------------
homeFolder = pwd;

filterPeaks = [150 250];% 2 frequency peaks that have noise for sure (peak present when taking background signal)
disp('Filtered peaks: ')
disp(filterPeaks)

for channel=1:32 
    
    cd('Constant frequency')
    load('LFP_constFreq_ch'+string(channel)+'.mat', 'mean_LFP_const')
    LFP_const(channel,:) = notchFilter(mean_LFP_const, filterPeaks);

    cd(strcat(homeFolder,'/Natural touch'))
    load('LFP_NT_ch'+string(channel)+'.mat', 'mean_LFP_down', 'mean_LFP_up')
    LFP_down(channel,:) = mean_LFP_down;
    LFP_up(channel,:) = notchFilter(mean_LFP_up, filterPeaks);

    cd(strcat(homeFolder,'/Variable frequency'))
    load('LFP_varFreq_ch'+string(channel)+'.mat', 'mean_LFP_var')
    LFP_var(channel,:) = notchFilter(mean_LFP_var, filterPeaks);

    cd(strcat(homeFolder,'/FAI'))
    load('LFP_FAI_ch'+string(channel)+'.mat', 'mean_LFP_FAI')
    LFP_FAI(channel,:) = notchFilter(mean_LFP_FAI, filterPeaks);

    cd(strcat(homeFolder,'/FAII'))
    load('LFP_FAII_ch'+string(channel)+'.mat', 'mean_LFP_FAII')
    LFP_FAII(channel,:) = notchFilter(mean_LFP_FAII, filterPeaks);

    cd(strcat(homeFolder,'/SAI'))
    load('LFP_SAI_ch'+string(channel)+'.mat', 'mean_LFP_SAI')
    LFP_SAI(channel,:) = notchFilter(mean_LFP_SAI, filterPeaks);

    cd(strcat(homeFolder,'/SAII'))
    load('LFP_SAII_ch'+string(channel)+'.mat', 'mean_LFP_SAII')
    LFP_SAII(channel,:) = notchFilter(mean_LFP_SAII, filterPeaks);

    cd(strcat(homeFolder,'/Prop'))
    load('LFP_prop_ch'+string(channel)+'.mat', 'mean_LFP_prop')
    LFP_proprio(channel,:) = notchFilter(mean_LFP_prop, filterPeaks);
    
    cd(homeFolder)
end
clear mean*

%% Compute correlation between LFP (compare first channel to all the others)

len = 128;
white = [1, 1, 1];
% red = [222, 122, 0]/255;
% blue = [27, 0, 204]/255;
red = [209, 87, 0]/255; %[255, 20, 20]/255; 
blue = [0, 87, 209]/255;%[0 0 0]/255; %
red1 = [linspace(red(1),white(1),len)', linspace(red(2),white(2),len)', linspace(red(3),white(3),len)'];
blue1 = [linspace(white(1),blue(1),len)', linspace(white(2),blue(2),len)', linspace(white(3),blue(3),len)'];
my_colormap = [flip(blue1); flip(red1)];

for i=1:32
    tmp = corrcoef(LFP_FAI(1,:), LFP_FAI(i,:));
    depth_corr(1,i) = tmp(1,2);
    
    tmp = corrcoef(LFP_FAII(1,:), LFP_FAII(i,:));
    depth_corr(2,i) = tmp(1,2);
    
    tmp = corrcoef(LFP_SAI(1,:), LFP_SAI(i,:));
    depth_corr(3,i) = tmp(1,2);

    tmp = corrcoef(LFP_SAII(1,:), LFP_SAII(i,:));
    depth_corr(4,i) = tmp(1,2);
    
    tmp = corrcoef(LFP_var(1,:), LFP_var(i,:));
    depth_corr(5,i) = tmp(1,2);
    
    tmp = corrcoef(LFP_const(1,:), LFP_const(i,:));
    depth_corr(6,i) = tmp(1,2);
    
    tmp = corrcoef(LFP_down(1,:), LFP_down(i,:));
    depth_corr(7,i) = tmp(1,2);
    
    tmp = corrcoef(LFP_proprio(1,:), LFP_proprio(i,:));
    depth_corr(8,i) = tmp(1,2);
end

figure
heat = heatmap(depth_corr(5:7,:)','CellLabelColor','none');
heat.Colormap = my_colormap;
heat.ColorLimits = [-1 1];
heat.XDisplayLabels = {'Biomimetic','50Hz','Natural touch'}; %{'FAI','FAII','SAI','SAII','SAI+FAII','50Hz','Natural touch'};%,'Proprioception'};%
% title('L6 - LFP correlation (Channel1: reference)')
set(gca,'fontsize', 18)
heat.InnerPosition(1) = .35;
heat.InnerPosition(3) = .3;
heat.InnerPosition(4) = .8;
heat.InnerPosition(2) = .17;
% compare single stimulation patterns by computing mean and std of the corr coeff along all channels
% (stimualtion wise)

% depth_corr_mean = mean(abs(depth_corr),2);
% depth_corr_std  = std(abs(depth_corr),0,2);


%% Compare variability in correlation for each stimulation
[p, tbl, stats] = kruskalwallis(abs(depth_corr(:,2:end)'));
[c,m,h,nms] = multcompare(stats);
tbl = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"])

figure
boxplot(abs(depth_corr(:,2:end)'))

% errorbar(1:8, depth_corr_mean, depth_corr_std, 'vertical', 'Color', 'b', 'Marker', 'o', 'Markersize', 6, 'CapSize', 2, 'linestyle', 'none')
xticklabels({'FAI','FAII','SAI','SAII','Biomimetic','50Hz','Natural touch','Proprioception'})
xlim([0.5 7.5]) %xlim([4.5 7.5])
ylim([0 1.3])
ylabel('abs(Correlation)')
% title('L6 - Std of LFP correlation along electorde')
lineWidth = 1;
line([5.1 5.9] ,[1.15 1.15], 'color', 'k', 'linewidth', lineWidth)
line([6.1 6.9] ,[1.15 1.15], 'color', 'k', 'linewidth', lineWidth)
line([5.1 6.9] ,[1.2 1.2], 'color', 'k', 'linewidth', lineWidth)

line([6.1 6.1], [1.14 1.16], 'color', 'k', 'linewidth', lineWidth)
line([6.9 6.9], [1.14 1.16], 'color', 'k', 'linewidth', lineWidth)

line([5.1 5.1], [1.14 1.16], 'color', 'k', 'linewidth', lineWidth)
line([5.9 5.9], [1.14 1.16], 'color', 'k', 'linewidth', lineWidth)

line([5.1 5.1], [1.19 1.21], 'color', 'k', 'linewidth', lineWidth)
line([6.9 6.9], [1.19 1.21], 'color', 'k', 'linewidth', lineWidth)

text(5.35, 1.16, '***', 'fontsize', 14)
text(6.35, 1.16, '***', 'fontsize', 14)
text(5.85, 1.21, '***', 'fontsize', 14)


%% CSD analysis
CSDoutput50Hz=load('CSDoutput50Hz.mat');
CSDoutputBiomimetic=load('CSDoutputBiomimetic.mat');
CSDoutputNatural=load('CSDoutputNatural.mat');
%%
for i=1:32
    korel50HzNat(i)=corr(CSDoutput50Hz(:,i),CSDoutputNatural(:,i));
    korelBiomimNat(i)=corr(CSDoutputBiomimetic(:,i),CSDoutputNatural(:,i));
    korelBiomim50Hz(i)=corr(CSDoutputBiomimetic(:,i),CSDoutput50Hz(:,i));
end
%%
for k=1:100
    r=randperm(32);
    for i=1:32
        korelRandBiomimNat(k,i)=corr(CSDoutputBiomimetic(:,r(i)),CSDoutputNatural(:,i));
        korelRand50HzNat(k,i)=corr(CSDoutput50Hz(:,r(i)),CSDoutputNatural(:,i));
        korelRand50HzBiomimetic(k,i)=corr(CSDoutputBiomimetic(:,r(i)),CSDoutput50Hz(:,i));
    end
end
korelRandBiomimNatAvg=mean(korelRandBiomimNat,1);
korelRand50HzNatAvg=mean(korelRand50HzNat,1);
korelRand50HzBiomim=mean(korelRand50HzBiomimetic,1);
%%
c=redblue();
clims=[-0.5 0.5];
imagesc(korel50HzNat', clims);
colormap(brewermap(256,'*RdBu'));
colorbar();
%%
figure;
imagesc(korelBiomimNat',clims);
colormap(brewermap(256,'*RdBu'));
colorbar();
%%
figure;
imagesc(korelBiomim50Hz',clims);
colormap(brewermap(256,'*RdBu'));
colorbar();

%%
hBiomimNat=histogram(korelBiomim50Hz,7,'Normalization','probability');
xlim([-0.5 0.5]);
ylim([0 0.4]);
%%
h50HzNat=histogram(korel50HzNat,7,'Normalization','probability');
xlim([-0.5 0.5]);
ylim([0 0.4]);
%%
h50HzBiomim=histogram(korelBiomimNat,7,'Normalization','probability');
xlim([-0.5 0.5]);
ylim([0 0.4]);
%%
ecdf(korel50HzNat)
hold on
ecdf(korelRand50HzNatAvg);
xlim([-0.5 0.5]);
legend('Nat','rand');
%%
ecdf(korelBiomimNat);
hold on
ecdf(korelRandBiomimNatAvg);
xlim([-0.5 0.5]);
legend('Nat','rand');
hold off

%%
ecdf(korelBiomim50Hz);
hold on
ecdf(korelRand50HzBiomimAvg);
xlim([-0.5 0.5]);
legend('Nat','rand');
hold off

%%
[coef50HzBiomim,p50HzBiomim]=corrcoef(CSDoutputBiomimetic(:,i),CSDoutput50Hz(:,i));
[coef50HzNat,p50HzNat]=corrcoef(CSDoutputNatural(:,i),CSDoutput50Hz(:,i));
[coefBiomimNat,pBiomimNat]=corrcoef(CSDoutputBiomimetic(:,i),CSDoutputNatural(:,i));