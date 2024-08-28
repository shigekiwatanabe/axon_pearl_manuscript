
function output = count_data (data)
output.table = zeros (1,7);

for i = 1:length(data)
    
    if isfield (data(i).analysis_data, 'pm')
        
        output.table (i,1) = length((data(i).analysis_data.pm));
        
    end
    
    if isfield (data(i).analysis_data, 'garbage')
        
        output.table (i,2) = length((data(i).analysis_data.garbage));
        
        
    end
    
    if isfield (data(i).analysis_data, 'endosome')
        
        output.table (i,3) = length((data(i).analysis_data.endosome));
        
    end
    
    if isfield (data(i).analysis_data, 'mvb')
        
        output.table (i,4) = length((data(i).analysis_data.mvb));
        
    end
    
end

for i =1:length(data)
    
    output.table (i,5) = output.table (i,2) + output.table (i,4);%mvb+garbage
    output.table (i,6) = output.table (i,2)/output.table (i,1);%garbage/synapse/profile
    output.table (i,7) = output.table (i,5)/output.table (i,1);%mvb+garbage/synapse/profile

end

    
    
        