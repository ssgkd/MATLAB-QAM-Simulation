clc
clear all

M = 16;   % M-ary
k = log2(M); % bits per symbol

N_Bit_frame=240;
N_Symbol=N_Bit_frame/k;     % Number of symbol per frame
N_Error_Th=300;
N_Rx_antenna=4;


Eb_N0_dB  = [9];
Es_N0_dB  = Eb_N0_dB + 10*log10(k);


simBer_Rayleigh=zeros(N_Rx_antenna, length(Eb_N0_dB));

All_symbol=[];


for n_antenna=1:N_Rx_antenna
    fprintf('---------%d Antenna Simulation --------- \n', n_antenna);
    
    for ii = 1:length(Eb_N0_dB)
        
        Symbol_buffer=[];
        %%      Flat Fading Simulation
        
        N_Tx_Bit=0;
        N_Error_Bit=0;
        
        fprintf('Fading %d dB Simulation... \n', Eb_N0_dB(ii));
        
        %         while (N_Error_Bit <= N_Error_Th)  % Error 가 300 보다 작은 경우 까지만 시뮬레이션 한다
        for nn=1:100
            
            bitSeq=randi([0,1],1,N_Bit_frame);  % Bit generation
            QamSymbol=QAM16_mapper(bitSeq);     % Power Normalized 16 QAM mapping
            
            %  Flat fading & AWGN
            h = 1/sqrt(2)*[randn(n_antenna,N_Symbol) + j*randn(n_antenna,N_Symbol)]; % flat Rayleigh fading
            n = 1/sqrt(2)*[randn(n_antenna,N_Symbol) + j*randn(n_antenna,N_Symbol)]; % White Guassian Noise
            
            y=zeros(n_antenna,N_Symbol);
            
            for d=1:n_antenna
                y(d,:) = QamSymbol.*h(d,:) + 10^(-Es_N0_dB(ii)/20)*n(d,:); % flat Rayleigh fading & Additive White Gaussian Noise
            end
            
            %  Receiver
            if n_antenna~=1
                y1=sum(y.*conj(h))./sum((abs(h).^2));      % Fading Channel Receiver
            else
                y1=(y.*conj(h))./((abs(h).^2));            % Fading Channel Receiver
            end
            
            Symbol_buffer=[Symbol_buffer y1];
        end        
        
    end
    
    All_symbol(n_antenna,:)=Symbol_buffer;
end

%%

close all; figure
plot(real(All_symbol(1,:)),imag(All_symbol(1,:)),'r*')
hold on
plot(real(All_symbol(2,:)),imag(All_symbol(2,:)),'g>')
plot(real(All_symbol(3,:)),imag(All_symbol(3,:)),'bp')
plot(real(All_symbol(4,:)),imag(All_symbol(4,:)),'kx')

grid on
legend('1 Antenna','2 Antenna','3 Antenna','4 Antenna');
title('Constallation')
axis([-2 2 -2 2])
% axis equal





