%% Header
% Load and analyze some basic data.
% Scientific Programming, Spring 2015, Assignment 1
% Course taught by Pascal Wallisch
% Isaac Purton, 3/8/2015

%% Housekeeping
clear all
close all
clc
Matrixs_dirty = zeros(1603,3);
Matrix_data = [];
k = 1;

%% Loader
% Loads data from Matrix excel sheets into a single matrix
Matrixs_dirty(:,1) = xlsread('MATRIX1.xls');
Matrixs_dirty(:,2) = xlsread('MATRIX2.xls');
Matrixs_dirty(:,3) = xlsread('MATRIX3.xls');

%% Parsing/Cleaning
% Removes NaN values and reloads data into a new matrix
for ii = 1:1603
    if isnan(Matrixs_dirty(ii,1)) == 0 & ...
        isnan(Matrixs_dirty(ii,2)) == 0 & ...
         isnan(Matrixs_dirty(ii,3)) == 0
     Matrix_data(k,:) = Matrixs_dirty(ii,:);
     k = k + 1;
    end
end

%% Calculation

averages = mean(Matrix_data)
    % Calculates mean for each column of Matrix_data
Matrix1_vs_Matrix2_corr = corrcoef(Matrix_data(:,1),Matrix_data(:,2))
    % Calculates correlation coefficient for Matrix 1 vs Matrix 2
Matrix2_vs_Matrix3_corr = corrcoef(Matrix_data(:,2),Matrix_data(:,3))
    % Calculates correlation coefficient for Matrix 2 vs Matrix 3
Matrix1_vs_Matrix3_corr = corrcoef(Matrix_data(:,1),Matrix_data(:,3))
    % Calculates correlation coefficient for Matrix 1 vs Matrix 3

%% Plotting A) Histograms
% First histogram
figure 
    % Open new figure
subplot(1,3,1) 
    % Establish plot frame w/ subplots, open first subplot
hold on; 
    % Hold the plot
hist(Matrix_data(:,1),9) 
    % Generate histogram for Matrix 1
histfit(Matrix_data(:,1),9) 
    % Fit a gaussian curve
xlim([0 4]); 
    % Range for x-axis
title('The Matrix') 
    % Add a title

% Histogram: Reloaded
subplot(1,3,2) 
    % Open second subplot
hold on; 
    % Hold the plot
hist(Matrix_data(:,2),9) 
    % Generate histogram for Matrix 2
histfit(Matrix_data(:,2),9) 
    % Fit a gaussian curve
xlim([0 4]); 
    % Range for x-axis
title('The Matrix: Reloaded') 
    % Add a title

% Histogram: Revelations
subplot(1,3,3) 
    % Open third subplot
hold on; 
    % Hold the plot
hist(Matrix_data(:,3),9) 
    % Generate histogram for Matrix 3
histfit(Matrix_data(:,3),9) 
    % Fit a gaussian curve
xlim([0 4]); 
    % Range for x-axis
title('The Matrix: Revelations') 
    % Add a title
hold off

%% Plotting B1: 3D Scatters: The Matrix vs Reloaded
% Assign a temporary matrix, multiplying ratings by 2 to get
% integral steps and adding 1 so min value is 1, not 0.
M_temp_1 = (Matrix_data(:,1)*2) + 1; 
    % Loads The Matrix
M_temp_2 = (Matrix_data(:,2)*2) + 1;
    % Loads Reloaded
M_temp = cat(2, M_temp_1, M_temp_2);
    % Concatenates the above two

c = zeros(9,9); 
    % Creates a zero-filled, 9x9 matrix
for ii = 1:length(Matrix_data) 
    % Start first loop. 
    % This loop fills matrix c with rating counts for M1 & M2
c(10 - M_temp(ii,1), M_temp(ii,2)) ...
    = c(10 - M_temp(ii,1), M_temp(ii,2)) + 1; 
        % Updates a count at referenced point, effectivly counting ratings.
        % Ex. A rating pair of 2 and 3 updates the count at point 2, 3.
end
    % End loop
figure 
    % New figure
surf(c) 
    % Create a surface
shading interp 
    % Interpolate the shading
xlabel('Ratings for The Matrix') 
    % Label for the x-axis
ylabel('Ratings for The Matrix: Reloaded') 
    % Label for the y-axis
zlabel('Frequency') 
    % Label for the z-axis

%% Plotting B2: 3D Scatters: Reloaded vs Revelations
% Assign a temporary matrix, multiplying ratings by 2 to get
% integral steps and adding 1 so min value is 1, not 0.
M_temp_1 = (Matrix_data(:,2)*2) + 1; 
    % Loads Reloaded
M_temp_2 = (Matrix_data(:,3)*2) + 1;
    % Loads Revelations
M_temp = cat(2, M_temp_1, M_temp_2);
    % Concatenates the above two

c2 = zeros(9,9); 
    % Creates a zero-filled, 9x9 matrix
for ii = 1:length(Matrix_data) 
    % Start second loop. 
    % This loop fills matrix c2 with rating counts for M2 and M3.
c2(10 - M_temp(ii,1), M_temp(ii,2)) ...
    = c2(10 - M_temp(ii,1), M_temp(ii,2)) + 1;
        % Updates a count at referenced point, effectivly counting ratings.
        % Ex. A rating pair of 2 and 3 updates the count at point 2,3.
end
    % End loop
figure 
    % New figure
surf(c2) 
    % Create a surface
shading interp 
    % Interpolate the shading
xlabel('Ratings for The Matrix: Reloaded') 
    % Label for the x-axis
ylabel('Ratings for The Matrix: Revelations') 
    % Label for the y-axis
zlabel('Frequency') 
    % Label for the z-axis

%% Plotting B3: 3D Scatters: The Matrix vs Revelations
% Assign a temporary matrix, multiplying ratings by 2 to get
% integral steps and adding 1 so min value is 1, not 0.
M_temp_1 = (Matrix_data(:,1)*2) + 1;
    % Loads The Matrix
M_temp_2 = (Matrix_data(:,3)*2) + 1;
    % Loads Revelations
M_temp = cat(2, M_temp_1, M_temp_2);
    % Concatenates the above two

c3 = zeros(9,9); 
    % Creates a zero-filled, 9x9 matrix
for ii = 1:length(Matrix_data) 
    % Start third loop. 
    % This loop fills matrix c3 with rating counts for M1 and M3.
c3(10 - M_temp(ii,1), M_temp(ii,2)) ...
    = c3(10 - M_temp(ii,1), M_temp(ii,2)) + 1;
        % Updates a count at referenced point, effectivly counting ratings.
        % Ex. A rating pair of 2 and 3 updates the count at point 2,3.
end
    % End loop
figure 
    % New figure
surf(c3) 
    % Create a surface
shading interp 
    % Interpolate the shading
xlabel('Ratings for The Matrix') 
    % Label for the x-axis
ylabel('Ratings for The Matrix: Revelations') 
    % Label for the y-axis
zlabel('Frequency') 
    % Label for the z-axis