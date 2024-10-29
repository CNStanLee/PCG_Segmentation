% 读取音频文件
[audioData, sampleRate] = audioread('05 Apex, S3, LLD, Bell.mp3');

% 创建时间向量，长度与音频数据相同
timeVector = (0:length(audioData)-1) / sampleRate;

% 绘制时域图像
figure;
plot(timeVector, audioData);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Representation of Audio Signal');
grid on;


% 读取音频文件
[audioData, sampleRate] = audioread('03 Apex, S4, LLD, Bell.mp3');

% 创建时间向量，长度与音频数据相同
timeVector = (0:length(audioData)-1) / sampleRate;

% 绘制时域图像
figure;
plot(timeVector, audioData);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Representation of Audio Signal');
grid on;
