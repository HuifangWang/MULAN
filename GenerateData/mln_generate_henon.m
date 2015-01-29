% make connectivity simulations for Henon systems
%% this function is used to generate the henon map nonlinear systems with
%%% noise and delay
%% Huifang Wang Sep. 4, 2012
function [dataname,flg]=mln_generate_henon(dirname,prename,npts,strfile,is,cs,odelay,flag_noise,SNR)

dataname=[prename,'henonCS',num2str(100*cs),'S',num2str(is),'N',num2str(npts)];
 filename=['./',dirname,'/data/',dataname,'.mat'];
 [cdata] = imread('MULANLOGO.png'); 
 if exist(filename,'file')
     
     msgbox('Data already there','Success','custom',cdata);
 else
     if ~exist(dirname,'dir')
         mkdir(dirname);
     end
     datadir=[dirname,'/data'];
     if ~exist(datadir,'dir')
         mkdir(datadir);
     end
flg=0; % good data
% delaydelay =0 default

load(strfile,'PGS');
%Nglist=length(PGS);

Astru=PGS{is};
SparseA=sparse(Astru(1,:),Astru(2,:),1);
P.A=full(SparseA);
nchan=max(max(Astru));
P.A(nchan,nchan)=0;
P.A=P.A*cs;
a=1.4;

if mod(nchan,2)
    b=randi([20 27],1,nchan)/100;
else
b=[randi([20,25],1,nchan/2)/100,randi([25,30],1,nchan/2)/100];
end
%b=[0.25,0.22,0.3,0.29,0.27,0.28];
d=ones(1,nchan); % systems with 5 channels

%flag_noise=0;
%SNR=20;
startTime=100;
ofs=100; % original sample frenquecy which depends on the ode RelTol
CM=P.A;

T=0:npts;
NT=length(T);
X=zeros(nchan,NT);
if odelay==0
    for iT=3:NT
        for ichan=1:nchan
            xij=bsxfun(@times,X(1:nchan,iT-1), X(ichan,iT-1));
            X(ichan,iT)=d(ichan)-(CM(ichan,:)*xij+(a-sum(CM(ichan,:)))*X(ichan,iT-1)^2)+b(ichan)*X(ichan,iT-2);
        end
    end

end
 %%%%%%%%%%%%%%%%%%%%%%
 startT=find(T>startTime,1);
 T=T(startT:end)-startTime;
 X=X(:,startT:end);

 TotalTime=npts-startTime;


%% save the data
LFP=X;
if ~isempty(find(isnan(max(LFP))==1)) || ~isempty(find(LFP>1000))
    flg=1; %%% baddata
    dataname=[];
    return;
end

Connectivity=CM;
Params.npts= TotalTime*ofs;
Params.fs=ofs;
Params.model.abc=[a,b,d];
Params.flag_noise=flag_noise;
Params.SNR=SNR;
Params.fs=100;
 save(filename,'LFP','Connectivity','Params');
 msgbox('Data Generated','Success','custom',cdata);

 end


function C2=insertdelay(C1,DelayV)
odelay=max(max(DelayV));
if odelay==0
    C2=C1;
    return;
end
nchan=size(C1,1);

C2=zeros(nchan,odelay*nchan);
for i=1:odelay
    [row,col]=find(DelayV==i);
    C0=zeros(nchan,nchan);
    C0(row,col)=C1(row,col);
    C2(:,(i-1)*nchan+1:i*nchan)=C0;
end
    

