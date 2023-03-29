function [randSamp] = songClip(iter, file, length, Fs, npc)
    randSamp = [];
    % Randomly sampling 5-second snippet of music for each iteration
    for j = 1:iter
        feature = [];
        clipStart = unidrnd(length-5*Fs);
        clipEnd = clipStart + 5*Fs;
        clip = file(clipStart:clipEnd);
        [spec] = spectrogram(clip,gausswin(500),200,[],Fs);
        [u,s,v] = svd(spec,'econ');
        for j = 1:npc
            feature = [feature;u(:,j)];
        end
        randSamp = [randSamp, feature]; 
    end
end

