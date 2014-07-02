% QAM16_mapper.m 
function [qam16] =QAM16_mapper(bitseq)
len = length(bitseq);
j =sqrt(-1);
QAM_table2 = [-3-3*j, -3-j, -3+3*j, -3+j, -1-3*j, -1-j, -1+3*j, -1+j, 3-3*j, 3-j, 3+3*j, 3+j, 1-3*j, 1-j, 1+3*j, 1+j]/sqrt(10.);

for k=0: len/4-1,
  temp = bitseq(4*k+1)*8 +bitseq(4*k+2)*4 +bitseq(4*k+3)*2 +bitseq(4*k+4);
  qam16(k+1) =QAM_table2(temp+1);
end