% 1/26/21; Written by Shigeki Watanabe for Gottschalk Lab use
% this script will calculate distances between all vesicles in 2D profiles.
% also it will calculate the nearest distance between vesicles and generate
% a table summarizing the nearest distances from all vesicles in the
% dataset (all combined). This script only works if you already run the
% "start_analysis" script and saved the resulting variables in workspace as
% .mat file. When you run this script, it will prompt you to identify the
% directory that contains the .mat file. This .mat file can contain
% multiple samples. Then you need to select the file. It will also asks you
% to type in the pixel size. 


disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10




pixel_size = input('Pixel Size? ');

for h = 1:length(ordered_fields)
    table = zeros(1,3);
    dist_table = zeros(1,1);
    
    a=1;
    b=1;
    c=1;
    
    for i = 1:length(sample_in.(ordered_fields{h}).raw_data)
    
        for j = 1:length(sample_in.(ordered_fields{h}).raw_data(i).analysis_data.vesicle)
            
            if strcmp (sample_in.(ordered_fields{h}).raw_data(i).analysis_data.vesicle(j).name, 'SV')
                
                table (a,1) = (sample_in.(ordered_fields{h}).raw_data(i).analysis_data.vesicle(j).x);
                table (a,2) = (sample_in.(ordered_fields{h}).raw_data(i).analysis_data.vesicle(j).y);
                table (a,3) = (sample_in.(ordered_fields{h}).raw_data(i).analysis_data.vesicle(j).r);
                a=a+1;
            end
        end
    
        for j = 1:length(table)-1
            
            dist_table_2= zeros(1,1);
            
            for k = 2:length(table)
                
                dist_table (b,1) = abs(dist2(table(j,1),table(j,2),table(j,3), table(k,1),table(k,2))*pixel_size);
                
                dist_table_2 (k-1,1) = abs(dist2(table(j,1),table(j,2),table(j,3), table(k,1),table(k,2))*pixel_size);
                
                b=b+1;
            end
            min_dist_table (c,1) = min(dist_table_2);
            c=c+1;
        end
    end
    
    sample_out.(ordered_fields{h}).all_vesicle_dist = dist_table;
    sample_out.(ordered_fields{h}).nearest_vesicle_dist = min_dist_table;
    
end



clear a b c i j k h table sample_in ordered_fields directory all_fields index_order filename pixel_size dist_table dist_table_2 min_dist_table

    