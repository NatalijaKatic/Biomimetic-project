%% Colormaps
% create a default color map ranging from red to light pink
len = 256;
white = [1, 1, 1];
red = [209, 87, 0]/255;
Orange = [linspace(red(1),white(1),len)', linspace(red(2),white(2),len)', linspace(red(3),white(3),len)'];
% Orange = flip(Orange);
channel = [32 24 16 8 31 23 15 7 ...
            30 22 14 6 29 21 13 5 ...
            28 20 12 4 27 19 11 3 ...
            26 18 10 2 25 17 9 1];

channel_map = [32 28 24 20 16 12 8 4;...
                31 27 23 19 15 11 7 3;...
                30 26 22 18 14 10 6 2;...
                29 25 21 17 13 9 5 1];
            
len = 128;
white = [1, 1, 1];
red = [209, 87, 0]/255;
blue = [0, 87, 209]/255;
red1 = [linspace(red(1),white(1),len)', linspace(red(2),white(2),len)', linspace(red(3),white(3),len)'];
blue1 = [linspace(white(1),blue(1),len)', linspace(white(2),blue(2),len)', linspace(white(3),blue(3),len)'];
my_colormap = [flip(blue1); flip(red1)];


%% Select high SNR channels of DRG for each stimulation
[~,SNR_FAI] = sort(SNR_noArt(1,:), 'descend');
[~,SNR_FAII] = sort(SNR_noArt(2,:), 'descend');
[~,SNR_SAI] = sort(SNR_noArt(5,:), 'descend');
[~,SNR_SAII] = sort(SNR_noArt(3,:), 'descend');
[~,SNR_var] = sort(SNR_noArt(4,:), 'descend');
[~,SNR_const] = sort(SNR_noArt(6,:), 'descend');
[~,SNR_NT] = sort(SNR_noArt(7,:), 'descend');

%% compute amplitude distribution using directly all amplitudes only high SNR NT channels
stimNames = {'FAI', 'FAII', 'SAI', 'SAII', 'SAI+FAII', '50Hz', 'Natural touch'};

ch=12;

data  = [reshape(LFP_FAI(SNR_NT(1:ch),:), 1, []); reshape(LFP_FAII(SNR_NT(1:ch),:),1,[]); reshape(LFP_SAI(SNR_NT(1:ch),:),1,[]); reshape(LFP_SAII(SNR_NT(1:ch),:),1,[]); reshape(LFP_var(SNR_NT(1:ch),:),1,[]); reshape(LFP_const(SNR_NT(1:ch),:),1,[]); reshape(LFP_down(SNR_NT(1:ch),:),1,[])];

data2 = [reshape(LFP_cat2NT1(SNR_NT(1:ch),:), 1, [])];

%%
set(gca,'fontsize', 24)

figure
hold on
NTdown = histcounts(data(7,:),'BinEdges',range(1):0.5:range(2));
var = histcounts(data(5,:),'BinEdges',range(1):0.5:range(2));
const = histcounts(data(6,:),'BinEdges',range(1):0.5:range(2));
control = histcounts(data2(1,:), 'BinEdges',range(1):0.5:range(2));

bar3 = bar(range(1)+0.5:0.5:range(2), const/sum(const), 'FaceColor', myColormap(3,:));
bar1 = bar(range(1)+0.5:0.5:range(2), NTdown/sum(NTdown), 'FaceColor', myColormap(1,:));
bar2 = bar(range(1)+0.5:0.5:range(2), var/sum(var), 'FaceColor', myColormap(2,:));
bar4 = bar(range(1)+0.5:0.5:range(2), control/sum(control), 'FaceColor', myColormap(4,:));
alpha(0.7)

xlabel('Counts')
ylabel('Probability')
legend([bar1 bar2 bar3 bar4],'Natural touch', 'Biomimetic', '50 Hz', 'Control (Cat2)', 'box', 'off')
set(gca,'fontsize', 24)

%%

KLNatBio=kldiv(1:60,var/sum(var)+eps,NTdown/sum(NTdown)+eps);
KLNatTon=kldiv(1:60,const/sum(const)+eps,NTdown/sum(NTdown)+eps);
KL2Nat=kldiv(1:60,control/sum(control)+eps,NTdown/sum(NTdown)+eps);

