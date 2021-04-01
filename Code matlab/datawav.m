function data_wav=datawav(data,bits)
datadecfake=bin2dec(data);
datadectrue=twos2decimal(datadecfake,bits);
data_wav=datadectrue/128;
end