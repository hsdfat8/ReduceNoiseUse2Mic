function databin=databin(data)
data=10000*data/78;
data=round(data);
databin=dec2bin(typecast(int8(data),'uint8'));
%dlmwrite('filename.txt',a)
end