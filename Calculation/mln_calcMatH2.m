function mln_calcMatH2(Resultfile,VMethlog,lfp,params)

%% to calculate the connectivity matrix for Mvar_based methods in Methlog
% Methlog:  'MVAR': MVAR
% Huifang Wang, June 8, 2012, Inserm U1106, Marseille
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

if ~params.overlap==0
overlap_p=params.wins*params.overlap;
Nwindows=floor((Ntime-overlap_p)/(params.wins-overlap_p));
else
    overlap_p=0;
    Nwindows=floor(Ntime/params.wins);
end
% initialization
Dmatt=[Nchannel,Nchannel,Nwindows];
NMeths=length(VMethlog);
for i=1:NMeths
    iMeth=char(VMethlog{i});
    if ~isempty(iMeth)
        if istimeM(iMeth)
    Mat.(iMeth)=zeros(Dmatt);
        else Mat.(iMeth)=zeros(Dmatf);
        end
    end
end

VMethodlog=fieldnames(Mat);
Nmethod=length(VMethodlog);
for i=1:Nwindows
    i_lfp=lfp(:,floor((i-1)*(params.wins-overlap_p)+1):floor(i*params.wins-(i-1)*overlap_p));
    iMat=mln_icalcMatH2(i_lfp,params.MaxDelay,params.bins);
    for j=1:Nmethod
            jMethodlog=char(VMethodlog(j));
            if istimeM(jMethodlog)
            Mat.(jMethodlog)(:,:,i)=iMat.(jMethodlog);
            else
                Mat.(jMethodlog)(:,:,:,i)=iMat.(jMethodlog);
            end
    end
end

updateResult(Resultfile,Mat,params);