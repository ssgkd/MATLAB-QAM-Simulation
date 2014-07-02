% QAM16_slicer.m 
function [X_hat] =QAM16_slicer(X)
Nc = length(X);
for i=1:Nc
   % real part decision
   if real(X(i))<-2./sqrt(10.)
      R=-3./sqrt(10.);
   elseif (-2./sqrt(10.)<=real(X(i)))&&(real(X(i))<0)
      R=-1./sqrt(10.);
   elseif ( 0<=real(X(i)))&&(real(X(i))<2./sqrt(10.))
      R=1./sqrt(10.);
   elseif 2./sqrt(10.)<=real(X(i))
      R=3./sqrt(10.);
   end
   
   % imaginary part decision
   
   if imag(X(i))<-2./sqrt(10.)
      I=-3./sqrt(10.);
   elseif (-2./sqrt(10.)<=imag(X(i)))&&(imag(X(i))<0)
      I=-1./sqrt(10.);
   elseif ( 0<=imag(X(i)))&&(imag(X(i))<2./sqrt(10.))
      I=1./sqrt(10.);
   elseif 2./sqrt(10.)<=imag(X(i))
      I=3./sqrt(10.);
   end

   X_hat(i)=R+j*I;
   
end