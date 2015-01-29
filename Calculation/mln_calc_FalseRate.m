%%function [ih,f0,f1,Fpr,Tpr,Fnr,pFDR,t,auc,flag_use,th_offcut_roc]=calc_FalseRate(iM,Standard_Net,issymetricM)
% Huifang Wang, April, 2012, Inserm U1106
% Huifang, Sep.,12; updated;
% Huifang, 21, Feb; cutoff of auc 
%th_offcut_roc=[th,iFPR,iTPR];
function varargout =mln_calc_FalseRate(iM,Standard_Net,issymetricM,issample)

% iM is the Matrix to be evaluated; Standard_Net is the Matrix as
% reference; issymetricM=[1,1] means both Matrix are sysmetrics
nout = max(nargout,1);
%issample=1;
flag_use=1;
%% Get the distribution of the pairs with H0=T and the pairs with H0=F
% 

bi_Standard=Standard_Net(:,:)~=0;
if sum(issymetricM)  % if either one of Matrix are symmetric then
bi=bi_Standard| bi_Standard';
%iM=max(iM,iM'); % directed Matrix becomes to a symmetric one
else bi=bi_Standard;
end
%iM=mean(Norm_multiNet,3);
H0=iM(~bi);
H1=iM(bi);
NH0=length(H0);
NH1=length(H1);

if isempty(H0) || isempty(H1)
    flag_use=0; %% this is not the good way to 
    varargout{nout-1}=0;
varargout {nout}=flag_use;
    return
end
Nsteps=100;
ih=linspace(min(min(iM)),max(max(iM)),Nsteps);
t=ih(ih>=0);

if issample==0
%% Get the kineral density estimate

f0=ksdensity(H0,ih,'kernel','normal','function','pdf');
f1=ksdensity(H1,ih,'kernel','normal','function','pdf');
g0=ksdensity(H0,ih,'function','cdf');
g1=ksdensity(H1,ih,'function','cdf');

% calulate the False positive rate and True positive rate from keneral
% denisity estimate
% when min(ih0)<0

Nt=length(t);
Fpr=zeros(Nt,1);
Tpr=zeros(Nt,1);
pFDR=Fpr;
%FDR=Fpr;
prh0=NH0/(NH0+NH1);
prh1=NH1/(NH0+NH1);
corernposition=[0,1];
dMatrix=zeros(Nt,1);
i=1;
Fpr(1)=1;
Tpr(1)=1;
pFDR(i)=Fpr(i)*prh0/(Fpr(i)*prh0+Tpr(i)*prh1);
    dMatrix(i)=norm([Fpr(i)-corernposition(1),Tpr(i)-corernposition(2)]);
for i=2:Nt
    Fpr(i)=1-g0(ih==t(i));
    Tpr(i)=1-g1(ih==t(i));
    pFDR(i)=Fpr(i)*prh0/(Fpr(i)*prh0+Tpr(i)*prh1);
    dMatrix(i)=norm([Fpr(i)-corernposition(1),Tpr(i)-corernposition(2)]);
end

[~,indexMin]=min(dMatrix);
th_offcut_roc=[t(indexMin),Fpr(indexMin),Tpr(indexMin)];
else
%% count FPR and TPR 

NH0=length(H0);
NH1=length(H1);
f0=[];
f1=[];

Nt=length(t);
Fpr=zeros(Nt,1);
Tpr=zeros(Nt,1);
pFDR=Fpr;
prh0=NH0/(NH0+NH1);
prh1=NH1/(NH0+NH1);
corernposition=[0,1];
dMatrix=zeros(Nt,1);
Fpr(1)=1;
Tpr(1)=1;
i=1;
pFDR(i)=Fpr(i)*prh0/(Fpr(i)*prh0+Tpr(i)*prh1);   
    dMatrix(i)=norm([Fpr(i)-corernposition(1),Tpr(i)-corernposition(2)]);
for i=2:Nt
    Fpr(i)=(sum(H0>t(i)))/NH0;
    Tpr(i)=(sum(H1>=t(i)))/NH1;
    pFDR(i)=Fpr(i)*prh0/(Fpr(i)*prh0+Tpr(i)*prh1);   
    dMatrix(i)=norm([Fpr(i)-corernposition(1),Tpr(i)-corernposition(2)]);
end
[~,indexMin]=min(dMatrix);
th_offcut_roc=[t(indexMin),Fpr(indexMin),Tpr(indexMin)];
end

Fnr=bsxfun(@minus,1,Tpr);
if isempty(find(iM))
    auc=0.5;
else

auc = 0.5*sum( (Fpr(2:end)-Fpr(1:end-1)).*(Tpr(2:end)+Tpr(1:end-1)) );
auc = abs(auc);
end

varargout {1}=ih;
varargout {2}=f0;
varargout {3}=f1;
varargout {4}=Fpr;
varargout {5}=Tpr;
varargout {6}=Fnr;
varargout {7}=pFDR;
varargout {8}=t;
varargout {9}=auc;
varargout {10}=flag_use;
varargout{11}=th_offcut_roc;