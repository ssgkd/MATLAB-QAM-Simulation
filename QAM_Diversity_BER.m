clc
clear all

M = 16;   % M-ary
k = log2(M); % bits per symbol

N_Bit_frame=240;
N_Symbol=N_Bit_frame/k;     % Number of symbol per frame
N_Error_Th=300;
N_Rx_antenna=4;


Eb_N0_dB  = [0:12];
Es_N0_dB  = Eb_N0_dB + 10*log10(k);


simBer_Rayleigh=zeros(N_Rx_antenna, length(Eb_N0_dB));


for n_antenna=1:N_Rx_antenna
    fprintf('---------%d Antenna Simulation --------- \n', n_antenna);
     
    for ii = 1:length(Eb_N0_dB)
        
        
        %%      Flat Fading Simulation
        
        N_Tx_Bit=0;
        N_Error_Bit=0;
        
        fprintf('Fading %d dB Simulation... \n', Eb_N0_dB(ii));
        
        while (N_Error_Bit <= N_Error_Th)  % Error 가 300 보다 작은 경우 까지만 시뮬레이션 한다
            
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
            
            DecisionSymbol=QAM16_slicer(y1);         % Symbol Decision
            DecisionBit=QAM16_demapper(DecisionSymbol);     % Symbol to bit demapping
            
            
            %  Bit Error Calculation
            N_error_frame=sum(bitSeq~=DecisionBit);     % Current Error
            
            N_Error_Bit=N_Error_Bit+N_error_frame;      % Total Error bits
            N_Tx_Bit=N_Tx_Bit+N_Bit_frame;              % Total Tx bits
        end
        
        simBer_Rayleigh(n_antenna,ii)=N_Error_Bit./N_Tx_Bit;           % Simulation BER        
    end
    
    
end

%%

theoryBer = (1/k)*3/2*erfc(sqrt(k*0.1*(10.^(Eb_N0_dB/10))));  % Theoretical BER

close all; figure
semilogy(Eb_N0_dB,theoryBer,'bs-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer_Rayleigh(1,:),'ms-','LineWidth',2);
semilogy(Eb_N0_dB+3,simBer_Rayleigh(2,:),'rp-','LineWidth',2);
semilogy(Eb_N0_dB+4.77,simBer_Rayleigh(3,:),'g>-','LineWidth',2);
semilogy(Eb_N0_dB+6,simBer_Rayleigh(4,:),'k*-','LineWidth',2);


axis([0 13 10^-4 1])
grid on
legend('theory', '1 Antenna','2 Antenna','3 Antenna','4 Antenna');
xlabel('Eb/No, dB')
ylabel('Bit Error Rate')
title('Bit error probability curve for 16-QAM modulation')

