%%
% Blog : http://iamaman.tistory.com
% Author : JKD
% Github : https://github.com/ssgkd/MATLAB-QAM-Simulation

%% 
clc
clear all

M = 16;   % M-ary
k = log2(M); % bits per symbol

N_Bit_frame=240;
N_Symbol=N_Bit_frame/k;     % Number of symbol per frame
N_Error_Th=300;


Eb_N0_dB  = [0:12];
Es_N0_dB  = Eb_N0_dB + 10*log10(k);

simBer_AWGN=zeros(size(Eb_N0_dB));
simBer_Rayleigh=zeros(size(Eb_N0_dB));



for ii = 1:length(Eb_N0_dB)
    
    %%      AWGN Simulation
    N_Tx_Bit=0;
    N_Error_Bit=0;
    
    fprintf('AWGN %d dB Simulation... \n', Eb_N0_dB(ii));
    
    while (N_Error_Bit <= N_Error_Th)  % Error 가 300 보다 작은 경우 까지만 시뮬레이션 한다
        %     for nnnn=1:1000
        bitSeq=randi([0,1],1,N_Bit_frame);  % Bit generation
        QamSymbol=QAM16_mapper(bitSeq);     % Power Normalized 16 QAM mapping
        
        %  AWGN
        n = 1/sqrt(2)*[randn(1,N_Symbol) + j*randn(1,N_Symbol)]; % White Guassian Noise
        y = QamSymbol + 10^(-Es_N0_dB(ii)/20)*n; % Additive White Gaussian Noise
        
        
        %  Receiver
        DecisionSymbol=QAM16_slicer(y);         % Symbol Decision
        DecisionBit=QAM16_demapper(DecisionSymbol);     % Symbol to bit demapping
        
        
        %  Bit Error Calculation
        N_error_frame=sum(bitSeq~=DecisionBit);     % Current Error
        
        N_Error_Bit=N_Error_Bit+N_error_frame;      % Total Error bits
        N_Tx_Bit=N_Tx_Bit+N_Bit_frame;              % Total Tx bits
    end
    
    simBer_AWGN(ii)=N_Error_Bit./N_Tx_Bit;           % Simulation BER
    
    
    %%      Flat Fading Simulation
    
    N_Tx_Bit=0;
    N_Error_Bit=0;
    
    fprintf('Fading %d dB Simulation... \n', Eb_N0_dB(ii));
    
    while (N_Error_Bit <= N_Error_Th)  % Error 가 300 보다 작은 경우 까지만 시뮬레이션 한다
        
        bitSeq=randi([0,1],1,N_Bit_frame);  % Bit generation
        QamSymbol=QAM16_mapper(bitSeq);     % Power Normalized 16 QAM mapping
        
        %  Flat fading & AWGN
        h = 1/sqrt(2)*[randn(1,N_Symbol) + j*randn(1,N_Symbol)]; % flat Rayleigh fading       
        n = 1/sqrt(2)*[randn(1,N_Symbol) + j*randn(1,N_Symbol)]; % White Guassian Noise
        
        y = QamSymbol.*h + 10^(-Es_N0_dB(ii)/20)*n; % flat Rayleigh fading & Additive White Gaussian Noise
        
        
        %  Receiver
        y1=y.*conj(h)./(abs(h).^2);             % Fading Channel Receiver
        
        DecisionSymbol=QAM16_slicer(y1);         % Symbol Decision
        DecisionBit=QAM16_demapper(DecisionSymbol);     % Symbol to bit demapping
        
        
        %  Bit Error Calculation
        N_error_frame=sum(bitSeq~=DecisionBit);     % Current Error
        
        N_Error_Bit=N_Error_Bit+N_error_frame;      % Total Error bits
        N_Tx_Bit=N_Tx_Bit+N_Bit_frame;              % Total Tx bits
    end
    
    simBer_Rayleigh(ii)=N_Error_Bit./N_Tx_Bit;           % Simulation BER
    
    
    
    
end

%%


theoryBer = (1/k)*3/2*erfc(sqrt(k*0.1*(10.^(Eb_N0_dB/10))));  % Theoretical BER

close all; figure
semilogy(Eb_N0_dB,theoryBer,'bs-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer_AWGN,'mx-','LineWidth',2);
semilogy(Eb_N0_dB,simBer_Rayleigh,'rp-','LineWidth',2);

axis([0 13 10^-4 1])
grid on
legend('theory', 'simulation','fading');
xlabel('Eb/No, dB')
ylabel('Bit Error Rate')
title('Bit error probability curve for 16-QAM modulation')

