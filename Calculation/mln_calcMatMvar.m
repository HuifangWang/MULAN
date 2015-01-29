function mln_calcMatMvar(Resultfile,VMethlog,lfp,params)
%% to calculate the connectivity matrix for Mvar_based methods in Methlog
% Methlog:  'MVAR': MVAR
% Huifang Wang, May 28, 2012, Inserm U1106, Marseille
Methlog=char(VMethlog{1});
NMlog=length(Methlog);
if exist(Resultfile,'file')
Rconnect=load(Resultfile);
oddfieldname=fieldnames(Rconnect);
if  ~isempty(find(strncmpi(oddfieldname,Methlog,NMlog)==1,1))% if there is results about 'Methlog'
   % try to find the results with the same parameters
   Nmethlog=length(Rconnect.(Methlog));
   for i=1:Nmethlog
     if mln_compareparams(Rconnect.(Methlog)(i).Params,params)  
        %Net=Rconnect.(Methlog)(i);
        return;
     end
   end
end
end
%% if there is not the result then calculate

[Nchannel, Ntime]=size(lfp);
freqs=params.minfreq:params.stepfreq:params.maxfreq;
Nfreq=length(freqs);

if ~params.overlap==0
overlap_p=params.wins*params.overlap;
Nwindows=floor((Ntime-overlap_p)/(params.wins-overlap_p));
else
    overlap_p=0;
    Nwindows=floor(Ntime/params.wins);
end
% initialization
Dmatf=[Nchannel,Nchannel,Nfreq,Nwindows];
NMeths=length(VMethlog);
for i=1:NMeths
    iMeth=char(VMethlog{i});
    if ~isempty(iMeth)
Mat.(iMeth)=zeros(Dmatf); 
    if strncmpi(VMethlog{i},'MVAR',4) || strncmpi(VMethlog{i},'AS',2)
        Mat.(iMeth)=zeros([Nchannel,Nchannel,Nwindows]);
    end
    end
end

VMethodlog=fieldnames(Mat);
Nmethod=length(VMethodlog);
%%% calculate 
for i=1:Nwindows
    i_lfp=lfp(:,floor((i-1)*(params.wins-overlap_p)+1):floor(i*params.wins-(i-1)*overlap_p));
    iMat=mln_icalcMatMvar(i_lfp',params.modelOrder,freqs,params.fs);
    for j=1:Nmethod
        if strncmpi(VMethodlog{j},'MVAR',4) || strncmpi(VMethodlog{j},'AS',2)
            Mat.(char(VMethodlog(j)))(:,:,i)=iMat.(char(VMethodlog(j)));
        else 
            Mat.(char(VMethodlog(j)))(:,:,:,i)=iMat.(char(VMethodlog(j)));
        end
    end
end

updateResult(Resultfile,Mat,params);
% if nargout>0
%     varargout=Mat;
% end