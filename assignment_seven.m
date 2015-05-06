%% Header
% Analysis of sample data using Cohen's D, average intercorrelation,
% Cronbach's alpha, and p-values from paired t-tests.
% Scientific Programming, Spring 2015, Assignment 7
% Course taught by Pascal Wallisch
% Isaac Purton, 4/26/2015

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
data_dir = 'F:\scientific_programming\Data';
    
try
    cd(data_dir)
catch
    disp('Data directory does not exist! Please edit the script to correct this.');
        % Attempts to cd into the data_dir, and displays an error message
        % if the directory is incorrect.
end

%% Load in Data

load('sigef.mat')
    % Loads in the first data file; this will be an array called DATA
sig_data = DATA;
clear('DATA');
    % Rename DATA array to sig_data
    
anx_data = xlsread('anxiety_test.xlsx');
    % Load in Excel data - Anxiety
    
cd(root_dir)
    % Return to root directory
    
%% Data Analysis - sig_data
% Note: for whatever reason, length(sig_data) returns 4 instead of 999, so
% this part is hard-coded
sig_analysis = zeros(999,3);
for ii = 1:999
    sample1 = sig_data{ii}(:,1);
    sample2 = sig_data{ii}(:,2);
    
    sig_analysis(ii,1) = length(sample1);
        % Find sample size, prints to column 1
    
    [h, p] = ttest(sample1, sample2);
    sig_analysis(ii,2) = p;
        % Prints p value to sig_analysis column 2
        
    % Pooled standard deviation for Cohen's D
    s1 = std(sample1);
    s2 = std(sample2);
        % Find standard deviations

    pooled_std = sqrt(((s1^2)/2) + ((s2^2)/2));
        % Calculate pooled standard deviation
    
    % Calculate Cohen's D
    mean1 = mean(sample1);
    mean2 = mean(sample2);

    numerator = abs(mean1 - mean2);
    denominator = pooled_std;

    D = numerator / denominator;
    
    sig_analysis(ii,3) = D;
        % Print's Cohen's D to sig_analysis column 3
end

% Plotting is done later on

%% Data Analysis - anx_data

sz = size(anx_data);
k = min(sz);
    % Finds number of tasks (equals number of columns)
n = max(sz);
    % Finds number of participants
    
anx_analysis = zeros(k-1,3);
    % Alpha matrix; number of rows is equal to k-1 because there's no point
    % in calculating Cronbach's Alpha for a single task
anx_analysis(:,1) = 2:k;

% Cronbach's alpha
for ii = 2:k
    var_matrix = cov(anx_data(:,1:ii));
        % Finds variance matrix for a specific range of tasks
    
    % Calculate vbar
    variances = diag(var_matrix);
        % Finds the diagonal values of var_matrix, which are the variances
        % of the items
    vbar = mean(variances);
    
    % Calculate cbar
    % This loop turns the elements on the diagnoal of var matrix into 0s,
    % effectivly removing the variance values
    covar_matrix = var_matrix;
    for jj = 1:ii
        covar_matrix(jj,jj) = 0;
    end
    
    new_variances = reshape(triu(covar_matrix),numel(triu(covar_matrix)),1);
        % Single column of upper triangle of variance matrix; includes many
        % zeros that need to be removed
    zero_index = find(new_variances == 0);
    covariances = new_variances;
    covariances(zero_index) = [];
        % All covariance values
    cbar = mean(covariances);
    
    % Calculate Cronbach's alpha
    numerator = n * cbar;
    denominator = vbar + (n-1) * cbar;
    alpha = numerator / denominator;
    
    anx_analysis(ii-1,2) = alpha;
        % Prints Cronbach's alpha to anx_analysis
end

% Average correlation coefficient
for ii = 2:k
    coef_matrix = corrcoef(anx_data(:,1:ii));
        % Finds matrix of correlation coefficients
    
    % Sets the correlations of items vs themselves to 0
    fixed_corrcoef = coef_matrix;
    for jj = 1:ii
        fixed_corrcoef(jj,jj) = 0;
    end
    
    new_corrs = reshape(triu(fixed_corrcoef),numel(triu(fixed_corrcoef)),1);
        % Single column of upper triangle of variance matrix; includes many
        % zeros that need to be removed
    zero_index = find(new_corrs == 0);
    correlations = new_corrs;
    correlations(zero_index) = [];
        % All correlation values
    avg_corr = mean(correlations);
    
    anx_analysis(ii-1,3) = avg_corr;
        % Prints average correlation to anx_analysis
end

% anx_analysis is a three column matrix:
% Column 1: k, from 2 to 6
% Column 2: Cronbach's alpha for each batch of ks
% Column 3: average correlation for each batch of ks

%% Plotting
figure
hold on
% P-value vs sample size
subplot(2,2,1)
scatter(sig_analysis(:,1), sig_analysis(:,2), 20, '.')
set(gca, 'Ylim', [0.03 0.06], 'Ytick', 0.03:0.01:0.06, 'Xlim', [0 1000])
xlabel('Sample size')
ylabel('P-value of paired t-test')
title('Analysis of sigef: p-values of paired t-tests')

% Cohen's d vs sample size
subplot(2,2,2)
scatter(sig_analysis(:,1), sig_analysis(:,3), 20, '.')
set(gca, 'Ylim', [0 2], 'Ytick', 0:0.5:2, 'Xlim', [0 1000])
xlabel('Sample size')
ylabel('Cohen''s D')
title('Analysis of sigef: Cohen''s D')

% Cronbach's alpha vs k
subplot(2,2,3)
plot(anx_analysis(:,1),anx_analysis(:,2),'o-')
set(gca,'Xlim', [1 7], 'XTick', 2:6, 'Ylim', [0.65 1.05], ...
    'Ytick', 0.7:0.1:1, 'box', 'off')
xlabel('Number of items')
ylabel('Cronbach''s alpha')
title('Analysis of anxiety test data: Cronbach''s alpha')

% Average inter-correlation vs k
subplot(2,2,4)
plot(anx_analysis(:,1),anx_analysis(:,3),'o-')
set(gca,'Xlim', [1 7], 'XTick', 2:6, 'Ylim', [0.65 1.05], ...
    'Ytick', 0.7:0.1:1, 'box', 'off')
xlabel('Number of items')
ylabel('Average inter-correlation')
title('Analysis of anxiety test data: average inter-correlation')