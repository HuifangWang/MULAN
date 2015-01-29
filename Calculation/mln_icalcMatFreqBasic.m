function Mat=mln_icalcMatFreqBasic(lfp,freqs,fs)

%% Huifang Wang, 04, June, 13 update the method name

nchannel=size(lfp,1);

Nwins=8;
% Number of arrows and flag for plots.
[Nchannel,Ntimes]=size(lfp);
Nfreqs=length(freqs);
%flag_SMOOTH = true;
NTW = min([round(0.05*Ntimes),20]);
nfft=(Nfreqs-1)*2;
window=floor(Ntimes/Nwins);
noverlap=floor(window/2);
%z=[Nchannel,Ntimes,Nfreqs];
%% calculate for wavelet
%% initialization

zbar=[Nchannel,Nchannel,Nfreqs];
DCohw=zeros(zbar);
%DCohwN=zeros(zbar);
DCohf=zeros(zbar);
cfs.w = getPsd(lfp,fs,freqs);
%cfs.f=zeros(Nchannel,Nfreqs);
% for i=1:Nchannel
%      cfs.f(i,:) = pwelch(lfp(i,:), window, noverlap, nfft, fs)';
% end
for i=1:Nchannel
    for j=i:Nchannel
       %% wavelet
          cfs1(:,:)=cfs.w(i,:,:);
          cfs2(:,:)=cfs.w(j,:,:);
          [cross, ~]=getcc(cfs1,cfs2,'ntw',NTW);
          DCohw(i,j,:)=squeeze(mean(abs(cross),1));
          %DCohwN(i,j,:)=squeeze(mean(abs(coh),1));
         %% fft
         %cfs_fcross(i,j,:) = cpsd(lfp(i,:), lfp(j,:), window, noverlap, nfft, fs);
         DCohf(i,j,:)      = mscohere(lfp(i,:), lfp(j,:), window, noverlap, nfft, fs);
    end
end
for i=1:Nfreqs
iDCohw=NormalizeMatrixSymmetric(DCohw(:,:,i));    
Mat.BCohW(:,:,i)=iDCohw'+iDCohw-diag(diag(iDCohw));
Mat.PCohW(:,:,i)=mln_Dir2Partial(Mat.BCohW(:,:,i));

iDCohf=DCohf(:,:,i);
Mat.BCohF(:,:,i)=iDCohf'+iDCohf-diag(diag(iDCohf));
Mat.PCohF(:,:,i)=mln_Dir2Partial(Mat.BCohF(:,:,i));
end
%Mat.cfs=cfs;
