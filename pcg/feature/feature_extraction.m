clc;
clear;
close all;

% read combined signal
load('combine_pcg.mat');

PCG = simu_audo;
fs = simu_fs;
time = simu_time;

% plot the signal
figure;
plot(time, PCG);
xlabel('Time (s)');
ylabel('Amplitude');
title('PCG Signal');

% Downsample the signal
fs_new = 8000; % New sampling rate
PCG_downsampled = resample(PCG, fs_new, fs);
time_downsampled = linspace(0, 1, length(PCG_downsampled));


% STFT
figure;
window = hamming(256); % 窗口大小为 256
overlap = 128; % 重叠大小为 128
nfft = 512; % FFT 点数
spectrogram(PCG_downsampled, window, overlap, nfft, fs_new, 'yaxis');
title('STFT (Spectrogram)');
colorbar;

% MFCC
% plot MFCC with 12 coefficients
% x is time, y is coefficient index
figure;
numCoeffs = 12;
coeffs = mfcc(PCG_downsampled, fs_new, 'NumCoeffs', numCoeffs, 'LogEnergy', 'Replace');
% convert frame index to time
time_mfcc = linspace(0, 1, size(coeffs, 2));
%imagesc(1:numCoeffs, time_mfcc, coeffs);
imagesc(time_mfcc, 1:numCoeffs, coeffs');
axis xy;
colormap parula;
title('MFCC');
xlabel('Time (s)');
ylabel('Coefficient Index');

% Cochleogram

fRange = [50, 1000];
x=PCG_downsampled;
Fs=fs_new;
time = (length(x)-1)/Fs;
gf = gammatoneFast(x, 64, fRange, 8000);%Construct the cochleagram use Gammatone filterbank
cg = cochleagram(gf, 20);%Construct the cochleagram

figure;
imagesc(linspace(0,time,size(cg,2)),linspace(fRange(1),fRange(2),size(cg,1)),cg);
axis xy;
colormap hot;
title('Cochleogram');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

