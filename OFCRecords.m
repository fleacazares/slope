listOffiles = dir('C:\Matlab code\Gremel\RR_2017-06-02_12-41-00_1142\SE*.spikes');
listOffiles = dir('C:\Matlab code\Gremel\RR_2017-06-02_12-41-00_1142\100_CH*_0.continuous');


allchanData = [];
allchanTimestamps = [];
for i = 1:1%size(listOffiles,1)
    [data, timestamps, info] = load_open_ephys_data_faster(listOffiles(i).name); %load
    FS = info.header.sampleRate; %sampling rate
    timeLength = length(data)/FS; %length in seconds
    dsData = resample(data, 50, FS)'; %downsample to 50 Hz
    dsTimestamps = resample(timestamps, 50, FS)';
    allchanData = [allchanData; dsData];
    allchanTimestamps = [allchanTimestamps; dsTimestamps];    
end

[data, timestamps, info] = load_open_ephys_data_faster(fullFileName); %load

FS = info.header.sampleRate; %sampling rate
timeLength = length(data)/FS; %length in seconds
dsData = resample(data, 50, FS); %downsample to 50 Hz

% Plot first 20 seconds of data (Alpha)
timeInterest = 3%60*30;
RF = 50;
t = 0:1/RF:timeInterest-(1/RF);
dataSnippet = dsData(1:length(t));
alpha_filtered = eegfilt(dataSnippet,RF,8,12);
alpha_power = abs(hilbert(eegfilt(dataSnippet,RF,8,12)')').^2;

subplot(3,1,1)
plot(t, zscore(dataSnippet))
title('OFC recording (50 Hz)')
xlabel('time (s)')
ylabel('zscore voltage (mV)')
subplot(3,1,2)
plot(t, zscore(alpha_filtered))
xlabel('time (s)')
ylabel('zscore Alpha voltage (mV)')
subplot(3,1,3)
plot(t, alpha_power)
xlabel('time (s)')
ylabel('Alpha Power')


% Plot first 20 seconds of data (Theta and Alpha)
timeInterest = 60*15;
RF = 50;
t = 0:1/RF:timeInterest-(1/RF);
dataSnippet = dsData(1:length(t))';
theta_filtered = eegfilt(dataSnippet,RF,4,8);
theta_power = abs(hilbert(eegfilt(dataSnippet,RF,4,8)')').^2;


subplot(5,1,1)
plot(t, zscore(dataSnippet), 'k')
title('OFC recording (50 Hz)')
xlabel('time (s)')
ylabel('zscore voltage (mV)')
set(gca,'fontsize',10)
set(gcf,'color','w');
subplot(5,1,2)
plot(t, zscore(theta_filtered), 'b')
xlabel('time (s)')
ylabel('zscore Theta filtered')
set(gca,'fontsize',10)
set(gcf,'color','w');
subplot(5,1,3)
plot(t, theta_power, 'b')
xlabel('time (s)')
ylabel('Alpha Power')
set(gca,'fontsize',10)
set(gcf,'color','w');

alpha_filtered = zscore(eegfilt(dataSnippet,RF,8,12));
alpha_power = abs(hilbert(eegfilt(dataSnippet,RF,8,12)')').^2;

subplot(5,1,4)
plot(t, zscore(alpha_filtered), 'r')
xlabel('time (s)')
ylabel('zscore Alpha filtered')
set(gca,'fontsize',10)
set(gcf,'color','w');
subplot(5,1,5)
plot(t, alpha_power, 'r')
xlabel('time (s)')
ylabel('Alpha Power')
set(gca,'fontsize',10)
set(gcf,'color','w');



L = length(t) / 2;
% decompose/reconstruct the signal
coef = fft(dataSnippet);
plot(real(coef(1:L)),'LineWidth',3); hold on
plot(imag(coef(1:L)),'r','LineWidth',3); grid on;
title(sprintf('Real and imaginary part \n of the fft'),'Fontsize',14);
xlabel('frequency','Fontsize',12); ylabel('Amplitude','Fontsize',12)


