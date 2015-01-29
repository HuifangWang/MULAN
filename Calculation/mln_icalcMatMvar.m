function Mat=mln_icalcMatMvar(lfp,Morder,freqs,fs)
[AR,~,PE] = mvar(lfp,Morder);
nchannel = size(AR,1); % number of channels       
A = [eye(nchannel),-AR];
B = eye(nchannel); 
C = PE(:,nchannel*Morder+1:nchannel*(Morder+1)); 

%Net=zeros(nchannel);
% %% sum
% for i=1:Morder
%     Net=Net+AR(:,(i-1)*nchannel+1:i*nchannel);
% end
AR03=reshape(AR,nchannel,nchannel,Morder);
Net=max(abs(AR03),[],3);
Mat.MVAR=Net;
[Mat.Smvar,  Mat.hmvar, Mat.PDC, Mat.COH1, Mat.DTF, Mat.DC1, Mat.pCOH1, Mat.dDTF, Mat.ffDTF, Mat.pCOH2,Mat.oPDCF, Mat.COH2, Mat.GGC, Mat.Af, Mat.GPDC, Mat.AS] = mvfreqz(B,A,C,freqs,fs);