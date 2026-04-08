function main
    [xx, fs] = audioread('../Data/TestAudio.wav');

    % Finds dominant frequency
    yy = fft(xx);
    yy = yy/max(yy);


    % Plots
    %--------------------------------------------------------
    figure;
    spectrogram(xx, 1024, 1000, 0:1:fs/2, fs, 'yaxis');
    figure;
    spectrogram(yy, 1024, 1000, 0:1:fs/2, fs, 'yaxis');
    %--------------------------------------------------------