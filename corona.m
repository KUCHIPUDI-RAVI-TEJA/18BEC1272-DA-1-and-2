clc
clear all

dataset = xlsread('data.xlsx', 'Sheet1', 'A1:D33')
%reads the data from sheet1 from the range   A1:D33
x = dataset (:,1);%selects all rows in column 1 
y = dataset (:,2);%selects all rows in column 

%Plotting the Data
figure(1)%plots figure 1
plot(x,y);%plots graph
set(gca,'fontsize',10,'fontweight','bold');%set the graph as bold with weight 10
title("Covid19 cases from 2nd Jul to 2nd Aug ",'fontsize',10,'fontweight','bold')
%set title of graph with fontsize 10 and fontweight as bold
xlabel("Scaled Date ",'fontsize',10,'fontweight','bold')
%set x axis values as dates with fontsize 10 and fontweight as bold
ylabel("Scaled Cases in (10^3)",'fontsize',10,'fontweight','bold')
%set y axis values as Cases with fontsize 10 and fontweight as bold

%Sampling the Data
figure(2)%plot figure 2
stem(x,y)%plots sampled graph
set(gca,'fontsize',10,'fontweight','bold');%set the graph as bold with weight 10
title("Sampled Signal",'fontsize',10,'fontweight','bold')
%set title of graph with fontsize 10 and fontweight as bold
xlabel("Scaled Date (02-Jul-2020 to 02-Aug-2020)",'fontsize',10,'fontweight','bold')
%set x axis values as dates with fontsize 10 and fontweight as bold
ylabel("Scaled Cases in (10^3)",'fontsize',10,'fontweight','bold')
%set y axis values as Cases with fontsize 10 and fontweight as bold

%Quantization
n=6; %number of bits = 6.Beacuase In my data maximum value is 54.
        %so,next max bit is 64.
        %n^x= 64 => x = 6
L=2^n; %max=54 =>64=2^6==>n=6
vmax=64;%to get exact (integer) quantized values I took maximum value is 64
vmin=0; %to get exact (integer) quantized values I took minimum value is 0 
del=(vmax-vmin)/L; %finds the delta value = (64-0)/64 = 1 
part=vmin-(del)/2:del:vmax-(del)/2; %partition
code=vmin:del:vmax+del; %0 to 64 with interval 1
[ind,q]=quantiz(y,part,code); 
%quantization index and the corresponding quantized output value of the input data will
%perform quantization

l1=length(ind);
l2=length(q);
for i=1:l1
   if(ind(i)~=0)         % To make index as binary decimal so started from 0 to N
       ind(i)=ind(i)-1;
   end 
    i=i+1;
end   
for i=1:l2
    if(q(i)==vmin-(del/2))     % To make quantize value inbetween the levels
         q(i)=vmin+(del/2);
    end
end    

figure(3); %plots figure 3
stem(q);   % Display the Quantize value
set(gca,'fontsize',10,'fontweight','bold');%set the graph as bold with weight 10
title("Quntized Signal",'fontsize',10,'fontweight','bold')
%set title of graph with fontsize 10 and fontweight as bold
xlabel("Scaled Date (02-Jul-2020 to 02-Aug-2020) ",'fontsize',10,'fontweight','bold')
%set x axis values as dates with fontsize 10 and fontweight as bold
ylabel("Scaled Cases in (10^3)",'fontsize',10,'fontweight','bold')
%set y axis values as Cases with fontsize 10 and fontweight as bold


% NORMALIZATION
l1=length(ind); % to convert 1 to n as 0 to n-1 indicies
for i=1:l1
if (ind(i)~=0)
ind(i)=ind(i)-1;
end
end
l2=length(q);
for i=1:l2 % to convert the end representation levels within the range.
if(q(i)==vmin-(del/2))
q(i)=vmin+(del/2);
end
if(q(i)==vmax+(del/2))
q(i)=vmax-(del/2);
end
end

% ENCODING
code=de2bi(q,'left-msb'); % converts decimal to binary
k=1;%starts form index 1
for i=1:l1 % to convert column vector to row vector
for j=1:n
coded(k)=code(i,j);
j=j+1;
k=k+1;
end
i=i+1;
end

figure(4);
stairs(coded); %
axis([0 190 -2 2]) %plot of digital signal
set(gca,'fontsize',10,'fontweight','bold'); %set the graph as bold with weight 10
title("Digital Signal",'fontsize',10,'fontweight','bold')
%set title of graph with fontsize 10 and fontweight as bold
xlabel("Scaled Date (02-Jul-2020 to 02-Aug-2020) ",'fontsize',10,'fontweight','bold')
%set x axis values as dates with fontsize 10 and fontweight as bold
ylabel("Scaled Cases in (10^3)",'fontsize',10,'fontweight','bold')
%set y axis values as Cases with fontsize 10 and fontweight as bold



%Demodulation
code1=reshape(coded,n,(length(coded)/n));
%reshapes Input array, specified as a vector, matrix, or multidimensional array.
index1=bi2de(code1,'left-msb');%converts binary to decimal
resignal=del*ind+vmin+(del/2);

figure(5);%plot of figure 5
plot(resignal,"color",'b');%plot demodulated signal with color blue
set(gca,'fontsize',10,'fontweight','bold');%set the graph as bold with weight 10
title("Demodulated Signal",'fontsize',10,'fontweight','bold')
%set title of graph with fontsize 10 and fontweight as bold
xlabel("Scaled Date (02-Jul-2020 to 02-Aug-2020) ",'fontsize',10,'fontweight','bold')
%set x axis values as dates with fontsize 10 and fontweight as bold
ylabel("Scaled Cases in (10^3)",'fontsize',10,'fontweight','bold')
%set y axis values as Cases with fontsize 10 and fontweight as bold


