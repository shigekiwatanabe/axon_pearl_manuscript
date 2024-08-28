d = dir('C1*.csv');
%test code using Ke Xu Science 2013 data on actin spacing in axons

%find the shortest length of dataset
shortest = 10000;
for i = 1:length(d)
    test_data = readtable(d(i).name);
    remove_var1 = removevars(test_data, "Var1");
    table_double = table2array(remove_var1);
    if length(table_double) < shortest
        shortest = length(table_double);
    end
end

total = zeros(46, 2);

for i = 1:length(d)
test_data = readtable(d(4).name);
remove_var1 = removevars(test_data, "Var1");
table_double = table2array(remove_var1);

%plot(test_data(:,1), test_data(:,2))
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

total(:,2) = total(:,2)/length(d);
figure;
plot(total(:,1),total(:,2));


%grid
%xlabel('Frequency (1/micron)')
%ylabel('Amplitude')
%hold off