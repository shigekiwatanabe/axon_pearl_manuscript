function analysis_data = import_data (filename, pixel_size)

fid = fopen(filename);

k=1;
idx_1=1;
idx_2=1;
idx_3=1;
idx_4=1;
idx_5=1;

while (true)
    
    tline = fgetl(fid);
    
    if ( ~ischar(tline))
        break,
    end

    %extracting data
    [type, records] = strtok(tline);
    
   
    
    if (type == '5')
        
         %1 is line tool used in imageJ for measuring closed circular structures such as SV,LV,and DCV.
       [freeh(k).name,...
        freeh(k).length,...
        freeh(k).xelements,...
        freeh(k).yelements] = strread(records, '%s %f %s %s');
        
        if strcmp(freeh(k).name, 'string_l')
            analysis_data.string.length(idx_1) = freeh(k).length*pixel_size;
            
            idx_1=idx_1+1;
        elseif strcmp(freeh(k).name, 'string_w')
            analysis_data.string.width (idx_2) = freeh(k).length*pixel_size;
            idx_2=idx_2+1;
        elseif strcmp(freeh(k).name, 'bouton_l')
            analysis_data.bouton.length(idx_3) = freeh(k).length*pixel_size;
            idx_3=idx_3+1;
        elseif strcmp(freeh(k).name, 'bouton_w')
            analysis_data.bouton.width(idx_4) = freeh(k).length*pixel_size;
            idx_4=idx_4+1;
            
        end
        
        
    elseif (type == '3')
        
        [freeh(k).name,...
         freeh(k).area,...
         freeh(k).xelements,...
         freeh(k).yelements,...
         freeh(k).ar,...
         freeh(k).round,...
         freeh(k).solidity] = strread(records, '%s %f %s %s %f %f %f');

        if strcmp(freeh(k).name, 'mito')
            %(x, y) of each pixels on the outer surface of dense
            %projection
            
            analysis_data.mito(idx_5).name = char(freeh(k).name); 
            
            analysis_data.mito(idx_5).area = freeh(k).area*pixel_size^2;
            
            analysis_data.mito(idx_5).x    = strread(freeh(k).xelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.mito(idx_5).y    = strread(freeh(k).yelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.mito(idx_5).ar   = freeh(k).ar;
            
            analysis_data.mito(idx_5).round   = freeh(k).round;
            
            analysis_data.mito(idx_5).solidity   = freeh(k).solidity;
                          
            idx_5 = idx_5+1;
            
        end
        
    end
    k=k+1;
end
fclose(fid);
clear fid

end    



    
    
        
        
