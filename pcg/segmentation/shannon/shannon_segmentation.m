% -------------------------------------------------------------------------
% shannon_segmentation.m
% Author: Changhong Li
% Date: 2024-10-28
% Description: Function to segment the PCG signal using Shannon entropy
% -------------------------------------------------------------------------
function [NewSeg, ShEn] = shannon_segmentation(PCG, Fs)

ShEn = ShannonSmoothEnvelope(PCG, 0.5, Fs);

% plot the Shannon envelope

figure;
plot(ShEn);
xlabel('Time (s)');
ylabel('Amplitude');
title('Shannon Envelope of PCG Signal');


% Derivative of the entropy function to detect the pre-onsets and
% pre-offsets 
N = length(PCG);
Time = (1:N)/Fs;
DerSh = diff(ShEn)'./diff(Time);
DerSh = [0 DerSh]; %Zero padding
% Normalizing the derivative
DerSh = DerSh/max(DerSh);
% Thresholding of the derivative function
for d=1:length(DerSh)
    if DerSh(d)<=0.1 && DerSh(d)>=-0.1
        DerSh(d)=0;
    end
end
DerSh= round(DerSh);

% Position of detected onsets (pre-onsets)
PosOnsets = find(DerSh==1);
%Position of detected offsets (pre-offsets)
PosOffsets = find(DerSh==-1);
% Checking out the distance beweeen onsets and offsets (in miliseconds)
DisOnOff = 1000*((PosOffsets-PosOnsets)/Fs);

% Calculating the difference between possible offsets (in miliseconds) 
OnDif = 1000*(diff(PosOnsets)/Fs);
OffDif = 1000*(diff(PosOffsets)/Fs);
% Checking out wich onsets are too close (<210ms) 1st criteria
CloseOnsets = find(OnDif<=210);
% Checking the offsets wich are too close (<200ms) 2nd criteria
CloseOffsets = find(OffDif<=200);

% Checking the onset-offset intervals of less than 70ms. 3rd criteria
ThCrit = find(DisOnOff<=60);
DisOnOffMax = find(DisOnOff>=150);

% Checking the onsets-offset distance which is too large (more than 750 ms). 
FarOnsets = find(OnDif>=750);


% initialize the pointers
PointerOn = zeros(size(DerSh));
PointerOff = PointerOn;
PointerTh = PointerOff;

IndexOn = PosOnsets(CloseOnsets);
IndexOff = PosOffsets(CloseOffsets+1);
Index3 = PosOffsets(ThCrit);
IndexMaxLen = PosOffsets(DisOnOffMax);
InFarOn = PosOnsets(FarOnsets);

PointerOn(IndexOn) = 1;
PointerOff(IndexOff) = -1;

% The last criteria is to check the amplitude levels of segments detected
% by the other 3 criterias

% a) Detecting the union of two close onsets and offsets
OnUOff = ismember(CloseOnsets,CloseOffsets);
%OnUOff = [CloseOnsets CloseOffsets];
% Location of all onsets and onsets detected too close
OnUOff = CloseOnsets(OnUOff==1);
% Location of all onsets/offsets too close, and too short

OnOffSh = ismember(OnUOff,ThCrit);
OnOffSh = OnUOff(OnOffSh==1);
%AllCrit = sort([OnOffSh OnUOff ThCrit]);
AllCrit = sort([OnOffSh ThCrit]);
CheckAmpOn = PosOnsets(AllCrit);
CheckAmpOff = PosOffsets(AllCrit);
CheckedAmp = zeros(1,length(CheckAmpOn));
for k=1:length(CheckAmpOn)
    x1 = CheckAmpOn(k);
    x2 = CheckAmpOff(k);
    AmpInt = PCG(x1:x2);
    if max(abs(AmpInt))< 0.4
        CheckedAmp(k) =1;
    end
end
% Indexes which have the 4 criteria (offsets to be eliminated)
In4crit = PosOnsets(AllCrit(CheckedAmp==1));

In4crit2 = [In4crit PosOffsets(AllCrit(CheckedAmp==1))];
NewSeg = DerSh;

NewSeg(In4crit2) = 0;

% plot the segmentation result
figure;
plot(PCG);
hold on;
plot(NewSeg);
grid;
plot(ShEn);
% plot(Time(IndexOn),PointerOn(IndexOn),'c*');
% plot(Time(IndexOff),PointerOff(IndexOff),'k*');
% plot(Time(Index3),PointerTh(Index3),'r*');
% plot(Time(In4crit),PointerTh(In4crit),'g*');
% plot(Time(InFarOn),DerSh(InFarOn),'m*');
% plot(Time(IndexMaxLen),PointerTh(IndexMaxLen),'b*');