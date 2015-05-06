%% Header
% Collect data from a basic visual search experiment
% Scientific Programming, Spring 2015, Assignment 2
% Course taught by Pascal Wallisch
% Isaac Purton, 3/22/2015

%% Housekeeping
clear all
close all
clc

rng('default')
    % Resets random number generator to its default value

scrsz = get(0,'ScreenSize');
    % Gets size of current monitor

data = {};
for ii = 1:8
    data{ii} = zeros(20,3);
        % Initializes data variable with 8 cells, one for each block
end
stim_order = [1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];
    % Initializes template stim_order; length = 20
    % stim_order determines whether or not a target is present in a given
    % trial.
stim_order_rand = zeros(160,1);
    % Initializes stim_order_rand variable
jj = 20;
    % Initializes counter jj
for ii = 1:20:160
    stim_order_rand(ii:jj) = stim_order(randperm(length(stim_order)));
    jj = jj + 20;
end
    % Creates a 160-length vector consisting of 8, 20-length vectors.
    % Each of those 20-length vectors is a randomized stim_order specific
    % to each block of trials.
%% DATA COLLECTION
% Show Instruction screen
startup = figure;
set(startup,'visible','off')
set(startup,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, scrsz(4)/2])
    % Centers figure window on screen
set(startup,'ToolBar','none')
    % Omits Figure toolbar

hold on
instr = text(0.5,0.9,'Your target is:');
set(instr,'color','k','HorizontalAlignment','center')
target = text(0.5,0.8,'O');
set(target,'color','r','fontsize',20,'HorizontalAlignment','center')
instr2 = text(0.5,0.6,'Press A if target is present.');
set(instr2,'color','k','HorizontalAlignment','center')
instr3 = text(0.5,0.4,'Press K if target is not present.');
set(instr3,'color','k','HorizontalAlignment','center')
set(startup,'visible','on')
pause(10)
hold off
close(startup)
    % Displays instructions in a figure for 10 seconds (using pause),
    % then closes that figure.
k = 1;
    % Initializes counter k; this is used to keep the code for storing data
    % consistent.
%% Block of 4 item Pop-out (20 trials)
for ii = 1:20
    jj = 1;
        % Initialize a counter used for drawing stimuli
    display = figure;
        % Initializes trial figure
    set(display,'visible','off')
        % Sets figure to be invisible
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
        % Centers figure window
    set(display,'ToolBar','none')
        % Disables toolbar in window
    hold on
    while jj <= 4
        % Draws four objects in figure
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
            % Draws target if the stim_order_rand value for this trial is 1
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'O');
            set(t,'color','g','fontsize',20)
            % If the stim_order_rand value for this trial is 0, doesn't
            % draw target.
        elseif jj == 2
            o = text(rand(1),rand(1),'O');
            set(o,'color','g','fontsize',20)
        elseif jj > 2
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
            % Increments jj
    end
    set(display,'visible','on')
        % Makes figure visible after all stimuli have been drawn
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
        % Stores rt value in data array once a character has been pressed
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
        % Prints 1 if target was present and captured stroke was correct
        % 'Hit'
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
        % Prints 2 if target was NOT present and cap. stroke was correct
        % 'Correct Rejection'
    else
        data{k}(ii,2) = 0;
        % Prints 0 if anything else is done
        % 'Miss'
    end
    data{k}(ii,3) = 4;
        % Prints set size
    close
end
k = k + 1;
    % Increments k
%% Block of 8 item Pop-out (20 trials)
for ii = 21:40
    jj = 1;
    display = figure;
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 8
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'O');
            set(t,'color','g','fontsize',20)
        elseif jj > 1 && jj <= 4
            o = text(rand(1),rand(1),'O');
            set(o,'color','g','fontsize',20)
        elseif jj >= 5
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 8;
    close
end
k = k + 1;
%% Block of 12 item Pop-out (20 trials)
for ii = 41:60
    jj = 1;
    display = figure;
    set(display,'visible','off')
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 12
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'O');
            set(t,'color','g','fontsize',20)
        elseif jj > 1 && jj <= 6
            o = text(rand(1),rand(1),'O');
            set(o,'color','g','fontsize',20)
        elseif jj >= 7
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 12;
    close
end
k = k + 1;
%% Block of 16 item Pop-out (20 trials)
for ii = 61:80
    jj = 1;
    display = figure;
    set(display,'visible','off')
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 16
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'O');
            set(t,'color','g','fontsize',20)
        elseif jj > 1 && jj <= 8
            o = text(rand(1),rand(1),'O');
            set(o,'color','g','fontsize',20)
        elseif jj >= 9
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 16;
    close
end
k = k + 1;
%% Block of 4 item Conjunction (20 trials)
for ii = 81:100
    jj = 1;
    display = figure;
    set(display,'visible','off')
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 4
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'X');
            set(t,'color','r','fontsize',20)
        elseif jj == 2
            o = text(rand(1),rand(1),'X');
            set(o,'color','r','fontsize',20)
        elseif jj == 3
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        elseif jj == 4
            g = text(rand(1),rand(1),'O');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 4;
    close
end
k = k + 1;
%% Block of 8 item Conjunction (20 trials)
for ii = 101:120
    jj = 1;
    display = figure;
    set(display,'visible','off')
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 8
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'X');
            set(t,'color','r','fontsize',20)
        elseif jj > 1 && jj <= 4
            o = text(rand(1),rand(1),'X');
            set(o,'color','r','fontsize',20)
        elseif jj == 5 || jj == 6
            g = text(rand(1),rand(1),'O');
            set(g,'color','g','fontsize',20)
        elseif jj == 7 || jj == 8
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 8;
    close
end
k = k + 1;
%% Block of 12 item Conjunction (20 trials)
for ii = 121:140
    jj = 1;
    display = figure;
    set(display,'visible','off')
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 12
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'X');
            set(t,'color','r','fontsize',20)
        elseif jj > 1 && jj <= 6
            o = text(rand(1),rand(1),'X');
            set(o,'color','r','fontsize',20)
        elseif jj > 6 && jj <= 9
            g = text(rand(1),rand(1),'O');
            set(g,'color','g','fontsize',20)
        elseif jj >= 10
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 12;
    close
end
k = k + 1;
%% Block of 16 item Conjunction (20 trials)
for ii = 141:160
    jj = 1;
    display = figure;
    set(display,'visible','off')
    set(display,'Position', [scrsz(3)/4, scrsz(4)/4, scrsz(3)/2, ...
        scrsz(4)/2])
    set(display,'ToolBar','none')
    hold on
    while jj <= 16
        if jj == 1 && stim_order_rand(ii) == 1
            t = text(rand(1),rand(1),'O');
            set(t,'color','r','fontsize',20)
        elseif jj == 1 && stim_order_rand(ii) == 0
            t = text(rand(1),rand(1),'X');
            set(t,'color','r','fontsize',20)
        elseif jj > 1 && jj <= 8
            o = text(rand(1),rand(1),'X');
            set(o,'color','r','fontsize',20)
        elseif jj >= 9 && jj <= 12
            g = text(rand(1),rand(1),'O');
            set(g,'color','g','fontsize',20)
        elseif jj >= 13
            g = text(rand(1),rand(1),'X');
            set(g,'color','g','fontsize',20)
        end
        jj = jj + 1;
    end
    set(display,'visible','on')
    tic
    pause
    captured_stroke = get(display,'CurrentCharacter');
    data{k}(ii,1) = toc;
    if strcmp(captured_stroke,'a') == 1 && stim_order_rand(ii) == 1
        data{k}(ii,2) = 1;
    elseif strcmp(captured_stroke,'k') == 1 && stim_order_rand(ii) == 0
        data{k}(ii,2) = 2;
    else
        data{k}(ii,2) = 0;
    end
    data{k}(ii,3) = 16;
    close
end
%% Data Cleaning/Organization
% data schematic: col 1 = rt, col 2 = hit/miss info, col 3 = set size

for ii = 1:8
    index = find(data{ii}(:,2) == 0);
    data{ii}(index,:) = [];
        % Deletes trials with a miss
end

% Create Matrix for Pop-Out trials
pop_data = cat(1,data{1:4});

% Create Matrix for Conjunction trials
conj_data = cat(1,data{5:8});

% Create Matrix for Pop-Out trials with a target
pop_tar_index = find(pop_data(:,2) == 1);
    % Finds rows with a hit, meaning trial was correct w/ target present
pop_tar_data = pop_data(pop_tar_index,:);
    % Creates new matrix with only hit trials
jj = 1;
pop_tar_mean = zeros(4,2);
    % Initializes matrix
for ii = 4:4:16
    % Counter is thus, 4, 8, 12, 16
    % This will generate four mean scores, one for each set size
    temp = find(pop_tar_data(:,3) == ii);
        % Finds row indicies for all trials with a given set size (ii)
    temp2 = pop_tar_data(temp,1);
        % Stores rt values for trials of a given set size
    pop_tar_mean(jj,1) = mean(temp2);
        % Stores the mean rt for a given set size in a vector
    pop_tar_mean(jj,2) = ii;
        % Prints set size in column two
    jj = jj + 1;
end

% Create Matrix for Pop-Out trials without a target
pop_no_tar_index = find(pop_data(:,2) == 2);
    % Finds rows with a correct rejection, meaning trial was correct w/o 
    % target present
pop_no_tar_data = pop_data(pop_no_tar_index,:);
    % Creates new matrix with only correct rejection trials
jj = 1;
pop_no_tar_mean = zeros(4,1);
for ii = 4:4:16
    temp = find(pop_no_tar_data(:,3) == ii);
    temp2 = pop_no_tar_data(temp,1);
    pop_no_tar_mean(jj) = mean(temp2);
    pop_no_tar_mean(jj,2) = ii;
    jj = jj + 1;
end

% Create Matrix for Conjunction trials with a target
conj_tar_index = find(conj_data(:,2) == 1);
conj_tar_data = conj_data(conj_tar_index,:);
jj = 1;
conj_tar_mean = zeros(4,1);
for ii = 4:4:16
    temp = find(conj_tar_data(:,3) == ii);
    temp2 = conj_tar_data(temp,1);
    conj_tar_mean(jj) = mean(temp2);
    conj_tar_mean(jj,2) = ii;
    jj = jj + 1;
end

% Create Matrix for Conjunction trials without a target
conj_no_tar_index = find(conj_data(:,2) == 2);
conj_no_tar_data = conj_data(conj_no_tar_index,:);
jj = 1;
conj_no_tar_mean = zeros(4,1);
for ii = 4:4:16
    temp = find(conj_no_tar_data(:,3) == ii);
    temp2 = conj_no_tar_data(temp,1);
    conj_no_tar_mean(jj) = mean(temp2);
    conj_no_tar_mean(jj,2) = ii;
    jj = jj + 1;
end

% Create summary matricies for target/no-target data
target_data = cat(1,pop_tar_data,conj_tar_data);
no_target_data = cat(1,pop_no_tar_data,conj_no_tar_data);
    
%% Report Data
% Means
pop_out_mean = mean(pop_data(:,1))
    % Prints mean rt for pop out trials
conj_mean = mean(conj_data(:,1))
    % Prints mean rt for conj trials
target_mean = mean(target_data(:,1))
    % Prints mean rt for trials with a target
no_target_mean = mean(no_target_data(:,1))
    % Prints mean rt for trials without a target

% Correlations
% Print four correlations with p-value:
% Target/Pop-out
[pop_out_with_target_correlation, p] = corrcoef(pop_tar_mean(:,1),...
    pop_tar_mean(:,2))
% Target/Conj
[conj_with_target_correlation, p] = corrcoef(conj_tar_mean(:,1),...
    conj_tar_mean(:,2))
% No Target/Pop-Out
[pop_out_without_target_correlation, p] = corrcoef(pop_no_tar_mean(:,1),...
    pop_no_tar_mean(:,2))
% No Target/Conj
[conj_without_target_correlation, p] = corrcoef(conj_no_tar_mean(:,1),...
    conj_no_tar_mean(:,2))

%% Draw Graphs
% Bar graphs
graphs = figure;
hold on
set(graphs,'Position', [1, 1, scrsz(3), scrsz(4)])
    % Sets figure dimentions to be equal to screen size

labels_1 = {'Pop Out' 'Conjunction'};
    % Creates labels for bars
set_one = [pop_out_mean conj_mean];
subplot(2,2,1)
    % Establish four subplots, puts this graph in top-left
hold on
type = bar(set_one);
    % Draw graph, assign handle
set(gca,'XLim',[0 3],'XTick',[1 2],'XTickLabel',labels_1)
    % Sets x-axis limit to 0 to 3, labels each bar appropriately
ylabel('Reaction Time')
xlabel('Mean Values')
title('Mean Reaction Times for Pop Out vs Conjunction Type Searches')
    % Labels/titles

labels_2 = {'Target Present' 'No Target'};
    % More labels
set_two = [target_mean no_target_mean];
subplot(2,2,2)
hold on
targ = bar(set_two);
set(gca,'XLim',[0 3],'XTick',[1 2],'XTickLabel',labels_2)
ylabel('Reaction Time')
xlabel('Mean Values')
title('Mean Reaction Times for Trials With vs Without a Valid Target')

% Line graphs
subplot(2,2,3)
hold on
w_targets_pop = plot(pop_tar_mean(:,2),pop_tar_mean(:,1),'bo-');
    % Draws a solid blue line for pop-out data, with 'o' at each data point
w_targets_conj = plot(conj_tar_mean(:,2),conj_tar_mean(:,1),'ro-');
    % Draws a solid red line for conj data, with 'o' at each data point
set(gca,'XTick',[4 8 12 16])
    % Sets visible x-ticks (x-values that appear on the x-axis)
ylabel('Mean Reaction Time')
xlabel('Set Size')
title('Reaction Time vs Set Size for Trials with Targets; Pop-Out: Blue, Conj: Red')

subplot(2,2,4)
hold on
wo_targets_pop = plot(pop_no_tar_mean(:,2),pop_no_tar_mean(:,1),'bo-');
wo_targets_conj = plot(conj_no_tar_mean(:,2),conj_no_tar_mean(:,1),'ro-');
set(gca,'XTick',[4 8 12 16])
ylabel('Mean Reaction Time')
xlabel('Set Size')
title('Reaction Time vs Set Size for Trials without Targets; Pop-Out: Blue, Conj: Red')