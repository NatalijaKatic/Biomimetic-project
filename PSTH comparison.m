load start.mat
load stimuli.mat

stimType = ["FA1", "FA2", "SA2", "Cumulative", "SA1", "50Hz", "Real touch", "Propiception"]

%%
brBin=200;
stim_hist=load('hist_Cumulative.mat');
stim_int=interp1(1:brBin/50:brBin,stim_hist,1:brBin);
stim_int(brBin)=25;
if(brBin>100)
    stim_int(brBin-1)=25;
end
if(brBin>150)
    stim_int(brBin-2)=25;
end
load(['DRGspikes.mat'])
PSTHBioDRG=customPSTH(brBin, index, 23, stimuli, start, stimType, 4);
load(['L6spikes.mat'])
PSTHBioL6=customPSTH(brBin, index, 16, stimuli, start, stimType, 4);
L6Stim=xcorr(PSTHBioL6,stim_int);
DRGStim=xcorr(PSTHBioDRG,stim_int);
DRGL6=xcorr(PSTHBioDRG,PSTHBioL6);
figure();hold on;plot(L6Stim,'r',linewidth=2);plot(DRGL6,'k',linewidth=2);plot(DRGStim,'b',linewidth=2);hold off;

binovi=50:10:200;
for i=1:16
    load(['DRGspikes.mat'])
    PSTHBioDRG=customPSTH(binovi(i), index, 23, stimuli, start, stimType, 4);
    load(['L6spikes.mat'])
    PSTHBioL6=customPSTH(binovi(i), index, 16, stimuli, start, stimType, 4);
    stim_hist=load('hist_Cumulative.mat');
    stim_int=interp1(1:binovi(i)/50:binovi(i),stim_hist,1:binovi(i));
    stim_int(binovi(i))=25;
    if(binovi(i)>100)
        stim_int(binovi(i)-1)=25;
    end
    if(binovi(i)>150)
        stim_int(binovi(i)-2)=25;
    end
    [r,p] = corrcoef(PSTHBioDRG,PSTHBioL6);
    R(i)=r(1,2);
    pDRGL6(i)=p(1,2);
    [r2,p] = corrcoef(PSTHBioDRG,stim_int);
    RstimDRG(i)=r2(1,2);
    pstimDRG(i)=p(1,2);
    [r3,p] = corrcoef(PSTHBioL6,stim_int);
    RstimL6(i)=r3(1,2);
    pstimL6(i)=p(1,2);

end


