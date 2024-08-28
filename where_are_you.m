function output = where_are_you (sample, pixel_size)

for h = 1:3
   structure = {'garbage', 'endosome', 'mvb'};     
   idx_1=1;
   min_dist = zeros(1,1);
   for i = 1:length(sample.input.data)

       if isfield (sample.input.data(i).analysis_data, structure{h})
            
            for j = 1:length(sample.input.data(i).analysis_data.(structure{h}))
                clear temp_dist
                idx=1;
                for k =1:length(sample.input.data(i).analysis_data.pm)
                    
                    for m =1:length(sample.input.data(i).analysis_data.pm(k).x)
                        
                        for n = 1:length(sample.input.data(i).analysis_data.(structure{h})(j).x)
                            
                            temp_dist(1, idx) = abs(pixel_size*dist2 (sample.input.data(i).analysis_data.pm(k).x(m),...
                                                                  sample.input.data(i).analysis_data.pm(k).y(m),...
                                                                  sample.input.data(i).analysis_data.(structure{h})(j).x(n),...
                                                                  sample.input.data(i).analysis_data.(structure{h})(j).y(n),...
                                                                  0));
                            
                            idx=idx+1;
                            
                        end
                    end
                end
                
                min_dist (idx_1,1)= min(temp_dist(1,:));
                
                idx_1=idx_1+1;
                
            end
       end
        dist_data.(structure{h}) = min_dist;
   end
end
   
output = struct('dist_data', {dist_data});

end

            