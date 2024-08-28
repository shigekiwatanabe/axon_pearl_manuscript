


clear 

disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/Data/Morven/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10
name_list = {};

for i = 1:length(ordered_fields) 
    
    %checks if file is an raw data file, not output file
    if length(strfind(ordered_fields{i}, 'output')) == 0 
        disp([char(10) ordered_fields{i}]);
        name_list(1,i) = {strcat(ordered_fields{i}, '_output')}; %generates name list
        sample_out.(name_list{i}) = compile_data (sample_in.(ordered_fields{i}));
    end
end