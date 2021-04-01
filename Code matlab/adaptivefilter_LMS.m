clc;

step = 6;                       %do dai buoc dich
fir_length = 16;                %do dai bo loc
%input1 va input2 là chuỗi 8 bit được convert dưới dạng cell kiểu text
%cell2mat convert từ cell thành matrix
%datawav convert từ text thành số thực
main = cell2mat(input1);        
main = datawav(main,8);
sub = cell2mat(input2);
sub = datawav(sub,8);
mu = 1/2^step;                  %buoc nhay
weight(:,1) = transpose(zeros(1,fir_length));
U = zeros(1,fir_length);

for i=1:length(main)
    %cap nhat weight
    if (i==1) weight(:,i+1)=weight(:,i);
    else weight(:,i+1)=weight(:,i)+mu*e(i-1)*(transpose(U));
    end
    %cap nhat memory
    U=[U(2:16) sub(i)];
    y=main(i);
    yhat=U*weight(:,i);
    %tinh toan dau ra
    e(i)=y-yhat;
end

plot(main);
figure;plot(e);