% Extract specific segments from S124 and S123 ---------------------
% From S124: Extract from 0.2 to 0.6 seconds
audio_segment1_s124 = audio_s124(timeVector_s124 >= 0.2 & timeVector_s124 <= 0.6);
time_segment1_s124 = timeVector_s124(timeVector_s124 >= 0.2 & timeVector_s124 <= 0.6);

% From S123: Extract from 0.6 to 1 second
audio_segment2_s123 = audio_s123(timeVector_s123 >= 0.6 & timeVector_s123 <= 1);
time_segment2_s123 = timeVector_s123(timeVector_s123 >= 0.6 & timeVector_s123 <= 1);

% From S124: Extract from 1 to 1.2 seconds
audio_segment3_s124 = audio_s124(timeVector_s124 >= 1 & timeVector_s124 <= 1.2);
time_segment3_s124 = timeVector_s124(timeVector_s124 >= 1 & timeVector_s124 <= 1.2);

% Concatenate the extracted segments to form a new 1-second data
audio_combined = [audio_segment1_s124; audio_segment2_s123; audio_segment3_s124];

% Create the corresponding time vector for the new combined audio data
time_combined = linspace(0, 1, length(audio_combined));

% Plot the combined audio data ------------------------------------
figure;
plot(time_combined, audio_combined);
xlabel('Time (seconds)');
ylabel('Amplitude');
%title('Combined Audio Data (1 Second)');
grid off;

% Save the figure as an SVG file ----------------------------------
saveas(gcf, 'combined_audio_plot.svg');