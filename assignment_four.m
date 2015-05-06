%% Header
% This script displays a grid of 16 rectangles and performs a Posner
% paradigm test of reaction time.
% Scientific Programming, Spring 2015, Assignment 4
% Course taught by Pascal Wallisch
% Isaac Purton, 4/6/2015

%% Housekeeping, Key Variables
clear all
close all
clc

delay_1 = 0.100;
delay_2 = 0.300;
rec_num = 16;
% trial_amt = 20;
trial_amt = 80;
    % Number of trials per cue location
total_trials = rec_num .* trial_amt;

scrsz = get(0,'ScreenSize');
    % Gets details about current screen
    
break_trial = total_trials/2;
    % Defines a break trial for the experiment

names = cell(rec_num,1);
for ii = 1:rec_num
    names{ii} = ['rec_' int2str(ii)];
        % Generates identifying names; used for 'Tag' property of drawn
        % rectangles.
end

%% Generate Stimuli Display
grid = figure;
set(gca, 'Xlim', [1 5], 'Ylim', [1 5])
axis square
axis off
hold on
set(grid,'visible','off')
    % Makes grid invisible

% Set up positions
positions = zeros(16,4);
positions(1:4,:) = 1;
positions(1:4,1) = 1:4;
positions(5:8,:) = positions(1:4,:);
positions(5:8,2) = positions(5:8,2) + 1;
positions(9:12,:) = positions(5:8,:);
positions(9:12,2) = positions(9:12,2) + 1;
positions(13:16,:) = positions(9:12,:);
positions(13:16,2) = positions(13:16,2) + 1;
    % positions schematic:
    %      1     1     1     1
    %      2     1     1     1
    %      3     1     1     1
    %      4     1     1     1
    %      1     2     1     1
    %      2     2     1     1
    %      3     2     1     1
    %      4     2     1     1
    %      1     3     1     1
    %      2     3     1     1
    %      3     3     1     1
    %      4     3     1     1
    %      1     4     1     1
    %      2     4     1     1
    %      3     4     1     1
    %      4     4     1     1

% Draw rectangles
rec = zeros(rec_num,1);
for ii = 1:rec_num
    rectangle('Position', positions(ii,:), 'Tag', names{ii}, ...
        'FaceColor', [1 1 1], 'UserData', positions(ii,1:2))
        % Plots a grid of rectangles according to the appropriate position
        % values, and assigns a name-tag.
        % Also assigns a coordinate value in UserData, containing the x,y
        % coordinate of the box; this is used to calculate distances later
        % on.
    rec(ii) = findobj(grid,'Tag',names{ii});
        % This allows individual rectangles to be called via rec(ii);
        % workaround for being unable to set handles within a for loop.
        % Unique rectangle is found by querying its assigned name-tag
end
hold off
    % rec diagram
    %   rec(13) rec(14) rec(15) rec(16)
    %   rec(9)  rec(10) rec(11) rec(12)
    %   rec(5)  rec(6)  rec(7)  rec(8)
    %   rec(1)  rec(2)  rec(3)  rec(4)

%% Trial Generator/Information

cue_id = [];
temp = (1:rec_num)';
for ii = 1:trial_amt
    cue_id = cat(1, cue_id, temp);
        % Creates x number of instances of each value in the vector
        % 1:rect_num, where x = number of trials per cue location.
        % cue_id is the vector 1:#_of_rectangles repeated x times.
end
cue_id = sort(cue_id);
    % Sorts cue_id, such that 1:80 is 1, 81:160 is 2, and so on

time_delay_prep = zeros(trial_amt,1);
time_delay_prep(1:trial_amt/2) = delay_1;
time_delay_prep(find(time_delay_prep == 0,1,'first'):end) = delay_2;
    % Creates a vector of length x (x = trial_amt), with half of its values
    % being delay_1 and the other half being delay_2
    % Delay_2 is assigned by finding the first value that isn't Delay_1
time_delay = [];
for ii = 1:rec_num
    time_delay = cat(1, time_delay, time_delay_prep);
        % Creates a vector of length trial_amt * rect_num (equal to total
        % trials), consisting of time_delay_prep repeated.
end

valid_id_prep = zeros(trial_amt/2,1);
    % 40 (trial_amt/2) 0s
valid_id_prep(1:trial_amt/4) = 1;
    % 20 1s, 20 0s
valid_id_prep_two = cat(1, valid_id_prep, valid_id_prep);
    % Creates vector of 20 0s, 20 1s, 20 0s, 20 1s
valid_id = [];
for ii = 1:rec_num
    valid_id = cat(1, valid_id, valid_id_prep_two);
end

trial_info = cat(2,cue_id,time_delay,valid_id);

% cue_id determines what rectangle serves as the cue
% time_delay determines how long it takes target to appear
% valid_id determines whether target is presented at the same place as the
% cue

%% Trial Variables

so = randperm(total_trials);
    % Vector with values from 1 to total_trials in a random order.
    % Allows for random selection from the trial_info matrix
    
data = zeros(total_trials,5);
    % Initializes data matrix, with spots for cue location, time delay,
    % whether trial was valid or invalid, location of target, and response 
    % time.
    
%% Instructions
instr = figure;
set(gca, 'Xlim', [1 5], 'Ylim', [1 5])
axis square
axis off
hold on

sample = rectangle('Position', [2.5 3 1 1], 'FaceColor', [1 0 0]);
tex1 = text(3,4.5,'This is your cue','HorizontalAlignment','center');
tex2 = text(3,1.5,'Press any key to show next screen',...
    'HorizontalAlignment','center');
pause

delete(tex1,tex2)
set(sample,'FaceColor', [0 1 0])
text(3,4.5,'This is your target','HorizontalAlignment','center')
text(3,2.5,'Press any key when you see this target during the trials',...
    'HorizontalAlignment','center')
text(3,1.5,'Press any key to start the trials',...
    'HorizontalAlignment','center')
pause

close(instr)

%% Trial Loop
figure(grid)
    % Calls grid figure back to forefront
set(grid,'visible','on')
hold on
for trial = 1:total_trials
    disp(trial);
        % User feedback of current trial number
    trial_id = so(trial);
        % Determines a random row of trial_info to use for this trial loop.
        % This is what provides the random order of trials.
    data(trial,1:3) = trial_info(trial_id,:);
        % Prints cue id, time delay, and valid/invalid (1 or 0) into data.
    set(rec(trial_info(trial_id,1)), 'FaceColor', [1 0 0])
        % Sets the rectangle identifed by cue_id to have a face value
        % of red.
    pause(0.3)
        % Displays cue for 0.3s
    set(rec(trial_info(trial_id,1)), 'FaceColor', [1 1 1])
        % Resets target rectangle to white.
    pause((trial_info(trial_id,2)))
        % Pauses for appropriate amount of time (delay 1 or 2).
    switch trial_info(trial_id,3)
        case 1
            % If this is a 'valid' trial, set the cue rectangle as the
            % target.
            set(rec(trial_info(trial_id,1)), 'FaceColor', [0 1 0])
                % Sets targer face color to green
            tic
                % Start timer
            pause
                % Waits for participant input.
            data(trial,5) = toc;
                % Captures amount of time it took for participant to search
                % for target and press a key.
                % Actual key pressed is irrelevant due to the nature of the
                % experiment.
            data(trial,4) = trial_info(trial_id,1);
                % Valid trial, so location of target = location of cue
            set(rec(trial_info(trial_id,1)), 'FaceColor', [1 1 1])
                % Resets target rectangle to white.
        case 0
            % If this is an 'invalid' trial, set the target rectangle to a
            % random target that isn't the cue rectangle.
            alt_target = randperm(16);
            temp = find(alt_target ~= trial_info(trial_id,1),1,'first');
                % Finds the index for the first value in alt_target that
                % isn't the cue.
            set(rec(alt_target(temp)), 'FaceColor', [0 1 0])
                % Sets a random rectangle's face color to green
            tic
                % Start timer
            pause
                % Waits for participant input.
            data(trial,5) = toc;
                % Captures amount of time it took for participant to search
                % for target and press a key.
                % Actual key pressed is irrelevant due to the nature of the
                % experiment.
            data(trial,4) = alt_target(temp);
                % Prints location of target
            set(rec(alt_target(temp)), 'FaceColor', [1 1 1])
                % Resets target rectangle to white.
    end
    if trial == break_trial
        disp('Take a break! Press any key to continue with trial.')
        pause
            % At the break trial, allow for a break
    else
        pause(0.3)
        % Brief pause before next cue is presented
    end
end
set(grid,'visible','off')

%% Data Organization
data_org = cell(4,1);
data_org{1} = zeros(total_trials,5);
data_org{2} = zeros(total_trials,5);
data_org{3} = zeros(total_trials,5);
data_org{4} = zeros(total_trials,5);
for ii = 1:length(data)
    if data(ii,2) == delay_1
        data_org{1}(ii,:) = data(ii,:);
            % data{1} = data with a delay=delay_1
    elseif data(ii,2) == delay_2
        data_org{2}(ii,:) = data(ii,:);
            % data{2} = data with a delay=delay_2
    end
    if data(ii,3) == 1
        data_org{3}(ii,:) = data(ii,:);
            % data{3} = data with valid targets
    elseif data(ii,3) == 0
        data_org{4}(ii,:) = data(ii,:);
            % data{4} = data with invalid targets
    end
end

for ii = 1:4
    killlist = find(data_org{ii}(:,1) == 0);
        % Finds row indicies of rows where data was not printed in the
        % prior for loop.
    data_org{ii}(killlist,:) = [];
        % Deletes rows of null data
end

%% Calculations
% T-tests
[hypothesis_test_for_delay, p_value, CI, detailed_stats] = ... 
    ttest(data_org{1}(:,5),data_org{2}(:,5))
    % t-test of trials with delay_1 vs trials with delay_2
[hypothesis_test_for_location, p_value, CI, detailed_stats] = ...
    ttest(data_org{3}(:,5),data_org{4}(:,5))
    % t-test of valid trials vs invalid trials

% Distances
distances = zeros(total_trials/2,3);
    % Invalid trials were presented half the time, thus this should be as
    % long as total_trials/2
for ii = 1:total_trials/2
    a = get(rec(data_org{4}(ii,1)),'UserData');
        % Gets coordinates of the cue
    b = get(rec(data_org{4}(ii,4)),'UserData');
        % Gets coordinates of the target
    distances(ii,1) = abs(a(1) - b(1));
        % Horizontal distance
    distances(ii,2) = abs(a(2) - b(2));
        % Vertical distance
    distances(ii,3) = sqrt(distances(ii,1)^2 + distances(ii,2)^2);
        % Calculates total distance
end

distances = cat(2,distances,data_org{4}(:,5));
    % Distances and response time in a single matrix

dist_data = cell(3,1);
sum_stats = cell(3,1);
for ii = 1:3
    dist_data{ii} = sortrows(distances,ii);
        % Creates sorted matricies for horizontal, vertical, and total
        % distance.
    switch ii
        case 1
            dist_data{1}(:,2:3) = [];
        case 2
            dist_data{2}(:,1:2:3) = [];
        case 3
            dist_data{3}(:,1:2) = [];
    end
        % Deletes unneeded columns
    temp = unique(dist_data{ii}(:,1));
        % Finds unique values for distances column
    sum_stats{ii} = zeros(length(temp),2);
        % Initialize sum_stats with the needed length to store all values
    sum_stats{ii}(:,1) = temp;
        % Prints distance categories
    sum_stats{ii}(:,2) = grpstats(dist_data{ii}(:,2),dist_data{ii}(:,1));
        % Finds mean rt for each distance level
end

%% Plotting
graphs = figure;
hold on
set(graphs,'Position', [1, 1, scrsz(3), scrsz(4)])
    % Sets figure dimentions to be equal to screen size

for ii = 1:3
    subplot(1,3,ii)
    hold on
    scatter(dist_data{ii}(:,1),dist_data{ii}(:,2), 'k')
        % Scatter plot of rt values by distance
    plot(sum_stats{ii}(:,1), sum_stats{ii}(:,2), 'LineStyle', '--',...
        'Marker', 'd', 'MarkerSize', 10, 'Color', 'r')
        % Plot of mean rt values by distance
    ylabel('Reaction Time')
    xlabel('Distance')
    switch ii
        case 1
            title('Reaction time as a function of horizontal distance between cue and target stimuli')
            set(gca, 'Xlim', [0 4], 'XTick', [0:1:5], 'YLim', [0 1])
        case 2
            title('Reaction time as a function of vertical distance between cue and target stimuli')
            set(gca, 'Xlim', [0 4], 'XTick', [0:1:5], 'YLim', [0 1])
        case 3
            title('Reaction time as a function of total distance between cue and target stimuli')
            set(gca, 'Xlim', [0 6], 'YLim', [0 1])
    end
end