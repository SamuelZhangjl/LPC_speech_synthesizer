clc
clear all

length_sound = 0.1; %length of the sound is 0.1s
length_synthesis = 0.5; %default length of the synthesis sound is 0.5s
lpc_order = 25;  %lpc modelling order


%------------exract a part of sound-------------%
[sound_original,fs]=audioread('hid_f.wav');

ts = 1/fs;  % sample frequency
sample_num = length_sound/ts;  %how many sample does it have in a segment sound
sound_segment = sound_original(1000:1000+sample_num-1);
sound(sound_segment,fs); %play the segment sound
time_vertor = (0:sample_num-1)*ts;
figure(1)
plot(time_vertor,sound_segment);  % plot segment sound in time domain
set(gca,'DefaultTextFontSize',20)
xlabel('x second','FontSize', 18)
ylabel('x(t)','FontSize', 18)
title('The segment of sound in time domain','FontSize', 20)

%----------------plot the segment sound in frequency domain--------------%
sound_fft = fft(sound_segment);
sound_fft = abs(sound_fft);
sound_fft = sound_fft(1:sample_num/2+1);
fft_vector = fs*(0:sample_num/2)/sample_num;
figure(7)
plot(fft_vector, 20*log10(sound_fft))
xlabel('frequenzy','FontSize', 18)
ylabel('Amplitude (dB)','FontSize', 18)
title('The segment of sound in frequency domain','FontSize', 20)

%--------------lpc analysis-------------------%
coefficients = lpc(sound_segment,lpc_order);   %generate lpc coefficients
[f_response,f_vector] = freqz(1,coefficients,fs,fs); % frequency response
f_response = abs(f_response);
fdb_response = 20*log10(f_response);
figure(7)
hold on
plot(f_vector,fdb_response,'m');
hold off

figure(3)
zplane(1,coefficients);

%------------ the first three formant frequency----------------%
[formant_vector,formant_amp] = formant_frequency(f_vector,fdb_response,3); 
figure(7)
hold on
plot(formant_vector,formant_amp,'r*');
text(formant_vector(1),formant_amp(1),{num2str(formant_vector(1))});
text(formant_vector(2),formant_amp(2),{num2str(formant_vector(2))});
text(formant_vector(3),formant_amp(3),{num2str(formant_vector(3))});
hold off

%------------ the fundamental frequency----------------%
[fundamental_vector,fundamental_amp] = fundamental_frequency(fft_vector,sound_fft); 
figure(4)
plot(fft_vector,sound_fft);
title('The segment of sound in frequency domain','FontSize', 20)
xlabel('frequenzy','FontSize', 18)
ylabel('Amplitude','FontSize', 18)
xlim([0 4000])
hold on
plot(fundamental_vector,fundamental_amp,'r*');
text(fundamental_vector,fundamental_amp,{'   ',num2str(fundamental_vector)});
hold off
disp('fundamental_vector');
disp(fundamental_vector);


%-----------------periodic impulse train------------------------%
impulse_train = zeros(1,fs*length_synthesis);    %periodic train
t_impluse = 1/fundamental_vector; 
impulse_train(1:round(t_impluse/ts):end)=1;    %periodic impulse train
time2_vertor = (1:fs*length_synthesis)*ts;
disp('impulse_train');
disp(round(t_impluse/ts));

%-------------------speech synthesis--------------------------%
speech_synthesis = filter(1,coefficients,impulse_train);
figure(5)
plot(time2_vertor,speech_synthesis)
title('Synthesis of the segment sound','FontSize', 20)
sound(speech_synthesis,fs); %play the speech synthesis
audiowrite('Zhang Jingliang synthesis of hid_f.wav',speech_synthesis,fs);
%wavwrite(speech_synthesis,fs,16,'ZhangJingliang.wav');



%--------------evaluations on different model orders -----------------%
% coefficients = lpc(sound_segment,15);   %generate lpc coefficients
% [f_response,f_vector] = freqz(1,coefficients,fs,fs); % frequency response
% f_response = abs(f_response);
% fdb_response = 20*log10(f_response);
% figure(7)
% hold on
% plot(f_vector,fdb_response,'g');
% hold off
% 
% coefficients = lpc(sound_segment,40);   %generate lpc coefficients
% [f_response,f_vector] = freqz(1,coefficients,fs,fs); % frequency response
% f_response = abs(f_response);
% fdb_response = 20*log10(f_response);
% figure(7)
% hold on
% plot(f_vector,fdb_response,'r');
% hold off
% 
% coefficients = lpc(sound_segment,80);   %generate lpc coefficients
% [f_response,f_vector] = freqz(1,coefficients,fs,fs); % frequency response
% f_response = abs(f_response);
% fdb_response = 20*log10(f_response);
% figure(7)
% hold on
% plot(f_vector,fdb_response,'k');
% hold off




