function [ std_col ] = moving_std(data, kernal)
%This function calculates a moving standard deviation across a dataset
%S. dev is found for a window; ex. if kernal = 5, s. dev will be found for
%data(1:5), then data(2:6), and so on.
%data = single vector of data points
%kernal = size of the window across which the std is calculated
% Scientific Programming, Spring 2015
% Course taught by Pascal Wallisch
% Isaac Purton, 5/5/2015

% If data is a row vector, reshape it into a column vector
sz = size(data);
if sz(1) < sz(2)
    data = data';
end

% If the kernal is set to be longer than the inputted array, show an error
% msg.
if length(data) < kernal
    error('Length of array is less than specified kernal.')
end

% Last data point to be included in the for loop
% Essentially, you want the last window to stop before it tries to
% reference a value outside of the data vector
end_at = length(data) - kernal + 1;

std_col = zeros(end_at, 1);

% Calculate standard deviations
for ii = 1:end_at
    up_bound = ii + kernal - 1;
        % Finds the end of the window (if the kernal is 6, you want the
        % first window to be from data(1) to data(6) and so on)
    temp = data(ii:up_bound);
    temp2 = std(temp);
    std_col(ii) = temp2;
end

end

%% Spike
% If the kernal is not a clean divisor for the data array(ie. if some
% values will be excluded from the sliding window), show a warning. This
% won't break the function.
% remainder = mod(data, kernal);
% if remainder ~= 0
%     disp(['Note that kernal is not a valid factor for the length of this '...
%         'data array. The last ' int2str(remainder) ' values were not '...
%         'analyzed by this function.']);
%     end_at = length(data) - remainder;
% end