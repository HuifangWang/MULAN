function mln_calcMatTimeBasic(Resultfile,VMethlog,lfp,params)
%% to calculate the connectivity matrix for Time Basic methods in Methlog
% Methlog:  'DCorrSym','DCorrDir','PCorrSym','PCorrDir'
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
Dmatf=[Nchannel,Nchannel,Nwindows];
NMeths=length(VMethlog);
for i=1:NMeths
    iMeth=char(VMethlog{i});
    if ~isempty(iMeth)
    Mat.(iMeth)=zeros(Dmatf); 
    end
end

VMethodlog=fieldnames(Mat);
Nmethod=length(VMethodlog);
for i=1:Nwindows
    i_lfp=lfp(:,floor((i-1)*(params.wins-overlap_p)+1):floor(i*params.wins-(i-1)*overlap_p));
    iMat=mln_icalcMatTimeBasic(i_lfp,params.MaxDelay);
    for j=1:Nmethod
            Mat.(char(VMethodlog(j)))(:,:,i)=iMat.(char(VMethodlog(j)));
    end
end

updateResult(Resultfile,Mat,params);