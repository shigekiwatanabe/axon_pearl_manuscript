

function output = size_me (sample)

idx_1=1;
idx_2=1;
idx_3=1;
idx_4=1;

for i = 1:length(sample.input.data)
    
    if isfield (sample.input.data(i).analysis_data, 'garbage')
        
        for j = 1:length(sample.input.data(i).analysis_data.garbage)
        
            output.garbage (idx_1,1) = sample.input.data(i).analysis_data.garbage(j).area;
            idx_1=idx_1+1;
        end
    end
    
    if isfield (sample.input.data(i).analysis_data, 'endosome')
        
        for j = 1:length(sample.input.data(i).analysis_data.endosome)
        
            output.endosome (idx_2,1) = sample.input.data(i).analysis_data.endosome(j).area;
            idx_2=idx_2+1;
        end
    end
    
    if isfield (sample.input.data(i).analysis_data, 'mvb')
        
        for j = 1:length(sample.input.data(i).analysis_data.mvb)
        
            output.mvb (idx_3,1) = sample.input.data(i).analysis_data.mvb(j).area;
            idx_3=idx_3+1;
        end
    end
    
    if isfield (sample.input.data(i).analysis_data, 'pm')
        
        for j = 1:length(sample.input.data(i).analysis_data.pm)
        
            output.pm (idx_4,1) = sample.input.data(i).analysis_data.pm(j).length;
            idx_4=idx_4+1;
        end
    end
    
end
end
