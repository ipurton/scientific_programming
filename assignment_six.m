%% Header
% Vision experiment, testing how well people can tell the difference btwn
% gabors oriented in reference to a vertical, horizontal, or oblique angle.
% Dependencies: Psychtoolbox v3
% Scientific Programming, Spring 2015, Assignment 6
% Course taught by Pascal Wallisch
% Isaac Purton, 4/20/2015

%% Housekeeping
clear all
close all
clc

FlushEvents('keydown');
ListenChar(2);
    % Suppresses characters from being typed into the command window

Screen('Preference', 'SkipSyncTests', 1);
    % Prevents sync errors from occuring
    
%% Key Variables

% Orientations for reference lines
ref = zeros(4,1);
ref(1) = 0;
    % Vertical orientation
ref(2) = 90;
    % Horizontal orientation
ref(3) = 45;
    % 45-degrees; oblique
ref(4) = 145;
    % 145-degrees; oblique

% Number of trials
num_trials = 200;
total_trials = num_trials .* length(ref);

% Define key-codes
% Make flexible for other computers?
cl_wise = 188;
    % Sets key for participant response of "clockwise" to "< ,"
wid_wise = 190;
    % Sets key for participant response of "widdershins" (eg. 
    % "counter-clockwise") to "> ."

% Prep for tilt
max_tilt = -5;
    % Minimum value for tilt
min_tilt = 5;
    % Maximum value for tilt
   
iti = 0.5;
    % Defines inter-trial interval

%% Trial Variables

ref_matrix = repmat([ref(1) ref(2) ref(3) ref(4)], 1, num_trials);
    % Vector consisting of the ref values repeated for the
    % number of times provided in num_trials
    % Ex. [0 90 45 145] repeated 200 times

so = randperm(total_trials);
    % Vector with values from 1 to total_trials in a random order.
    % Allows for random selection from ref_matrix

data = zeros(total_trials, 5);
    % Col 1 = condition (angle of reference line)
    % Col 2 = relative orientation of left gabor
    % Col 3 = relative orientation of right gabor
    % Col 4 = participant response (0 = counterclockwise, 1 = clockwise)
    % Col 5 = accuracy (0 = false, 1 = correct)
    
%% Set-Up Screens

% Find out how many screens and use largest screen number.
whichScreen = max(Screen('Screens'));

% Opens a graphics window on the main monitor (screen 0).
window = Screen('OpenWindow', whichScreen);

% Retrieves color codes for black and white and gray.
black = BlackIndex(window);  
    % Retrieves the CLUT color code for black.
white = WhiteIndex(window);  
    % Retrieves the CLUT color code for white.
gray = (black + white) / 2;  
    % Computes the CLUT color code for gray.
if round(gray) == white
    gray = black;
end

Screen('FillRect', window, gray);
    % Opens a full window rectangle and fills it with gray

% Taking the absolute value of the difference between white and gray will
% help keep the grating consistent regardless of whether the CLUT color
% code for white is less or greater than the CLUT color code for black.
absoluteDifferenceBetweenWhiteAndGray = abs(white - gray);

%% Show Instructions
msg = ['Welcome to the gaborium!' char(10) char(10) 'Please look for '...
    'Differences between the two gabors that will be shown on your '...
    'screen. If the gabor on the right is tilted clockwise relative '...
    'to the one on the left, press the "< ," key. If the relative '...
    'tilt is counterclockwise, press the "> ." key.' char(10) char(10)...
    'Keep in mind that differences should be judged based on the '...
    'right-most end of the gabor.' char(10) char(10)...
    'Press any key to continue.'];
DrawFormattedText(window, msg, 'center', 'center', [], 60);

Screen('Flip', window)
KbWait([], 3);
    % Waits for participant response
    % KbWait is a very annoying function to use; setting it this way makes
    % the function wait for the first key press/release to happen after it
    % is called.
pause(0.5)

Screen('Flip', window)
    
%% Set-Up Gabors
% Create and store gabors for future display

% Constant values
% Spatial Freq of grating
pixelsPerPeriod = 33; % How many pixels will each period/cycle occupy?
spatialFrequency = 1 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)
% Size of Gaussian envelope
periodsCoveredByOneStandardDeviation = 1.5;
gaussianSpaceConstant = periodsCoveredByOneStandardDeviation  * pixelsPerPeriod;

% Size of underlying grid (stimulus)
widthOfGrid = 400;
halfWidthOfGrid = widthOfGrid / 2;
widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.

% Creates a two-dimensional square grid.  For each element i = i(x0, y0) of
% the grid, x = x(x0, y0) corresponds to the x-coordinate of element "i"
% and y = y(x0, y0) corresponds to the y-coordinate of element "i"
[x y] = meshgrid(widthArray, widthArray);

% Gaussian envelope
% Creates a circular Gaussian mask centered at the origin, where the number
% of pixels covered by one standard deviation of the radius is
% approximately equal to "gaussianSpaceConstant."
% Note that since each entry of circularGaussianMaskMatrix is "e"
% raised to a negative exponent, each entry of
% circularGaussianMaskMatrix is one over "e" raised to a positive
% exponent, which is always between zero and one;
% 0 < circularGaussianMaskMatrix(x0, y0) <= 1
circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2));

gaborID = zeros(total_trials, 1);
    % Initializes vector that will store ID values for each pair of gabors;
    % these will be used later on the actually draw the gabors on screen

% Generating actual gabors
for ii = 1:total_trials
    data(ii,1) = ref_matrix(so(ii));
        % Pulls a random orientation value from ref_matrix
     
    % Generate random tilts
    tilt = (min_tilt - max_tilt) .* rand(2,1) + max_tilt;
        % Generates two random values, one for each gabor
        % max_tilt sets what the highest possible value is, min_tilt sets
        % what the lowest possible value is.
        % These are used to define orientation relative to the reference
    
    % Define gabor orientations
    tiltInDegrees(1) = data(ii,1) + tilt(1); 
        % The tilt of the first grating in degrees.
    tiltInRadians(1) = tiltInDegrees(1) * pi / 180; 
        % The tilt of the first grating in radians.
        
    tiltInDegrees(2) = data(ii,1) + tilt(2); 
        % The tilt of the first grating in degrees.
    tiltInRadians(2) = tiltInDegrees(2) * pi / 180; 
        % The tilt of the first grating in radians.
    
    % Create sin waves 
    cos_waves(1) = cos(tiltInRadians(1)) .* radiansPerPixel;
    sin_waves(1) = sin(tiltInRadians(1)) .* radiansPerPixel;
    
    cos_waves(2) = cos(tiltInRadians(2)) .* radiansPerPixel;
    sin_waves(2) = sin(tiltInRadians(2)) .* radiansPerPixel;
    
    % Converts meshgrid into a sinusoidal grating, where elements
    % along a line with angle theta have the same value and where the
    % period of the sinusoid is equal to "pixelsPerPeriod" pixels.
    % Note that each entry of gratingMatrix varies between minus one and
    % one; -1 <= gratingMatrix(x0, y0)  <= 1
    % Creates sin wave grating: multiply each x value with cosine and each y
    % value with the sine
    % Luminance value at each pixel is given as the product of the underling
    % matrix from the meshgrid and the sine or cosine
    gratingMatrix{1} = sin(cos_waves(1) * x + sin_waves(1) * y);
    gratingMatrix{2} = sin(cos_waves(2) * x + sin_waves(2) * y);
    
    % To visualize actual gabors, multiplying sine wave grating and curve shaped
    % envelope is needed
    imageMatrix{1} = gratingMatrix{1} .* circularGaussianMaskMatrix;
    imageMatrix{2} = gratingMatrix{2} .* circularGaussianMaskMatrix;
    
%     % Generate central fixation point
%     fixationpoint = zeros(widthOfGrid + 1, halfWidthOfGrid);
%         % Establish fixation point matrix
%     fixationpoint(:,:) = 255;
%         % Set entire matrix to white
%     center_x = [(halfWidthOfGrid / 2) - 1, halfWidthOfGrid / 2, (halfWidthOfGrid / 2) + 1];
%     center_y = [halfWidthOfGrid - 1, halfWidthOfGrid, halfWidthOfGrid + 1];
%     fixationpoint(center_x,center_y) = 0;
        % Set center point of matrix to black
%     someGabors = cat(2, imageMatrix{1}, fixationpoint, imageMatrix{2});

        % This implementation of the fixation point didn't work, for
        % reasons that are frankly beyond me. Gotta love Psychtoolbox,
        % right? (No. No you don't.)
    
    someGabors = cat(2, imageMatrix{1}, imageMatrix{2});

    % Multiply with gray to put gabor on gray background
    grayGabor = gray + absoluteDifferenceBetweenWhiteAndGray * someGabors;
    
    gaborID(ii) = Screen('MakeTexture', window, grayGabor);
        % Essentially establishes a handle for each pair of gabors; allows
        % for quick drawing during actual stimulus presentation
    
    data(ii,2:3) = [tilt(1) tilt(2)];
        % Stores tilt values in the data array
    
    DrawFormattedText(window,['Loading Gabors: ', ...
        int2str(round((ii/total_trials)*100)),'%'],'center', 'center')
        % Shows progress meter on screen
        
    Screen('Flip', window);  %show text
end

%% Run Trials

DrawFormattedText(window,'Press any key to start', 'center', 'center')
Screen('Flip', window)
KbWait([], 3);
pause(0.5)

for trial = 1:total_trials
    Screen('DrawTexture', window, gaborID(trial));
    Screen('Flip', window);
        % Draws a gabor pair on screen
   
    [secs, keyCode, deltaSecs] = KbWait([], 3);
        % Wait for the participant to press a response key
    key_value = find(keyCode);
        % Finds id number for a given key
    
    if key_value == cl_wise
        data(trial, 4) = 1;
            % If the key pressed was the cl_wise key, then data col 4
            % equals 1
    elseif key_value == wid_wise
        data(trial, 4) = 0;
            % If the key pressed was the wid_wise key, then data col 4
            % equals 0
    else
        data(trial, 4) = 2;
            % If a wrong key was pressed, then col 4 equals 2
    end
    
    Screen('Flip', window);
        % Clears gabors
    
    pause(iti)
        % Inter-trial interval
end

%% Clean-Up

Screen('CloseAll');
    % Closes all screens
ListenChar(1);
    % Re-enables keyboard output to command window
    % If keyboard output DOESN'T work, hit Ctrl-C
    
%% Data Processing
% Determine accuracy for each trial
for ii = 1:total_trials
    if data(ii, 2) < data(ii, 3) && data(ii, 4) == 1
        data(ii, 5) = 1;
            % If the tilt of the right gabor (3rd col) was greater than the
            % left gabor (2nd col), that means it was a clockwise difference
            % This marks col 5 with a 1 to indicate that the participant's
            % response was correct.
    elseif data(ii, 2) > data(ii, 3) && data(ii, 4) == 0
        data(ii, 5) = 1;
            % If the tilt of the right gabor (3rd col) was LESS than the
            % left gabor (2nd col), that means it was a counter-clockwise 
            % difference
            % This marks col 5 with a 1 to indicate that the participant's
            % response was correct.
    else
        data(ii, 5) = 0;
            % If the response was wrong, put a 0 in col 5
    end
end

% Split up data by condition
data_split = cell(length(ref), 1);
    % Creates cell array for data; one cell per condition
for ii = 1:length(ref)
    [index_r, index_c] = find(data(:,1) == ref(ii));
        % Finds index values of all trials in condition ii
    data_split{ii} = data(index_r,:);
        % Creates array containing all of the data for every trial in
        % condition ii
end

% Calculate orientation differences
diff_data = cell(length(ref),1);
    % Creates cell array for data; one cell per condition
for ii = 1:length(ref)
    diff_data{ii} = round(abs(data_split{ii}(:, 2) - data_split{ii}(:, 3)));
        % Finds absolute difference in orientation between gabors and
        % rounds to the nearest integer; this effectively bins the data
    diff_data{ii} = cat(2,diff_data{ii}, data_split{ii}(:,5));
        % diff_data is now a two column matrix with the absolute difference
        % between the two gabor orientations in column one and
        % participant's response accuracy in column two
end

% Find percent correct for each bin of difference data
uni_c = 1;
    % Start a counter to go through conditions
per_data = cell(length(ref),1);
    % Creates cell array for data; one cell per condition
while uni_c <= length(ref)
    % While uni_c is less than or equal to number of conditions
uni_diff = unique(diff_data{uni_c}(:,1));
    % Finds all unique diff values for a given diff_data array
per_cor = zeros(length(uni_diff),1);
    % Sets this per_cor array to be the same size as uni_diff
    for ii = 1:length(uni_diff)
        % Run this for loop for every unique difference value
        [index_r, index_c] = find(diff_data{uni_c}(:,1) == uni_diff(ii));
            % Finds trials that used a given difference value
        total = length(index_r);
            % Finds total number of trials that used a given uni_diff
        correct = find(diff_data{uni_c}(index_r,2) == 1);
            % Finds linear index of correct trials for a given difference
            % value
            % Checks second column of all rows identified in the last find
            % call for an indication of an accurate trial
        if isempty(correct) ~= 1
            % If correct has data in it
            correct = length(correct);
                % Converts linear indicies to a raw count of number correct
            per_cor(ii) = correct / total;
                % Finds percent of correct trials for a given difference
            per_cor(ii) = per_cor(ii) .* 100;
                % Converts decimal to a whole number
        else
            per_cor(ii) = 0;
                % If correct is empty, that means the participant didn't
                % get anything correct.
        end
    end
per_data{uni_c} = cat(2,uni_diff,per_cor);
    % Makes two column matrix with unique difference values and percentage
    % of correct response for trials with those difference values and puts
    % it in per_data
uni_c = uni_c + 1;
end

% End Result: per_data has four cells, one for each condition, each
% containing the rounded, absolute differences in orientation seen between
% the two gabors during the trial and the percentage of correct response
% for each.

%% Plot
% Makes some bar graphs
graphs = figure;
hold on

for ii = 1:length(ref)
    subplot(2,2,ii)
    bar(per_data{ii}(:,1), per_data{ii}(:,2))
        % Graphs differences vs accuracy
    set(gca, 'Ylim', [0 100], 'Xlim', [0 10], 'Xtick', [0:1:10])
        % Sets limits on the X and Y axis, and sets the values shown on the
        % x-axis.
    line([0 10], [75 75], 'LineStyle', '--', 'Color', 'b')
        % Shows a dashed blue line at the threshold point
    ylabel('Percent Correct')
    xlabel('Absolute, Rounded Difference in Orientation')
    switch ii
        % Subplot specific titles
        case 1
            title('Percent of Correct Responses for Vertical Line Reference')
        case 2
            title('Percent of Correct Responses for Horizontal Line Reference')
        case 3
            title('Percent of Correct Responses for Oblique Line (45 Degrees)')
        case 4
            title('Percent of Correct Responses for Oblique Line (145 Degrees)')
    end
end

%% Spike
% Unused script

% % Disable keys for KbCheck    
% key_vector = 1:256;
% key_vector(cl_wise) = [];
% key_vector(wid_wise) = [];
% olddisabledkeys = DisableKeysForKbCheck(key_vector);
%     % Disables ALL keys except for the defined participant response keys
%     % for KbCheck; this means that only cl_wise and wid_wise will progress
%     % the experiment.

% switch key_value
%         case cl_wise
%             data(trial, 4) = 1;
%         case wid_wise
%             data(trial, 4) = 0;
%     end