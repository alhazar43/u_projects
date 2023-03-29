%% Load video
close all; clear all; clc;
vid = VideoReader('video/double_pendulum.mp4');
height = vid.Height; width = vid.Width; 
numFrames = round(vid.Duration * vid.FrameRate);
t = linspace(0, vid.Duration, numFrames); dt = t(2)-t(1);
X = zeros(height*width, numFrames);
for ii=1:numFrames
    vidFrame = rgb2gray(readFrame(vid));
%     imshow(vidFrame);
    vec = vidFrame(:); % vectorize video frame
    X(:, ii) = vec;
end

%% Create DMD data matrices
clear vidFrame vid vec ii
X1 = X(:, 1:end-1); X2 = X(:, 2:end);
[U2, Sigma2, V2] = svd(X1, 'econ');
r = 300; % reconstruction rank
U = U2(:, 1:r); Sigma=Sigma2(1:r,1:r); V=V2(:,1:r);
Atilde = U'*X2*V/Sigma;
[W,D] = eig(Atilde);
Phi=X2*V/Sigma*W;
mu=diag(D);
omega=log(mu)/dt;
b = Phi\X1(:, 1); % pseudo-inverse initial conditions
Xmodes = zeros(r, length(t)); % DMD reconstruction for every time point
for iter = 1:length(t)
    Xmodes(:, iter) = (b.*exp(omega*(t(iter))));
end
Xdmd = Phi*Xmodes;   % DMD resconstruction with all modes

%% Background subtraction
clear Xmodes W D Atilde mu b U Sigma V X1 X2 U2 V2
Xres = reshape(X, height, width, numFrames);
Xlow = reshape(Xdmd, height, width, numFrames);
Xsparse = Xres-abs(Xlow);
R = Xsparse; R(R>0)=0;
Xlow = R+abs(Xlow);
Xsparse = Xsparse-R; % remove negative intensities

%% Plots
clear Xdmd X R
keyFrame = 00;
% Low rank reconstruction by DMD
figure(1), imshow(uint8(Xsparse(:, :, keyFrame)+Xlow(:, :, keyFrame)))
title(strcat('DMD reconstruction (rank ', num2str(r), ')')); set(gca, 'Fontsize', 12)
% Foreground object
figure(2), imshow(12*uint8(Xsparse(:, :, keyFrame)))
title(strcat('Foreground (rank ', num2str(r), ')')); set(gca, 'Fontsize', 12)
% Background object
figure(3), imshow(0.8*uint8(Xlow(:, :, keyFrame)))
title(strcat('Background (rank ', num2str(r), ')')); set(gca, 'Fontsize', 12)
% SVD spectrum
figure(4), plot((diag(Sigma2)/sum(diag(Sigma2)))*100, 'ro-', 'Markersize', 10, 'Linewidth', 1.5)
xlabel('Modes'); ylabel('% of Energy captured');
title(strcat('SVD specturm (rank ', num2str(r), ')'))
ylim([0 100])
set(gca, 'Fontsize', 12)
set(gcf, 'Position',  [200, 100, 800, 600])

%% Visualization
figure(1)
for kk = 1:numFrames
    imshow(15*uint8(Xsparse(:, :, kk)))
end
