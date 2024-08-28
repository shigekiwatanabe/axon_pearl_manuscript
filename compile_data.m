function output = compile_data (filename)



   a=1;
   b=1;
   c=1;
for i = 1:length(filename)   
   if isfield (filename(i).analysis_data, 'bouton')
       
       num = min(length(filename(i).analysis_data.bouton.length),...
                 length(filename(i).analysis_data.bouton.width));
       
       
       
       for j = 1:num
           
           output.table (a,1)= filename(i).analysis_data.bouton.length(j);
           
           output.table (a,2)= filename(i).analysis_data.bouton.width(j);
           
           a=a+1;
       end
       
   end
    
    
   if isfield (filename(i).analysis_data, 'string')
       
       num = min(length(filename(i).analysis_data.string.length),...
                 length(filename(i).analysis_data.string.width));
       
       for j = 1:num
           
           output.table (b,3)= filename(i).analysis_data.string.length(j);
           
           output.table (b,4)= filename(i).analysis_data.string.width(j);
           
           b=b+1;
           
       end
   end
    
   if isfield (filename(i).analysis_data, 'mito')
       
       for k =1:length(filename(i).analysis_data.mito)
           
           for j = 1:length(filename(i).analysis_data.mito(k).area)
               
               output.table (c,5)= filename(i).analysis_data.mito(k).area(j);
               
               output.table (c,6)= filename(i).analysis_data.mito(k).ar(j);
               
               output.table (c,7)= filename(i).analysis_data.mito(k).round(j);
               
               output.table (c,8)= filename(i).analysis_data.mito(k).solidity(j);
               
               c=c+1;
               
           end
       end
   end
end



      
            
            
            
            
        