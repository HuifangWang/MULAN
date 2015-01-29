function relations=getconher(lfp,params,band)
[Nchannel,nTime]=size(lfp);
Npairs_ch=Nchannel*(Nchannel-1)/2;
fs=params.fs;
ntw=60;
switch band
    case 'S1'
       freqs=params.freqs.s1;
    case 'Delta'
       freqs=params.freqs.delta;

    case 'Theta'
       freqs=params.freqs.theta;
       
    case 'beta'
       freqs=params.freqs.beta;
      
    case 'gamma'
       freqs=params.freqs.gamma;
       
end
nFreq=length(freqs);
% relations = struct('cfs', zeros(Nchannel,nTime,nFreq), ...
%                    'crossM', zeros(Npairs_ch,nTime,nFreq), ...
%                    'crossP', zeros(Npairs_ch,nTime,nFreq),...
%                    'cohM', zeros(Npairs_ch,nTime,nFreq), ...
%                    'cohP', zeros(Npairs_ch,nTime,nFreq));

relations = struct('cfs', zeros(Nchannel,nTime,nFreq), ...
                   'crossM', zeros(Npairs_ch,nTime,nFreq), ...
                   'cohM', zeros(Npairs_ch,nTime,nFreq));
cfs = getPsd(lfp,fs,freqs);
for i=1:Nchannel
      for j=i+1:Nchannel
          cfs1(:,:)=cfs(i,:,:);
          cfs2(:,:)=cfs(j,:,:);
          [cross, coh]=getcc(cfs1,cfs2,'ntw',ntw);
          n_pairs=(i-1)*(Nchannel-1)-(i-1)*(i-2)/2+(j-i);
          relations.crossM(n_pairs,:,:)=abs(cross);
          relations.cohM(n_pairs,:,:)=abs(coh);
      
      end
end

for i=1:Nchannel
      relations.cfs(i,:,:)=abs(cfs(i,:,:));
end
