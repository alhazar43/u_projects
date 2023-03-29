%% Load songs
close all; clear all; clc;

[x1, Fs] = audioread('RHCP1.mp3');
x2 = audioread('RHCP2.mp3');
x3 = audioread('RHCP3.mp3');
x = [x1;x2;x3]; xLength = length(x);

y1 = audioread('Eminem1.mp3');
y2 = audioread('Eminem2.mp3');
y3 = audioread('Eminem3.mp3');
y = [y1;y2;y3]; yLength = length(x);

z1 = audioread('Carpen1.mp3');
z2 = audioread('Carpen2.mp3');
z3 = audioread('Carpen3.mp3');
z = [z1;z2;z3]; zLength = length(z);

%% Define dataset for training and testing
trainNum = 300; testNum = 100; npc = 2;
ldaAccu=[]; nbAccu=[];
startPos = unidrnd(floor(0.85*xLength));
for ii=1:10 % # of runs of train and test
    % Training
    % Randomly extracting parts for training
    trainX = x([1:startPos-1, startPos+ceil(0.15*xLength):end]);
    trainY = y([1:startPos-1, startPos+ceil(0.15*yLength):end]);
    trainZ = z([1:startPos-1, startPos+ceil(0.15*zLength):end]);
    % Picking random 5-second song clips based on number of training
    % and start training them
    xTrain = songClip(trainNum, trainX, length(trainX), Fs, npc);
    yTrain = songClip(trainNum, trainY, length(trainY), Fs, npc);
    zTrain = songClip(trainNum, trainZ, length(trainZ), Fs, npc);
    trainLabels = [ones(trainNum,1);2*ones(trainNum,1);...
        3*ones(trainNum,1)];
    results = abs([xTrain';yTrain';zTrain']);

    % Testing
    % Randomly extracting parts for tesining
    testX = x([startPos:startPos+floor(0.15*xLength)]);
    testY = y([startPos:startPos+floor(0.15*yLength)]);
    testZ = z([startPos:startPos+floor(0.15*zLength)]);
    % Picking random 5-second song clips based on number of training
    % and start training them
    xTest = songClip(testNum, testX, length(testX), Fs, npc);
    yTest = songClip(testNum, testY, length(testY), Fs, npc);
    zTest = songClip(testNum, testZ, length(testZ), Fs, npc);
    testLabels = [ones(testNum,1);2*ones(testNum,1);...
        3*ones(testNum,1)];
    samples = abs([xTest';yTest';zTest']);

    % Classification
    % LDA
    ldaClass = classify(samples, results, trainLabels);
    ldaE = sum(ldaClass==testLabels)/length(ldaClass);
    ldaAccu = [ldaAccu; ldaE];
    % Naive Bayes
    nb = fitcnb(results, trainLabels); nbClass = predict(nb, samples);
    nbE = sum(nbClass==testLabels)/length(nbClass);
    nbAccu = [nbAccu; nbE];
end

%% Plot Classification Accuracy
figure(1)
plot(ldaAccu(1:10), 'rx--', 'Linewidth', 2); hold on;
plot(nbAccu(1:10), 'bo-'); hold on;
xlabel('Trials'); ylabel('Accuracy');
legend({'LDA', 'Naive Bayes'}, 'Location', 'northwest')
set(gca, 'Fontsize', 12)

%% Spectrogram by Band/Genre
figure(2)

subplot(1,3,1)
mid = length(x)/2;
clip = x(mid:mid+5*Fs);
spectrogram(clip,gausswin(500),200,[],Fs, 'yaxis');
title('Red Hot Chili Pepper (Rock)')

subplot(1,3,2)
mid = length(y)/2;
clip = y(mid:mid+5*Fs);
spectrogram(clip,gausswin(500),200,[],Fs, 'yaxis');
title('Eminem (Rap)')

subplot(1,3, 3)
mid = length(z)/2;
clip = z(mid:mid+5*Fs);
spectrogram(clip,gausswin(500),200,[],Fs, 'yaxis');
title('Carpenters (Pop/Folk)')
