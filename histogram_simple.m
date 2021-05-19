clear
close all hidden
clc

disp(['Copy 1 column of data from excel (values)'])
disp(['-------------------------------------'])

disp(['Checking if this is Octave or Matlab...'])
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

if isOctave
    pkg load statistics
    disp(['Importing data...'])
    cstr = inputdlg ('Paste values');
    disp(['Imported:'])
    disp(cstr{1})
    disp(['Scanning data...'])
    data=textscan(cstr{1}, '%f');
    % names=data{1};
    ages=data{1};
%     errors=data{3};
    disp(['Data:'])
    for n=1:length(ages)
        disp([num2str(ages(n))])
    end
        for n=1:length(ages)
            names{n}=num2str(ages(n));
        end
else
    
    
    disp(['Importing data from clipboard...'])
    import1 = importdata('-pastespecial');
    input=import1;
    disp(['Imported:'])
    disp(input)
    if length(input)==1
        import=import1;
        ages=import.data(:,1);
%         errors=import.data(:,2);
%         names=import.textdata;
%         names=names(size(names,1)-length(ages)+1:end,1);
        for n=1:length(ages)
            names{n}=num2str(ages(n));
        end
    else
        import.data=import1;
        ages=import.data(:,1);
%         errors=import.data(:,2);
        for n=1:length(ages)
            names{n}=num2str(ages(n));
        end
    end
end
disp(['Data:'])
for n=1:length(ages)
    disp([names{n} ' ' num2str(ages(n))])
end

% select data
sel=~isnan(ages);
ages=ages(sel);
% errors=errors(sel);
names=names(sel);

%% calculate

% number of bars to plot
nbars=min(100,max(10,length(ages)*20/50));

% average
n_data=length(ages);
mean_data=mean(ages);
std_data=std(ages);
sdom_data=std(ages)/(n_data)^0.5;

% precission
precisw=floor(log10(sdom_data))-1;
mean_data=round(mean_data/10^precisw)*10^precisw;
std_data=round(std_data/10^precisw)*10^precisw;
sdom_data=round(sdom_data/10^precisw)*10^precisw;

% show results
disp(['N = ' num2str(n_data)])
disp(['Mean = ' num2str(mean_data)])
disp(['Std = ' num2str(std_data)])
disp(['SDOM = '  num2str(sdom_data)])

%% Plot
disp(['Plotting...'])

figure
hold on

[n,xout] = hist(ages,nbars);
hist(ages,nbars)

xout2=linspace(min(xout),max(xout),1000);

iy = pdf('normal', xout2, mean_data, std_data);
scale=sum(n)/sum(iy)*length(xout2)/length(xout);
plot(xout2,iy*scale,'--r','LineWidth',2)

h_symbols=max(max(n),max(iy*scale))*1.1;
plot(mean_data,h_symbols,'xk')
plot([mean_data-std_data,mean_data+std_data],[h_symbols,h_symbols],'-k')
plot(mean_data-std_data,h_symbols,'<k')
plot(mean_data+std_data,h_symbols,'>k')
plot(mean_data-sdom_data,h_symbols,'+k')
plot(mean_data+sdom_data,h_symbols,'+k')


title(['N = ' num2str(n_data)])
xlabel(['Mean = ' num2str(mean_data) '+/-' num2str(std_data) ' ; SDOM = '  num2str(sdom_data)])

xlim([min(xout-mean(diff(xout))) max(xout+mean(diff(xout)))])
set(gca, 'FontName', 'Hack')

closequestion="No";
while strcmp(closequestion, "No")
closequestion=questdlg("Close?", "Done", "Yes", "No", "Yes");
end
