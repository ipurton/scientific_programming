%% Header
% Photo-detection experiment
% Scientific Programming, Spring 2015, Assignment 3
% Course taught by Pascal Wallisch
% Isaac Purton, 3/30/2015

%% Housekeeping

clear all
close all
clc

trial_amt = 5;
    % Number of trials for each brightness level
bright_levels = [15 30 45 60 75 90 105 120 135 150]';
    % Brightness values for experiment
    % Increased values due to difficulty seeing low values for the colored
    % lights.
thresh_prob = 0.75;
    % Probability threshold
stim_order = [];
for ii = 1:trial_amt
	stim_order = cat(1,stim_order,bright_levels);
        % Creates ii number of trials for each brightness level
        % Single vector of bright_levels repeated for the amt in trial_amt
        % variable. Brightness levels are randomized prior to each
        % experimental block.
        % Format: column
end
data = {};
scrsz = get(0,'ScreenSize');
    % Gets details about current screen

display = uint8(zeros(400,400,3));
    % Initializes display variable, 400x400px
display(200,200,:) = 255;
    % Sets fixation point at center of display
    
%% Show Instructions
startup = figure;
set(startup,'visible','off')
set(startup,'Position', [400, 400, scrsz(3)/2, scrsz(4)/2])
    % Centers figure window on screen
set(startup,'ToolBar','none')
    % Omits figure toolbar

hold on
display(240,200,:) = 255;
    % Sample trial point.
image(display)
axis image
axis off
instr = text(200,375,'Welcome!');
set(instr,'color','w','HorizontalAlignment','center')
instr2 = text(10,240,['Press Y' 10 'if you can see         ->' 10 ...
    'the top light.']);
set(instr2,'color','w','HorizontalAlignment','left')
instr3 = text(390,240,['Press N' 10 '<-     if you cannot see' 10 ...
    'the top light.']);
set(instr3,'color','w','HorizontalAlignment','right')
instr3 = text(200,50,'Press any key to start experiment.');
set(instr3,'color','w','HorizontalAlignment','center')
set(startup,'visible','on')
pause
close(startup)
    % Displays instructions in a figure until participant initiates
    % experiment by pressing any key.
    
display(240,200,:) = 0;
    % Sets trial point back to 0.

%% Experiment
%% White trials
data{1} = zeros(length(stim_order),2);
    % Initializes data array
stim_order_rand = stim_order(randperm(length(stim_order)));
    % Randomizes stim_order
img_fig = figure;
% Establishes figure for display image.
hold on
set(img_fig,'Position', [400, 400, scrsz(3)/2, scrsz(4)/2])
    % Centers figure window on screen
set(img_fig,'ToolBar','none')
    % Omits Figure toolbar
for trial = 1:length(stim_order)
    disp(trial);
        % Shows current trial
	display(240,200,:) = uint8(stim_order_rand(trial));
        % Assigns appropriate bright_level to a point 40pxs above the
        % fixation. Color = white.
	image(display)
        % Turns display variable into an image
    axis image
    axis off
    set(img_fig,'visible','on')
	pause
	captured_stroke = get(img_fig,'CurrentCharacter');
        % Captures the character the person types in reply to the figure
    set(img_fig,'visible','off')
	if strcmp(captured_stroke, 'y') == 1
		data{1}(trial,2) = 1;
            % Prints 1 if the person responded 'yes'
    else
        data{1}(trial,2) = 0;
            % Prints 0 if the person responded 'no'
    end
	data{1}(trial,1) = stim_order_rand(trial);
        % Prints trial bright_level in data array
    pause(1)
        % Pauses before next trial
end

%% Red trials
data{2} = zeros(length(stim_order),2);
    % Initializes data array
stim_order_rand = stim_order(randperm(length(stim_order)));
    % Randomizes stim_order
display(240,200,:) = 0;
    % Resets trial point to black
for trial = 1:length(stim_order)
    disp(trial);
	display(240,200,1) = uint8(stim_order_rand(trial));
        % Assigns appropriate bright_level to a point 40pxs above the
        % fixation. Color = red.
	image(display)
        % Turns display variable into an image
    axis image
    axis off
    set(img_fig,'visible','on')
	pause
	captured_stroke = get(img_fig,'CurrentCharacter');
        % Captures the character the person types in reply to the figure
    set(img_fig,'visible','off')
	if strcmp(captured_stroke, 'y') == 1
		data{2}(trial,2) = 1;
            % Prints 1 if the person responded 'yes'
    else
        data{2}(trial,2) = 0;
            % Prints 0 if the person responded 'no'
    end
	data{2}(trial,1) = stim_order_rand(trial);
        % Prints trial bright_level in data array
    pause(1)
end

%% Green trials
data{3} = zeros(length(stim_order),2);
    % Initializes data array
stim_order_rand = stim_order(randperm(length(stim_order)));
    % Randomizes stim_order
display(240,200,:) = 0;
    % Resets trial point to black
for trial = 1:length(stim_order)
    disp(trial);
	display(240,200,2) = uint8(stim_order_rand(trial));
        % Assigns appropriate bright_level to a point 40pxs above the
        % fixation. Color = green.
	image(display)
        % Turns display variable into an image
    axis image
    axis off
    set(img_fig,'visible','on')
	pause
	captured_stroke = get(img_fig,'CurrentCharacter');
        % Captures the character the person types in reply to the figure
    set(img_fig,'visible','off')
	if strcmp(captured_stroke, 'y') == 1
		data{3}(trial,2) = 1;
            % Prints 1 if the person responded 'yes'
    else
        data{3}(trial,2) = 0;
            % Prints 0 if the person responded 'no'
    end
	data{3}(trial,1) = stim_order_rand(trial);
        % Prints trial bright_level in data array
    pause(1)
end

%% Blue trials
data{4} = zeros(length(stim_order),2);
    % Initializes data array
stim_order_rand = stim_order(randperm(length(stim_order)));
    % Randomizes stim_order
display(240,200,:) = 0;
    % Resets trial point to black
for trial = 1:length(stim_order)
    disp(trial);
	display(240,200,3) = uint8(stim_order_rand(trial));
        % Assigns appropriate bright_level to a point 40pxs above the
        % fixation. Color = blue.
	image(display)
        % Turns display variable into an image
    axis image
    axis off
    set(img_fig,'visible','on')
	pause
	captured_stroke = get(img_fig,'CurrentCharacter');
        % Captures the character the person types in reply to the figure
    set(img_fig,'visible','off')
	if strcmp(captured_stroke, 'y') == 1
		data{4}(trial,2) = 1;
            % Prints 1 if the person responded 'yes'
		else
			data{4}(trial,2) = 0;
                % Prints 0 if the person responded 'no'
    end
	data{4}(trial,1) = stim_order_rand(trial);
        % Prints trial bright_level in data array
    pause(1)
end
close all

%% Data Organization/Calculation
sort_data = {};

% White Data
sort_data_white = sortrows(data{1},1);
    % Sorts data for white trials by bright levels in ascending order
white_count = zeros(10,3);
    % Establishes matrix for counting number of 'y' responses
white_count(:,1) = bright_levels;
    % Prints bright_levels in first col
lower_bound = 1;
counter = 1;
for upper_bound = 5:5:50
    white_count(counter,2) = ...
        sum(sort_data_white(lower_bound:upper_bound,2));
        % Sums column 2 of sort_data_white in increments of 5.
        % Ex. first loop, sum rows 1:5, which is equivalent to the 5
        % trials with the first bright_level.
    white_count(counter,3) = white_count(counter,2) ./ 5;
        % Calculates probability of trial dot being reported as seen
    lower_bound = upper_bound + 1;
    counter = counter + 1;
end
sort_data{1} = white_count;
    % Stores white_count data in a cell array; this is used for quicker
    % determination of threshold (see below).

%Red Data
sort_data_red = sortrows(data{2},1);
    % Sorts data for red trials by bright levels in ascending order
red_count = zeros(10,2);
red_count(:,1) = bright_levels;
lower_bound = 1;
counter = 1;
for upper_bound = 5:5:50
    red_count(counter,2) = sum(sort_data_red(lower_bound:upper_bound,2));
    red_count(counter,3) = red_count(counter,2) ./ 5;
    lower_bound = upper_bound + 1;
    counter = counter + 1;
end
sort_data{2} = red_count;

% Green Data
sort_data_green = sortrows(data{3},1);
    % Sorts data for green trials by bright levels in ascending order
green_count = zeros(10,2);
green_count(:,1) = bright_levels;
lower_bound = 1;
counter = 1;
for upper_bound = 5:5:50
    green_count(counter,2) = ...
        sum(sort_data_green(lower_bound:upper_bound,2));
    green_count(counter,3) = green_count(counter,2) ./ 5;
    lower_bound = upper_bound + 1;
    counter = counter + 1;
end
sort_data{3} = green_count;

% Blue Data
sort_data_blue = sortrows(data{4},1);
    % Sorts data for blue trials by bright levels in ascending order
blue_count = zeros(10,2);
blue_count(:,1) = bright_levels;
lower_bound = 1;
counter = 1;
for upper_bound = 5:5:50
    blue_count(counter,2) = sum(sort_data_blue(lower_bound:upper_bound,2));
    blue_count(counter,3) = blue_count(counter,2) ./ 5;
    lower_bound = upper_bound + 1;
    counter = counter + 1;
end
sort_data{4} = blue_count;

%% Find Thresholds
% Each _count matrix has three columns: brightness, count of yes, % of yes
thresholds = zeros(4,2);
for ii = 1:4
    highs = [];
        % Resets highs to an empty matrix
    highs = find(sort_data{ii}(:,3) >= thresh_prob, 1, 'first');
        % Finds the row index of the first percentage higher than 0.75
    if isempty(highs) == 1
        thresholds(ii,:) = 0;
        % If no percentages were collected at the .75 level, print 0 in
        % thresholds.
    else
        thresholds(ii,:) = sort_data{ii}(highs(1),1:2:3);
        % Prints the threshold coordinate (brightness,percentages) in
        % thresholds, using highs(1) as the row index, taking only columns
        % 1 and 3.
    end
end
% Thresholds 1 = white, 2 = red, 3 = green, 4 = blue

%% Plot Data
graphs = figure;
hold on
set(graphs,'Position', [1, 1, scrsz(3), scrsz(4)])
    % Sets figure dimentions to be equal to screen size
for ii = 1:4
    subplot(2,2,ii)
        % Establish subplot
    hold on
    plot(sort_data{ii}(:,1), sort_data{ii}(:,3), 'ko-');
        % Plots a black, solid line with brightness as the x values and 
        % prob seen as the y. Circles at data points.
    if thresholds(ii,1) ~= 0
        plot([0, thresholds(ii,1)],[thresholds(ii,2), thresholds(ii,2)],...
            'b--')
            % Plots a horizontal line running from x = 0 to x =
            % bright_level, at y = probability for the appropriate
            % threshold.
        plot([thresholds(ii,1), thresholds(ii,1)],[0, thresholds(ii,2)],...
            'b--')
            % Plots a vertical line running from y = 0 to y = probability
            % at x = bright_level for the appropriate threshold.
    end
    set(gca, 'XTick', bright_levels, 'ylim', [0 1],'YTick', 0:0.1:1)
        % Sets displayed values on the x and y axes, as well as y limits.
    ylabel('Probability reported seen')
    xlabel('Brightness')
    switch ii
        % Depending on the value of ii, assign the appropriate title to a
        % single subplot.
        case 1
            % If ii == 1...
            title('Probability of reporting a single white pixel as visible at varying brightness levels.')
        case 2
            title('Probability of reporting a single red pixel as visible at varying brightness levels.')
        case 3
            title('Probability of reporting a single green pixel as visible at varying brightness levels.')
        case 4
            title('Probability of reporting a single blue pixel as visible at varying brightness levels.')
    end
end
