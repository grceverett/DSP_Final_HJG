function main
    % Define samples
    files = ["./Samples/Male_1.wav", "./Samples/Male_2.wav", "./Samples/Female_1.wav"];
    titles = ["Male 1", "Male 2", "Female 1"];

    for i = 1:length(files)
        % Read files and normalize audio
        [x, fs] = audioread(files(i));
        x = x / max(abs(x));

        % Extract MFCC (common data for voice recognition)
        coeffs = mfcc(x,fs);
        mfccData{i} = coeffs(:, 1:13); % Slap 'em in an array

        % Plotting 3 types of data extracted from audio
        figure;
        binCount = 50; % Resolution of data
        subplot(3,1,1);
        histogram(coeffs(:,1),binCount,"Normalization","pdf");
        title(titles(i))

        subplot(3,1,2)
        histogram(coeffs(:,2),binCount,"Normalization","pdf");
    
        subplot(3,1,3)
        histogram(coeffs(:,3),binCount,"Normalization","pdf");
    end


    % This is being stupid, so ignore it for now
    % ----------------------------------------------------------------
    % data = cell2mat(mfccData');
    % [idx, C] = kmeans(data, 3); % kmeans is a clustering function
    % 
    % % Plot cluster
    % figure;
    % gscatter(data(:,1),data(:,2),idx,'bgm')
    % hold on
    % plot(C(:,1),C(:,2),'kx')
    % legend('Cluster 1','Cluster 2','Cluster 3','Cluster Centroid')
    % ----------------------------------------------------------------
