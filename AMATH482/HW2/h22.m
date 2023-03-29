close all; clear all; clc;
% Set up grid vectors
v=y'/2;
L=length(v)/Fs;
n=length(v);
t=(1:length(v))/Fs;
k=(2*pi/L)*[0:(n/2)-1 -n/2:-1]; ks=fftshift(k);

% Plot signal
figure(1)
% tr_piano=16; % record time in seconds
% y=audioread('music1.wav'); Fs=length(y)/tr_piano;
% plot((1:length(y))/Fs,y);
% xlabel('Time [sec]'); ylabel('Amplitude');
% set(gca, 'Fontsize', 12)
% title('(a) Mary had a little lamb (piano)'); drawnow
tr_rec=14; % record time in seconds
y=audioread('music2.wav'); Fs=length(y)/tr_rec;
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('(a) Mary had a little lamb (recorder)');
% p8 = audioplayer(y,Fs); playblocking(p8);

% Create a siliding window for Gabor transform
vgt_spec=[];
width=1000;
dt=0.14;
tslide=0:dt:L;
for j=1:length(tslide)
    g=exp(-width*(t-tslide(j)).^2); % Gaussian window
    vg=g.*v; vgt=fft(vg);
    vgt_spec=[vgt_spec; abs(fftshift(vgt))];
%     subplot(3,1,1), plot(t,v,'k',t,g,'g')
%     ylabel('v(n), g(t)'); xlabel('time [sec]');
%     set(gca,'Fontsize',12)
%     subplot(3,1,2), plot(t,vg,'k')
%     ylabel('v(n)*g(t)'); xlabel('time [sec]');
%     set(gca,'Fontsize',12)
%     subplot(3,1,3), plot(ks/(2*pi),abs(fftshift(vgt))/max(abs(vgt)))
%     ylabel('FFT(vg)'); xlabel('frequency [Hz]');
%     set(gca,'Fontsize',12)
%     drawnow
%     pause(0.1)
end

% Plot Spectrogram of frequency notes from piano/recorder
figure(2)
pcolor(tslide,ks/(2*pi), vgt_spec.'), shading interp
xlabel('time [sec]'); ylabel('frequency [Hz]');
title(sprintf('(b) Spectrogram of Recorder (width=%d, dt=%.2f)', width, dt))
set(gca,'Ylim', [700 1200], 'Fontsize', 12)
colormap hot
