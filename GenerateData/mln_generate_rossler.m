% make connectivity simulations for Rossler systems
%% this function is used to generate the henon map nonlinear systems with
%%% noise and delay
%% Huifang Wang Sep. 4, 2012
function [dataname,flgLFP]=mln_generate_rossler(dirname,prename,npts,strfile,is,cs,odelay,flag_noise,SNR)
dataname=[prename,'rosslerCS',num2str(100*cs),'S',num2str(is),'N',num2str(npts)];
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
% delaydelay =0 default
flgLFP=1;

load(strfile,'PGS');
%Nglist=length(PGS);

Astru=PGS{is};
SparseA=sparse(Astru(1,:),Astru(2,:),1);
P.A=full(SparseA);
nchan=max(max(Astru));
P.A(nchan,nchan)=0;
P.A=P.A*cs;

%flag_noise=0;
%SNR=20;
startTime=100;
ofs=100; % original sample frenquecy which depends on the ode RelTol
CM=P.A;

DelayV=ones(5)*odelay;%% without the delay
 %DelayV=[0,0,30,0,0 ;30,0,0,0,0;0,30,0,0,0;0,0,0,0,50;0,0,0,0,0];% rossler 9,11,12,13
 odelay=max(max(DelayV));
 C2=insertdelay(CM,DelayV);
 

 X0=zeros(3*nchan,1)';
 a=0.15;
 b=0.2;
 c=10;
% d=ones(nchan,1)+0.05*rand(nchan,1);
%d=[1+0.015,1-0.015,1,1+0.01,1-0.01]; % systems with 5 channels to rossler 1-6;
%d=[1+0.01,1+0.005,1,1-0.01,1-0.015]; % systems with 5 channels to rossler 7-12;
if mod(nchan,2)
    d=1+randi([-100 100],1,nchan)/1000;
else
d=[1+randi([1 100],1,nchan/2)/1000,1-randi([1 2],1,nchan/2)/1000];
end

 CM=C2*cs;
 dt=1/ofs;
 p=struct('a',a,'b',b,'c',c,'d',d);
 %%%%%%%%%%%%%Generate the data%%%%%
%odeoptions=odeset('RelTol',1e-3);
 %[T, X] = ode15s(@(T,X)rossler(T,X,a,b,c,d,CM,flag_noise,SNR),[0, SimulationTime],X0,odeoptions);
T=0:dt:npts;
NT=length(T);
X=zeros(3*nchan,NT);
if odelay==0
    for iT=2:NT
 X0=X(:,iT-1); 
 f=rosslerN(p,CM,X0,flag_noise,SNR);
 X(:,iT)=X(:,iT-1)+f*dt;
    end
else
for iT=1+odelay:NT
X0=X(:,iT-odelay:iT-1);
 f=rosslerN(p,CM,X0,flag_noise,SNR);
 X(:,iT)=X(:,iT-1)+f*dt;
end
end
 %%%%%%%%%%%%%%%%%%%%%%
 startT=find(T>startTime,1);
 T=T(startT:end)-startTime;
 X=X(:,startT:end);
 Y=X(((1:nchan)-1)*3+1,:);

 TotalTime=npts-startTime;
 %% save the data
LFP=Y;
 dataname=[prename,'CS',num2str(100*cs),'S',num2str(is)];

if ~isempty(find(isnan(max(LFP))==1)) || ~isempty(find(LFP>1000))
    flgLFP=0;
    return;
end
    

Connectivity=P.A;
Params.npts= TotalTime*ofs;
Params.fs=ofs;
Params.model.abc=[a, b,c];
Params.model.d=d;
Params.flag_noise=flag_noise;
Params.delay=DelayV;
Params.SNR=SNR;
AllState.X=X;
AllState.T=T;

  save(filename,'LFP','Connectivity','Params');
 msgbox('Data Generated','Success','custom',cdata);

 end
function f=rosslerN(p,CM,X0,flag_noise,SNR)
a=p.a;
b=p.b;
c=p.c;
d=p.d;
[nchan,nchandelay]=size(CM);
norder=nchandelay/nchan;
f=zeros(nchan*3,1);
Anoise=1/10^(SNR/20);
Xd=fliplr(X0);
X=X0(:,end);

for ichan=1:nchan
    dxji=bsxfun(@minus,Xd(((1:nchan)-1)*3+1,:), X((ichan-1)*3+1));
    dxji=reshape(dxji,nchan*norder,1);
    f((ichan-1)*3+1)=-d(ichan)*X((ichan-1)*3+2)-X((ichan-1)*3+3)+CM(ichan,:)*dxji+flag_noise*Anoise*X((ichan-1)*3+1)*rand(1);
    f((ichan-1)*3+2)=d(ichan)*X((ichan-1)*3+1)+a*X((ichan-1)*3+2);
    f((ichan-1)*3+3)=b+X((ichan-1)*3+3)*(X((ichan-1)*3+1)-c);
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