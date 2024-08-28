%runs fourier transform on each line profile and outputs average
%test code using Ke Xu Science 2013 data on actin spacing in axons

%Compile all line profile csv files for one test condition into one folder
%(i.e. sphingomyelinase_ctrl_compile)

%select which channel to analyze
d = dir('C3*.csv');

%find the shortest length of line profile in dataset
%all line profile data will be cut to smallest length
shortest = 10000;
for i = 1:length(d)
    test_data = readtable(d(i).name);
    remove_var1 = removevars(test_data, "Var1");
    table_double = table2array(remove_var1);
    if length(table_double) < shortest
        shortest = length(table_double);
    end
end

%array size must match Fv size
%just run code first... error will pop up, adjust to Fv array size and run
%code again
total = zeros(64, 2);

%fourier transform on each line profile and add to var total
for i = 1:length(d)
test_data = readtable(d(i).name);
remove_var1 = removevars(test_data, "Var1");
table_double = table2array(remove_var1);

x = table_double(1:shortest,1); %distance vector
s = table_double(1:shortest,2); %intensity vector
Xs = mean(diff(x)); %sampling interval
Fs = 1/Xs; %sampling frequency
Fn = Fs/2; %Nyquist frequency
L = size(table_double(1:shortest,2),1); %number of samples
FTs = fft(s-mean(s))/L; %fourier transform
Fv = linspace(0,1,fix(L/2)+1)*Fn; %frequency vector
total(:,1) = Fv;
Iv = 1:numel(Fv);
y_value = abs(FTs(Iv))*2;
total(:,2) = total(:,2)+y_value;
end

%average
total(:,2) = total(:,2)/length(d);
%plot
figure;
plot(total(:,1),total(:,2));


%grid
%xlabel('Frequency (1/micron)')
%ylabel('Amplitude')
%hold off