% -------------------------------------------------------------------------
% segmentation_main.m
% Author: Changhong Li
% Date: 2024-10-27
% Description: Main script for image segmentation using PCG method.
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% 0 Clear all variables, close all figures, and clear the command window
% -------------------------------------------------------------------------
% clear all variables
clear;
close all;
clc;

% -------------------------------------------------------------------------
% 1 read data
% -------------------------------------------------------------------------
% add data folder in previous directory to the path
addpath('data/cinc2016');

% read the wav file
[signal, fs] = audioread('data/cinc2016/a0001.wav');

% take first 10s of the signal
signal = signal(1:10*fs);

% plot the signal
figure;
plot(signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('PCG Signal');

% Plot the single-sided spectrum
figure;
N = length(signal);
f = (0:N/2-1) * fs / N; % Frequency vector for single-sided spectrum
Y = fft(signal);
Y = Y(1:N/2); % Take only the first half of the spectrum
plot(f, abs(Y));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-Sided Spectrum of PCG Signal');

% normalize the signal

% data normalization
signal = signal / max(abs(signal));
% cancel the DC component
signal = signal - mean(signal);


% -------------------------------------------------------------------------
% 2 filter the signal
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% 2.1 bandpass filter
% -------------------------------------------------------------------------

% bandpass filter the signal
addpath('denoising');
f1 = 20;
f2 = 600;
order = 4;

signal_filtered = pcg_bandpass(signal, fs, f1, f2, order);

% -------------------------------------------------------------------------
% 2.2 wavelet filter
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% 3 segment the signal
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% 3.1 use shannon segmentation to segment the signal
% -------------------------------------------------------------------------
addpath('segmentation/shannon');
Fs = fs;
PCG = signal_filtered;
[NewSeg, ShEn] = shannon_segmentation(PCG, Fs);

% -------------------------------------------------------------------------
% 3.2 use HMM to segment the signal
% -------------------------------------------------------------------------

% % Load the default options:

% addpath('segmentation/springerHMM');
% springer_options = default_Springer_HSMM_options;
% load('example_data.mat');

% % Split the data into train and test sets:
% % Select the first 5 recordings for training and the sixth for testing:
% train_recordings = example_data.example_audio_data([1:5]);
% train_annotations = example_data.example_annotations([1:5],:);

% % test_recordings = example_data.example_audio_data(6);
% % test_annotations = example_data.example_annotations(6,:);

% % use the filtered signal as the test signal
% test_recordings = signal_filtered;
% % wrap the test signal in a cell
% test_recordings = {test_recordings};
% numPCGs = length(test_recordings);

% % Train the HMM:
% [B_matrix, pi_vector, total_obs_distribution] = trainSpringerSegmentationAlgorithm(train_recordings,train_annotations,springer_options.audio_Fs, false);

% % Verify the HMM on an unseen test recording: 
% for PCGi = 1:numPCGs
%     % [assigned_states] = runSpringerSegmentationAlgorithm(test_recordings{PCGi}, springer_options.audio_Fs, B_matrix, pi_vector, total_obs_distribution, true);
%     [assigned_states] = runSpringerSegmentationAlgorithm(test_recordings{PCGi}, fs, B_matrix, pi_vector, total_obs_distribution, true);
% end

