% QAM16_demapper.m 
function [s] =QAM16_demapper(qam16)
N = length(qam16);
j =sqrt(-1);
QAM_table2 = [-3-3*j, -3-j, -3+3*j, -3+j, -1-3*j, -1-j, -1+3*j, -1+j, 3-3*j, 3-j, 3+3*j, 3+j, 1-3*j, 1-j, 1+3*j, 1+j]/sqrt(10.);

temp=[];

for i=0:N-1,
  temp=[temp dec2bin(find(QAM_table2==qam16(i+1))-1,4)];
end

s=zeros(1,length(temp));

for i=1:length(s)
    s(i)=bin2dec(temp(i));
end