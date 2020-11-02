%% get data from ASCII file

disp(' ')
disp('Read This:')
disp(' ')

file_name = input([
    'After converting the .ltx file to a .txt file, (see' ...
    newline 'README.md) move the .txt file to your MATLAB directory.' ...
    newline 'Then, manually delete the signle-column portion of the' ...
    newline '.txt file in a text editor (see README.md). Upon comple-' ...
    newline 'ting these tasks, in the command window, enter the exact' ...
    newline 'name of the file. For example, "trial.txt" (without the' ...
    newline 'quotations). Do not forget to put .txt at the end of' ...
    newline 'your command window input.' ...
    newline ' ' ...
    newline 'Filename: '],'s');
disp(' ')

M = readmatrix(file_name); %convert ASCII to matrix

T = zeros(5382,2); %matrix to be filled systematically with raw data
counterA = 1;


%the following loop takes the long matrix
%and puts that data into the empty matrix systematically

for i = 1:length(M)
    if M(i,1) == 10004
        T(:,counterA) = M((i+6):(i+6+5381),1);
        T(:,counterA+1) = M((i+6):(i+6+5381),2);
        counterA = counterA + 2;
    end
end


%defines the size of T, which is the matrix with the tidy data

size_T = size(T);
num_rows = size_T(1);
num_cols = size_T(2);

wavelen_ind = (num_cols/2);

TT = zeros(num_rows,num_cols); %TT will be a trimmed version of T, but the
                               %size of the matrix stays the same. There
                               %are zeros assigned to the trimmed part at
                               %the bottom of the matrix.
counterC = 1;


%% trim such that wavelength values are aligned

for ii = 1:wavelen_ind
    counterB = 1;
    col_of_int = T(:,counterC);
    col_of_int_intensity = T(:,counterC+1);
    for iii = 1:length(col_of_int)
        if col_of_int(iii) >= 657 && col_of_int(iii) <= 663
            TT(counterB,counterC) = col_of_int(iii);
            TT(counterB,counterC+1) = col_of_int_intensity(iii);
            counterB = counterB + 1;
        end
    end
    counterC = counterC + 2;
end


%make an array with number of nonzero elements in each column

counterD = 1;
nonzero_per_col = zeros(1,wavelen_ind);

for iv = 1:wavelen_ind
    nonzero_per_col(iv) = nnz(TT(:,counterD));
    counterD = counterD + 2;
end


%find the number of nonzero elements in the column with
%the minimum minimum number of nonzero element

num_nonz_rows = min(nonzero_per_col);


%make a new matrix with the trimmed data

counterE = 1;
TTT = zeros(num_nonz_rows,num_cols); %TTT is trims the zeros from the
                                     %bottom of the matrix.

for v = 1:wavelen_ind
    TTT(:,counterE) = TT(1:num_nonz_rows,counterE);
    TTT(:,counterE+1) = TT(1:num_nonz_rows,counterE+1);
    counterE = counterE + 2;
end


%% standard deviation calculation for a given frame

std_wavelen = zeros(num_nonz_rows,1); %empty std vector for wavelength

for i = 1:num_nonz_rows
    take_row = TTT(i,:); %takes a row from TTT (which is trimmed raw data)
    
    std_this_wavelen = take_row(1:2:end); %wavelen vector to std()
    
    std_wavelen(i) = std(std_this_wavelen); %apply std() on wavelength
end

mean_std_wavelen = mean(std_wavelen); %find the mean std for wavelength


disp(' ')
disp(['The mean standard deviation for wavelength is: ',...
    num2str(mean_std_wavelen),' nm'])
disp(['In picometers, that is: ', num2str(mean_std_wavelen*1000),' pm'])


%% apply mean() on the array

mean_wavelen = zeros(num_nonz_rows,1); %empty vector for mean wavelength
mean_intensity = zeros(num_nonz_rows,1); %empty vector for mean intensity

for i = 1:num_nonz_rows
    take_row = TTT(i,:); %takes a row from TTT (which is trimmed raw data)
    
    mean_this_wavelen = take_row(1:2:end); %wavelen vector to mean()
    mean_this_intensity = take_row(2:2:end); %intensity vector to mean()
    
    mean_wavelen(i) = mean(mean_this_wavelen); %apply mean(), wavelen
    mean_intensity(i) = mean(mean_this_intensity); %apply mean(), intensity
end


%% plot average (linear and logarithmic)

fig1 = figure;
p1 = plot(mean_wavelen,mean_intensity);
xlabel('Wavelength (nm)')
ylabel('Intensity (a.u.)')
title('Laser Spectrum')
x0=1000;
y0=1000;
width=400;
height=350;
set(gcf,'position',[x0,y0,width,height])
saveas(p1,'plot1.png')

fig2 = figure;
p2 = semilogy(mean_wavelen,mean_intensity);
xlabel('Wavelength (nm)')
ylabel('Intensity (a.u.)')
title('Laser Spectrum')
x0=1000;
y0=1000;
width=400;
height=350;
set(gcf,'position',[x0,y0,width,height])
saveas(p2,'plot2.png')

%% plot fourier transform
y = fft(mean_intensity);
f = (0:length(y)-1)*685.3965/length(y);

%shift fourier transform
n = length(mean_intensity);
fshift = (-n/2:n/2-1)*(685.3965/n);
yshift = fftshift(y);

%plot fourier transform
fig4 = figure;
p3 = plot(fshift,abs(yshift));
title('Fourier Transform')
x0=1000;
y0=1000;
width=400;
height=350;
set(gcf,'position',[x0,y0,width,height])
saveas(p3,'plot3.png')

%% plot standard deviation

fig5 = figure;
p4 = plot(std_wavelen);
xlabel('Row Number in 4112x3020 Matrix')
ylabel('Standard Devation (nm)')
title('Standard Deviation Per Row')
x0=1000;
y0=1000;
width=400;
height=350;
set(gcf,'position',[x0,y0,width,height])
saveas(p4,'plot4.png')