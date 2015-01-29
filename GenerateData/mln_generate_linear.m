% make connectivity simulations for superAR
function [dataname,flag_LFP]=mln_generate_linear(dirname,prename,npts,strfile,is,cs,delaydelay)
% Huifang Wang based on the code from Christian Benar
% test for MVAR modelling
% MVAR simulation code coming from demo7 from biosig toolbox
dataname=[prename,'linearCS',num2str(100*cs),'S',num2str(is),'N',num2str(npts)];
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
% Variables:
%  nreal: number of realizations
%  overfact_list: oversampling factors (new order = oversamp factor x original order)
%  AR_array: simulated MVAR parameters
%  y_array:  simulated signals  nchan x npts x nover x nreal;


load(strfile,'PGS');
%Nglist=length(PGS);

Astru=PGS{is};
SparseA=sparse(Astru(1,:),Astru(2,:),1);
P.A=full(SparseA);
nchan=max(max(Astru));
Nlink=size(Astru,2);
orderModel=randi(3,[1,Nlink]);
AR0=zeros(nchan,nchan*3);
AR0(1,1)=.95*sqrt(2);
AR0(1,nchan+1)=-0.9025;
for ilink=1:Nlink
AR0(Astru(2,ilink),nchan*(orderModel(ilink)-1)+Astru(1,ilink)) =cs;  
end
%auto_chans=1;    % channels with auto-regressive parts

%delaydelay=1;
AR0=putdelay(AR0,delaydelay);
norder= size(AR0,2)/nchan; % order of original model 
flag_LFP=1;
% init
%RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
   
 x = randn(nchan,npts);
        % Simulated MVAR process
    LFP= mvfilter(eye(nchan),[eye(nchan),-AR0],x);
    if max(max(LFP))<1000
        flag_LFP=0;
    end
   
    Net=zeros(nchan,nchan);
% for i=1:norder
%     Net=Net+AR0(:,(i-1)*nchan+1:i*nchan);
% end
AR03=reshape(AR0,nchan,nchan,norder);
Net=max(abs(AR03),[],3);

Connectivity=Net;
Params.npts=npts;
Params.fs=100;
 save(filename,'LFP','Connectivity','Params');
 msgbox('Data Generated','Success','custom',cdata);

 end
function AR=putdelay(AR0,delaydelay)
nchan = size(AR0,1); % number of channels
norder= size(AR0,2)/nchan;
cur_order=(norder-1)*(delaydelay)+1;
        AR=zeros(nchan,cur_order*nchan);
        for i=1:norder
            AR(:,(i-1)*delaydelay*nchan+(1:nchan))=AR0(:,(i-1)*nchan+(1:nchan));
        end;
        auto_chans=1;
        % keep channels with autoregressive aprt (or else they could be unstable)
        for i=1:length(auto_chans)
            AR(auto_chans(i),:)=0;
            AR(auto_chans(i),1:size(AR0,2))=AR0(auto_chans(i),:);
        end
    

