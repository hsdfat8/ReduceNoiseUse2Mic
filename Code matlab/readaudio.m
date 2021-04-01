%% doc file
%clear;clc;
%[data1, fs1] = audioread('C:\Users\PV\Desktop\test2\71.wav');
%[data2, fs2] = audioread('C:\Users\PV\Desktop\test2\72.wav');
l1=length(main);
l2=length(sub);
%% adaptivefilter
mu=0.1;
bhat(:,1)=transpose(zeros(1,16));
lenbhat=length(bhat(:,1));
for i=1:(l2-lenbhat)+1
for j=1:lenbhat
W(j)=sub(i+lenbhat-j);
end
y=main(i);
yhat=W*bhat(:,i);
e(i)=y-yhat;
bhat(:,i+1)=bhat(:,i)+mu*e(i)*sign(transpose(W));
end
figure;plot(e);
title('output');
%% luu file
% dlmwrite('filename.txt',a)
% audiowrite('output.wav',e,16000)