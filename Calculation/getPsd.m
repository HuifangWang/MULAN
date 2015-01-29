function psd = getPsd(lfp, fs, freqs)
[Nchannel,nTime]=size(lfp);
nFreq=length(freqs);
psd=zeros(Nchannel,nTime,nFreq);
for i=1:Nchannel
psd(i,:,:)=awt_freqlist(lfp(i,:), fs, freqs);
end