%% Header
% Analysis of sample data using a variety of methods
% Dependencies: moving_std function
% Scientific Programming, Spring 2015, Assignment 8
% Course taught by Pascal Wallisch
% Isaac Purton, 5/5/2015

%% Housekeeping

%Clean env
close all
clear all
clc

% Directory handling
root_dir = pwd;
    % Assigns current directory to a variable
    % You should start this script in your scientific_programming root
    % folder (where the data and code folders are)
data_dir = 'D:\scientific_programming\Data';
    
try
    cd(data_dir)
catch
    disp('Data directory does not exist! Please edit the script to correct this.');
        % Attempts to cd into the data_dir, and displays an error message
        % if the directory is incorrect.
end

if exist('moving_std') == 0
    disp('moving_std function not found! Please add this to your working directory in order to run this script.');
        % Check for presence of user-defined function
end

%% Load in Data

load('sigef2.mat')
    % Loads in the first data file; this will be an array called DATA
sig_data = DATA2;
clear('DATA2');
    % Rename DATA array to sig_data
    
clin_data = xlsread('clinical_dataset.xlsx');
    % Load in Excel data - Anxiety
    
cd(root_dir)
    % Return to root directory
    
%% Data Analysis - sig_data
sig_analysis = zeros(length(sig_data),4);
for ii = 1:length(sig_data)
    sample1 = sig_data{ii}(:,1);
    sample2 = sig_data{ii}(:,2);
    
    % Standard deviations
    s1 = std(sample1);
    s2 = std(sample2);
    
    % Pooled s. dev
    s_pool = sqrt(((s1^2)/2) + ((s2^2)/2));
    sig_analysis(ii,1) = s_pool;
        % Prints pooled variance to column 1
        
    % Means
    mean1 = mean(sample1);
    mean2 = mean(sample2);
    
    % Mean difference
    mean_diff = abs(mean1 - mean2);
    sig_analysis(ii,2) = mean_diff;
        % Prints absolute mean difference to column 2
    
    % P-value of paired t-test
    [h, p] = ttest(sample1, sample2);
    sig_analysis(ii,3) = p;
        % Prints p value to sig_analysis column 3

    % Cohen's D
    D = mean_diff / s_pool;
    
    sig_analysis(ii,4) = D;
        % Print's Cohen's D to sig_analysis column 4
end

% Plotting comes later

%% Data Analysis - clin_data
% Moving standard deviations
window_size = 7;
anx_sdevs = moving_std(clin_data, window_size);
sad_sdevs = moving_std(clin_data, window_size);

% Correlations
clin_corr = zeros(90, 2);
clin_corr(:,1) = 1:90;
    % Prints all kernal lengths; used for plotting

% Correlation of raw data set is equivalent to having a kernal size of 1,
% so this value is included in the following for loop

% Find correlations for various convolutions of clin_data
for window = 1:90
    % Define kernal
    kernal = ones(window,1);
    kernal_weight = sum(kernal);
    
    % Perform convolutions
    anx_conv = conv(clin_data(:,1),kernal,'valid');
    sad_conv = conv(clin_data(:,2),kernal,'valid');
    
    % Find correlation
    clin_corr(window, 2) = corr(anx_conv, sad_conv);
end

%% Plotting

%% Sig_data plots

% Histograms
histograms = figure;
hold on
for ii = 1:4
    % Use Freedman-Diaconis rule to find optimal number of bins for hist\
    % # of bins = max - min / 2*(IQR/n^(1/3))
    numerator = max(sig_analysis(:,ii)) - min(sig_analysis(:,ii));
        % Finds the overall range
    nn = length(sig_analysis(:,ii));
        % Finds n
    temp_iqr = iqr(sig_analysis(:,ii));
        % Finds the inter-quartile range (diff btwn Q1 and Q3)
    denominator = 2 * (temp_iqr / nn^(1/3));
        % Actual bin width is given here
    bin_n = floor(numerator / denominator);
        % floor makes sure that bin_n is an integer
    
    % Make histogram
    subplot(2,2,ii)
    hist(sig_analysis(:,ii),bin_n)
    ylabel('Count')
    switch ii
        case 1
            xlabel('Pooled variance')
            title('Histogram of pooled variance')
        case 2
            xlabel('Absolute mean difference')
            title('Histogram of absolute mean difference')
        case 3
            xlabel('P-values')
            title('Histogram of p-values from a paired t-test')
        case 4
            xlabel('Cohen''s D')
            title('Histogram of Cohen''s D')
    end
end
hold off

% Scatter plots
scattered = figure;
hold on

% Effect Size vs abs mean diff
subplot(2,1,1)
scatter(sig_analysis(:,4),sig_analysis(:,2))
xlabel('Cohen''s D')
ylabel('Absolute mean difference')
title('Effect size vs mean difference between samples')

% Effect Size vs pooled var
subplot(2,1,2)
scatter(sig_analysis(:,4),sig_analysis(:,1))
xlabel('Cohen''s D')
ylabel('Pooled variance')
title('Effect size vs pooled variance')

%% Plotting for clin_data
% Variance/volitility
% Find first percentile
anx_top_percentile = max(anx_sdevs) * 0.99;
sad_top_percentile = max(sad_sdevs) * 0.99;
    % Any value above this is in the top one percent of the data
    
clin_x_axis = 1:length(anx_sdevs);
    % Define vector to use for an x-axis

clinical_lines = figure;
hold on

% Anxiety data
subplot(2,1,1)
hold on
plot(clin_x_axis, anx_sdevs, 'DisplayName', 'Anxiety Data')
for jj = 1:length(anx_sdevs)
    if anx_sdevs(jj) > anx_top_percentile
        line([jj jj], [0 anx_sdevs(jj)], 'Color', 'r', 'LineStyle', '--',...
            'DisplayName', ['Threshold met at days ' int2str(jj) ' to ' ...
            int2str(jj + window_size)])
            % Draws a vertical line at each point at which the threshold
            % was met by checking each sdev value against the
            % top_percentile. DisplayName is used to show an identifying
            % label in the figure's legend.
    end
end
set(gca,'Xlim',[0 max(clin_x_axis) + 50], 'Xtick', ...
    0:200:max(clin_x_axis), 'box', 'off')
legend('show')
    % Show the legend
title(['Standard deviations in anxiety data, found across a ' ...
    int2str(window_size) ' day sliding window'])
xlabel('First day of sliding window')
ylabel('Standard deviation')

% Sadness data
subplot(2,1,2)
hold on
plot(clin_x_axis, sad_sdevs, 'DisplayName', 'Sadness Data')
for jj = 1:length(sad_sdevs)
    if sad_sdevs(jj) > sad_top_percentile
        line([jj jj], [0 sad_sdevs(jj)], 'Color', 'r', 'LineStyle', '--',...
            'DisplayName', ['Threshold met at days ' int2str(jj) ' to ' ...
            int2str(jj + window_size)]) 
    end
end
set(gca,'Xlim',[0 max(clin_x_axis) + 50], 'Xtick', ...
    0:200:max(clin_x_axis), 'box', 'off')
legend('show')
title(['Standard deviations in sadness data, found across a ' ...
    int2str(window_size) ' day sliding window'])
xlabel('First day of sliding window')
ylabel('Standard deviation')

% Correlations vs kernal of convolution
kernal_corr = figure;
plot(clin_corr(:,1),clin_corr(:,2))
set(gca, 'box', 'off')
xlabel('Size of kernal')
ylabel('Correlation of anxiety vs sadness')
title(['Correlation between anxiety and sadness as a function of the '...
    'size of a convolution kernal'])
