%% Test 1
close all; clear all; clc
load cam1_1
load cam2_1
load cam3_1

% Compute the video frame size for each camera
[m1,n1]=size(vidFrames1_1(:,:,1,1));
[m2,n2]=size(vidFrames2_1(:,:,1,1));
[m3,n3]=size(vidFrames3_1(:,:,1,1));
% Compute video frame number for each camera
numFrames1=size(vidFrames1_1, 4);
numFrames2=size(vidFrames2_1, 4);
numFrames3=size(vidFrames3_1, 4);

% % Capture starting position of the paint can
% imshow(vidFrames1_1(:,:,1,1)); [iniY,iniX]=ginput(1);
% imshow(vidFrames2_1(:,:,1,1)); [iniY,iniX]=ginput(1);
% imshow(vidFrames3_1(:,:,1,1)); [iniY,iniX]=ginput(1);
% % Capture final position of the paint can
% imshow(vidFrames1_1(:,:,1,end)); [finY,finX]=ginput(1);
% imshow(vidFrames2_1(:,:,1,end)); [finY,finX]=ginput(1);
% imshow(vidFrames3_1(:,:,1,end)); [finY,finX]=ginput(1);

X1=[]; X2=[]; X3=[];
Y1=[]; Y2=[]; Y3=[];
% Convert each frame into a black and white image
% Then only keep the portion of paint can's movement
% figure(1)
% Camera 1
for j=1:numFrames1
    mov(j).cdata=vidFrames1_1(:,:,:,j);
    mov(j).colormap=[];
    X=frame2im(mov(j)); Xbw=rgb2gray(X);
    vidGray(:,:,j)=Xbw;
    Xbw(:,1:310)=0; Xbw(:,380:end)=0; % iniY : finY
    Xbw(1:210,:)=0; Xbw(420:end,:)=0; % iniX : finX
%     imshow(Xbw); drawnow
    [Xmax, Xind]=max(Xbw(:));
    [x1, y1]=ind2sub(size(Xbw), Xind);
    X1=[X1 x1]; Y1=[Y1 y1];
end
% Camera 2
for j=1:numFrames2
    mov(j).cdata=vidFrames2_1(:,:,:,j);
    mov(j).colormap=[];
    X=frame2im(mov(j)); Xbw=rgb2gray(X);
    vidGray(:,:,j)=Xbw;
    Xbw(:,1:250)=0; Xbw(:,340:end)=0; % iniY : finY
    Xbw(1:100,:)=0; Xbw(370:end,:)=0; % iniX : finX
%     imshow(Xbw); drawnow
    [Xmax, Xind]=max(Xbw(:));
    [x2, y2]=ind2sub(size(Xbw), Xind);
    X2=[X2 x2]; Y2=[Y2 y2];
end
% Camera 3
for j=1:numFrames3
    mov(j).cdata=vidFrames3_1(:,:,:,j);
    mov(j).colormap=[];
    X=frame2im(mov(j)); Xbw=rgb2gray(X);
    vidGray(:,:,j)=Xbw;
    Xbw(:,1:280)=0; Xbw(:,480:end)=0; % iniY : finY
    Xbw(1:240,:)=0; Xbw(340:end,:)=0; % iniX : finX
%     imshow(Xbw); drawnow
    [Xmax, Xind]=max(Xbw(:));
    [x3, y3]=ind2sub(size(Xbw), Xind);
    X3=[X3 x3]; Y3=[Y3 y3];
end

% Align data with equal length
minFrames=min([numFrames1, numFrames2, numFrames3]);
X1=X1(1:minFrames); X2=X2(1:minFrames); X3=X3(1:minFrames);
Y1=Y1(1:minFrames); Y2=Y2(1:minFrames); Y3=Y3(1:minFrames);
% Transform to frequency component using FFT
X1t = fft(X1); X2t = fft(X2); X3t = fft(X3);
Y1t = fft(Y1); Y2t = fft(Y2); Y3t = fft(Y3);
% Shannon window
X1t(10:end-10) = 0; X2t(10:end-10) = 0; X3t(10:end-10) = 0;
Y1t(10:end-10) = 0; Y2t(10:end-10) = 0; Y3t(10:end-10) = 0;
% Inverse transform to spatial signal
X1f = abs(ifft(X1t)); Y1f = abs(ifft(Y1t));
X2f = abs(ifft(X2t)); Y2f = abs(ifft(Y2t));
X3f = abs(ifft(X3t)); Y3f = abs(ifft(Y3t));

% Plot unfiltered X and Y spatial signal
figure(1)
subplot(3,1,1)
plot(1:minFrames, X1,'r',1:minFrames, Y1,'b', 'LineWidth',1.5)
xlabel('Frame (t)'); ylabel('Postion');
legend({'Y vs t','X vs t'},'Location','southeast','Fontsize',8)
title('(Case 1) Camera 1 mass motion over frame')
set(gca, 'Xlim', [0 minFrames], 'Fontsize', 12)
subplot(3,1,2)
plot(1:minFrames, X2,'r',1:minFrames, Y2,'b','LineWidth',1.5)
xlabel('Frame (t)'); ylabel('Postion');
legend({'Y vs t','X vs t'},'Location','southeast','Fontsize',8)
title('(Case 1) Camera 2 mass motion over frame')
set(gca, 'Xlim', [0 minFrames], 'Fontsize', 12)
subplot(3,1,3)
plot(1:minFrames, X3,'r',1:minFrames, Y3,'b','LineWidth',1.5)
xlabel('Frame (t)'); ylabel('Postion');
legend({'Y vs t','X vs t'},'Location','southeast','Fontsize',8)
title('(Case 1) Camera 3 mass motion over frame')
set(gca, 'Xlim', [0 minFrames], 'Fontsize', 12)

% Plot filtered X and Y spatial signal
figure(2)
subplot(3,1,1)
plot(1:minFrames, X1f,'r',1:minFrames, Y1f,'b', 'LineWidth',1.5)
xlabel('Frame (t)'); ylabel('Postion');
legend({'Y vs t','X vs t'},'Location','southeast','Fontsize',8)
title('(Case 1) Camera 1 mass motion over frame (denosied)')
set(gca, 'Xlim', [0 minFrames], 'Fontsize', 12)
subplot(3,1,2)
plot(1:minFrames, X2f,'r',1:minFrames, Y2f,'b','LineWidth',1.5)
xlabel('Frame (t)'); ylabel('Postion');
legend({'Y vs t','X vs t'},'Location','southeast','Fontsize',8)
title('(Case 1) Camera 2 mass motion over frame (denosied)')
set(gca, 'Xlim', [0 minFrames], 'Fontsize', 12)
subplot(3,1,3)
plot(1:minFrames, X3f,'r',1:minFrames, Y3f,'b','LineWidth',1.5)
xlabel('Frame (t)'); ylabel('Postion');
legend({'Y vs t','X vs t'},'Location','southeast','Fontsize',8)
title('(Case 1) Camera 3 mass motion over frame (denosied)')
set(gca, 'Xlim', [0 minFrames], 'Fontsize', 12)

% Performs PCA (SVD on covariance matrix)
X=[X1; Y1; X2; Y2; X3; Y3];
for k=1:minFrames
    X(:,k)=X(:,k)-mean(X,2);
end
[U, S, V]=svd(cov(X));
sig=diag(S);

% Plot PCA results
figure(3)
plot((sig/sum(sig))*100, 'ro--', 'LineWidth', 1.5), axis([1 6 0 100])
xlabel('Modes'); ylabel('% of Energy');
title('(Case 1) Energy percentage captured by each mode after SVD')
set(gca, 'Fontsize', 12)

% Compute energy of first four modes
energy1=sig(1)/sum(sig);
energy2=sig(1:2)/sum(sig);
energy3=sig(1:3)/sum(sig);
energy4=sig(1:4)/sum(sig);
