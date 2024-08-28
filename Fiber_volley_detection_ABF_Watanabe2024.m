%The provided MATLAB code is designed to analyze data from ABF (Axon Binary Format) files,
% which are commonly used to store electrophysiological data. 
% The program loads the data, performs baseline correction, 
% removes artifacts, identifies the biggest peak in the data within a specified threshold, 
% and finally exports relevant peak details to a CSV file. 
% User will need to change path location, file length and frame numbers of key features such
% as artifact peak, baseline,threshold. Manual inspection of produced plots
% is required to ensure the correct peak has been identified as the fiber
% volley.
% Adapted from by Zhenyong Wu and Ed Champman Watanabe Lab in 2024

%% Initialization
clear; % Clear the workspace of all variables
close all; % Close all open figure windows
clc; % Clear the command window

%% Load Data from ABF File
myFolder = 'your file path here'; % Specify the folder containing ABF files

if ~isfolder(myFolder) % Check if the folder exists
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage)); % Display a warning dialog if the folder does not exist
    return; % Exit the program
end
filePattern = fullfile(myFolder, '*.abf'); % Create a pattern to match ABF files
ss = dir(filePattern); % Get directory information for the matching files
fn = length(ss); % Number of ABF files found
cc = []; % Initialize an array for storing concatenated data
fileNames = cell(fn, 1); % Initialize cell array to store file names
for k = 1:fn
    c = abfload(fullfile(ss(k).folder, ss(k).name)); % Load ABF file data
    d = c(1:10000,1); % Select the first 10,000 samples (around ~5 seconds)
    cc = [cc d]; % Concatenate data
    fileNames{k} = ss(k).name; % Store the file name for later use
end 

%% Remove Baseline and Artifacts, Prepare Data
t = [0:0.0001:0.9999]'; % Create a time vector from 0 to 0.9999 seconds in 0.0001-second intervals

cc20 = cc; % Store the concatenated data for processing

% Initialize array for baseline correction and artifact masking
cc20all = [];
for k = 1:size(cc20,2) % Iterate through each signal column
    b = cc20(:,k) - mean(cc20(51:76,k)); % Remove baseline by subtracting the mean
    artifactStartIndex = 2150; % Define the start index of an artifact
    artifactEndIndex = artifactStartIndex + 20; % Define the end index of the artifact
    b(artifactStartIndex:artifactEndIndex) = NaN; % Mask the artifact with NaN
    cc20all = [cc20all b]; % Store the processed signal
end

figure(2)
hold on
plot(t,cc20all); % Plot the processed signals
xlabel('time, s'); % X-axis label for time
ylabel('Voltage, mV'); % Y-axis label for voltage

% Adding baseline back where artifacts were masked
cc20allb = [];
for kk = 1:size(cc20all,2) % Iterate through each signal again
    bb = mean(cc20all(51:76,kk)); % Calculate baseline for correction
    bbb = cc20all(:,kk); % Create a variable for adjustment
    artifactStartIndex = 2150; % Re-specify artifact start index
    artifactEndIndex = artifactStartIndex + 20; % End index
    bbb(artifactStartIndex:artifactEndIndex) = bb; % Restore baseline at masked positions
    cc20allb = [cc20allb bbb]; % Store adjusted signal
end

figure(6) % Create a new figure for final output
plot(t,cc20all) % Plot the final processed signals
xlabel('time, s'); % X-axis label for time
ylabel('Voltage, mV'); % Y-axis label for voltage

% Initialize cell arrays for storing peak information
peakAmplitudes = cell(1, size(cc20allb, 2)); % Cell array for peak amplitudes
peakLocations = cell(1, size(cc20allb, 2)); % Cell array for peak locations
timeFromStimToEndOfPeak = cell(1, size(cc20allb, 2)); % Cell array for time to peak

% Define parameters for peak detection
stimulationEndIndex = 2175; % Index marking end of stimulation artifact
samplingRate = 10000; % Define the sampling rate for calculations

% Initialize arrays for storing the biggest peak information
biggestPeakAmplitude = NaN(1, size(cc20allb, 2)); % Array for storing peak amplitudes
biggestPeakLocation = NaN(1, size(cc20allb, 2)); % Array for storing peak locations
timeFromStimToBiggestPeak = NaN(1, size(cc20allb, 2)); % Array for storing time to peak

% Loop to find the biggest negative peak in each signal
for col = 1:size(cc20allb, 2) % Iterate through each column (signal)
    signal = cc20allb(:, col); % Current signal

    % Find local maxima (negative peaks)
    localMax = islocalmax(-signal); % Invert signal to find negative peaks
    localMaxIndices = find(localMax); % Get indices of local maxima
    localMaxValues = signal(localMaxIndices); % Get values of local maxima

    % Filter based on threshold to find significant peaks
    threshold = -0.03; % Define threshold for peak detection
    belowThresholdIndices = localMaxIndices(localMaxValues < threshold); % Indices below threshold
    belowThresholdValues = localMaxValues(localMaxValues < threshold); % Values below threshold

    % Identify the biggest negative peak
    if ~isempty(belowThresholdValues) % Check if there are any valid peaks
        [biggestPeak, idx] = min(belowThresholdValues); % Find the biggest (most negative) peak
        biggestPeakLocation(col) = belowThresholdIndices(idx); % Store peak location
        biggestPeakAmplitude(col) = biggestPeak; % Store peak amplitude
        timeFromStimToBiggestPeak(col) = (biggestPeakLocation(col) - stimulationEndIndex) / samplingRate; % Convert to time
    end
end

% Create plots for each signal showing the detected peak
for col = 1:size(cc20allb, 2) % Iterate through each signal for plotting
    figure; % Create a new figure for each signal
    plot(t, cc20allb(:, col)); % Plot the signal
    hold on;

    if ~isnan(biggestPeakLocation(col)) && biggestPeakLocation(col) > 0
        % Mark the biggest peak on the plot
        plot(t(biggestPeakLocation(col)), biggestPeakAmplitude(col), 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'red');

        % Adjust x-axis limits around the peak for better visibility
        peakTime = t(biggestPeakLocation(col));
        xlimRange = [max(t(1), peakTime - 0.1), min(t(end), peakTime + 0.1)];
        xlim(xlimRange); % Set x-axis limits
    end
    hold off;
    xlabel('Time, s'); % X-axis label for time
    ylabel('Voltage, mV'); % Y-axis label for voltage
    title(sprintf('Signal %d with Biggest Peak Marked', col)); % Title for the plot
end
    
%% Writing to CSV Including File Names
% Create a table to summarize peak details
peakDetails = table(fileNames, biggestPeakLocation', biggestPeakAmplitude', timeFromStimToBiggestPeak', ...
    'VariableNames', {'FileName', 'BiggestPeakFrame', 'BiggestPeakAmplitude', 'TimeFromStim'});

% Write the peak details to a CSV file
csvFileName = fullfile(myFolder, 'biggestPeakDetails.csv'); % Define output filename
writetable(peakDetails, csvFileName); % Export the table to CSV format

disp(['Peak details exported to ', csvFileName]); % Display a message indicating export success
