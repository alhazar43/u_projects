close all; clear all; clc;
load handel
v = y'/2;
vt=fft(v);
figure(1)
subplot(2,1,1), plot((1:length(v))/Fs,v);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Signal of Interest, v(n)');
set(gca,'Fontsize',12)
% p8 = audioplayer(v, Fs);
% playblocking(p8);

% Set up grid vectors
L=length(v)/Fs;
n=length(v);
t=(1:length(v))/Fs;
k=(2*pi/L)*[0:(n-1)/2 -(n-1)/2:-1]; ks=fftshift(k);

% FFT the unfiltered signal over the entire time domain
subplot(2,1,2), plot(ks/(2*pi),abs(fftshift(vt))/max(abs(vt)))
xlabel('frequency [Hz]'); ylabel('FFT(v(n))');
set(gca,'Fontsize',12)

% Create multiple Gabor filters with (Super) Gaussian,
% Mexican Hat Wavelet and Shannon window
filter={@(width, t, power) exp(-width*(t).^in), ...
  @(width, t) (1-(t/width).^2).*exp(-((t/width).^2)/2), ...
     @(width, t) (t>(-width/2) & t<(width/2))};

% Create a sliding window for Gabor transform
vgt_spec=[];
width=1; % window width
dt=0.1; % translation
tslide=0:dt:L;
figure(2)
for j=1:length(tslide)
    g=filter{3}(width, t-tslide(j));
    vg=g.*v; vgt=fft(vg);
    vgt_spec=[vgt_spec; abs(fftshift(vgt))];
    subplot(3,1,1), plot(t,v,'k',t,g,'g')
    ylabel('v(n), g(t)'); xlabel('time [sec]');
    set(gca,'Fontsize',12)
    subplot(3,1,2), plot(t,vg,'k')
    ylabel('v(n)*g(t)'); xlabel('time [sec]');
    set(gca,'Fontsize',12)
    subplot(3,1,3), plot(ks/(2*pi),abs(fftshift(vgt))/max(abs(vgt)))
    ylabel('FFT(vg)'); xlabel('frequency [Hz]');
    set(gca,'Fontsize',12)
    drawnow
    pause(0.1)
end

% Plot the spectrogram
figure(3)
pcolor(tslide,ks/(2*pi),vgt_spec.'), shading interp
ylabel('frequency [Hz]'); xlabel('time [sec]');
set(gca, 'Ylim', [-2000 2000], 'Fontsize', 12)
colormap hot
