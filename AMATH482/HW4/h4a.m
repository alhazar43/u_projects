%% Load cropped images
close all; clear all; clc
A=[];
baseDir='CroppedYale/yaleB';
for k= 1:39
    if k<10
        fileDir = strcat(baseDir, '0', num2str(k), '/');
    else
        fileDir = strcat(baseDir, num2str(k), '/');
    end
    fileName = dir(strcat(fileDir, '*.pgm'));
    for kk =1:length(fileName)
        fileRead = imread(strcat(fileDir, fileName(kk).name));
        fileRead = fileRead(:);
        A = [A, fileRead];
    end
end
A=double(A);
% Subtract mean
[m, n]=size(A);
A = A - repmat(mean(A, 1), m, 1);

%% Apply SVD to the matrix of cropped images
[U, S, V] = svd(A, 'econ');
% Graphical interpretation of U, S and V

%% plot S
figure(1)
subplot(2,2,1), plot(diag(S), 'ro', 'Linewidth', 1);
xlabel('Modes'); ylabel('Energy Captured')
title('(a) Singular Value Spectrum of Cropped Images')
set(gca, 'Fontsize', 12)
subplot(2,2,2), semilogy(diag(S), 'ro', 'Linewidth', 1);
xlabel('Modes'); ylabel('(log) Energy Captured')
title('(b) Log of Singular Value Spectrum of Cropped Images')
set(gca, 'Fontsize', 12)
subplot(2, 1, 2), plot((diag(S)*100)/sum(diag(S)), 'ro', 'Linewidth', 1);
xlabel('Modes'); ylabel('% of Energy Captured')
title('(c) Singular Value Percentage Spectrum of Cropped Images')
set(gca, 'Fontsize', 12)

%% plot U
figure(2)
for k=1:10
    face=reshape(U(:, k), [192 , 168]);
    subplot(2, 5, k), pcolor(flipud(face)); shading interp;
    title(strcat('Mode ', num2str(k)))
end

%% plot V
figure(3)
for k=1:10
    vect= V(:, k);
    subplot(2, 5, k), plot(vect)
    title(strcat('Mode ', num2str(k)))
end

%% Reconstruct the face image of first mode with specified rank (r) value
r=[1 10 50 100 250 500 1000 1500 2000 2414];
figure(4)
for kk=1:length(r)
    A_res = U(:, 1:r(kk)) * S(1:r(kk), 1:r(kk)) * V(:, 1:r(kk))';
    face_res = reshape(A_res(:, 1), [192 168]);
    subplot(2, 5, kk), pcolor(flipud(face_res)); shading interp;
    title(strcat('Rank ', num2str(r(kk))))
end


%% Load uncropped images
M = [];
baseDir='yalefaces/';
for k= 1:15
    if k<10
        fileDir = strcat(baseDir, 'subject0', num2str(k), '.*');
    else
        fileDir = strcat(baseDir, 'subject', num2str(k), '.*');
    end
    fileName = dir(fileDir);
    for kk =1:length(fileName)
        fileRead = imread(strcat(baseDir, fileName(kk).name));
        fileRead = fileRead(:);
        M = [M, fileRead];
    end
end
M=double(M);
% Subtract mean
[m, n]=size(M);
M = M - repmat(mean(M, 1), m, 1);

%% Apply SVD to the matrix of uncropped images
[u, s, v] = svd(M, 'econ');
% Graphical interpretation of u, s and v

%% plot s
figure(6)
subplot(2,2,1), plot(diag(s), 'ro', 'Linewidth', 1);
xlabel('Modes'); ylabel('Energy Captured')
title('(a) Singular Value Spectrum of Uncropped Images')
set(gca, 'Fontsize', 12)
subplot(2,2,2), semilogy(diag(s), 'ro', 'Linewidth', 1);
xlabel('Modes'); ylabel('(log) Energy Captured')
title('(b) Log of Singular Value Spectrum of Uncropped Images')
set(gca, 'Fontsize', 12)
subplot(2, 1, 2), plot((diag(s)*100)/sum(diag(s)), 'ro', 'Linewidth', 1);
xlabel('Modes'); ylabel('% of Energy Captured')
title('(c) Singular Value Percentage Spectrum of Uncropped Images')
set(gca, 'Fontsize', 12)

%% plot u
figure(7)
for k=1:10
    face_un=reshape(u(:, k), [243 , 320]);
    subplot(2, 5, k), pcolor(flipud(face_un)); shading interp;
    title(strcat('Mode ', num2str(k)))
end

%% plot v
figure(8)
for k=1:10
    vect_un= v(:, k);
    subplot(2, 5, k), plot(vect_un)
    title(strcat('Mode ', num2str(k)))
end
%% Reconstruct the face image of first mode with specified rank (r) value
r=[1 30 45 60 75 90 120 135 150 165];
figure(9)
for kk=1:length(r)
    M_res = u(:, 1:r(kk)) * s(1:r(kk), 1:r(kk)) * v(:, 1:r(kk))';
    faceun_res = reshape(M_res(:, 1), [243, 320]);
    subplot(2, 5, kk), pcolor(flipud(faceun_res)); shading interp;
    title(strcat('Rank ', num2str(r(kk))))
end
