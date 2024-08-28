


function new_data = start_data_analysis 

% prompt users to input the pixel size.  
pixel_size = str2num(input('What is the pixel size (nm/pixel):', 's'));

pearl_tf = ismember(char('y'),char(input('Is this for axon pearls? (yes/no):', 's')));

% Choosing a directory using a dialog box
disp ('choose the directory where the text files are located');
directory_name = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/');
%change the path inside the () to set the initial directory. 

% Choosing the data files using a dialog box
fprintf ('select all data files\n');
[filename] = uigetfile(('*.txt'), 'MultiSelect', 'on',...
                        'Select all data files\n', directory_name);

                    
                    
% when users cancel the execution, stop the program and display
%'canceled'
if (isequal (filename, 0))
    
    disp ('canceled')
    return
    
elseif (ischar (filename)) % this means only one file is opened
    
    section_number = 1;
    
    file_name = sprintf('%s/%s', directory_name, filename);
    
    data.analysis_data = import_data(file_name, pixel_size);
                                          
                                          
else %if multiple files are selected
    
    for h = 1:length (filename)

        % converting a cell array to a character array
        file_name = char(filename(h));
        
        % directroy name needs to be added to file_name, so the program can
        % locate the file that you are opening
        file_name = sprintf('%s/%s', directory_name, file_name);
        
        data(h).analysis_data = import_data(file_name, pixel_size);

    end
end

% disp (file_name)

if pearl_tf ==1
    
    a=1;
    b=1;
    c=1;
    d=1;
    e=1;
    
    % string_tf=0;
    % mito_tf=0;
    % bouton_tf=0;
    
    for i=1:length(data)
        
        for j= 1:length(data(i).analysis_data)
            
            if isfield(data(i).analysis_data(j), 'string')
                
                string_tf =1;
                
                for k= 1:length(data(i).analysis_data(j).string.length)
                    
                    new_data.string.length(a,1) = data(i).analysis_data(j).string.length(k);
                    
                    a=a+1;
                    
                end
disp (filename(i));
                for k= 1:length(data(i).analysis_data(j).string.width)
                    
                    new_data.string.width(b,1) = data(i).analysis_data(j).string.width(k);
                    
                    b=b+1;
                    
                end
            end
            
            
            
            if isfield(data(i).analysis_data(j), 'bouton')
                
                bouton_tf = 1;
                
                for k= 1:length(data(i).analysis_data(j).bouton.length)
                    
                    new_data.bouton.length(c,1) = data(i).analysis_data(j).bouton.length(k);
                    
                    c=c+1;
                    
                end
                
                for k= 1:length(data(i).analysis_data(j).bouton.width)
                    
                    new_data.bouton.width(d,1) = data(i).analysis_data(j).bouton.width(k);
                    
                    d=d+1;
                    
                end
            end
            
            if isfield(data(i).analysis_data(j), 'mito')
                
                mito_tf=1;
                
                for k= 1:length(data(i).analysis_data(j).mito)
                    
                    new_data.mito.area(e,1) = data(i).analysis_data(j).mito(k).area;
                    new_data.mito.ar(e,1) = data(i).analysis_data(j).mito(k).ar;
                    new_data.mito.round(e,1) = data(i).analysis_data(j).mito(k).round;
                    new_data.mito.solidity(e,1)=data(i).analysis_data(j).mito(k).solidity;
                    e=e+1;
                    
                end
                
            end
            
            
            
        end
    end
    
    % if string_tf ==1
    %
    %     data = struct('strings', {string});
    % end
    %
    %
    % if bouton_tf ==1
    %
    %      data = struct('pearls', {bouton});
    %
    % end
    %
    % if mito_tf ==1
    %
    %      data = struct('mito',{mito});
    %
    % end


end

if pearl_tf ==0
    new_data.table = count_data(data);
    
    
    new_data.input = struct ('data', {data});
    new_data.area = size_me(new_data);
    new_data.distance = where_are_you(new_data, pixel_size);
end

end


