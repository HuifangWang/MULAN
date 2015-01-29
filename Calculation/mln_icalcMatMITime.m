function Mat=icalcMatMITime(lfp,params)
%% this function is used to calculate the mutual Inforamtion with time
%% delay
% June, 12, Huifang Wang Marseille
maxlag=params.MaxDelay;
bins=params.bins;


[nchan,ntime]=size(lfp);
BMITD2=zeros(nchan,nchan,maxlag+1);
BMITD1=zeros(nchan,nchan,maxlag+1);

for tau=0:maxlag;    
    for ichan=1:nchan; 
         for jchan=1:nchan;
             P2=hist2xy(lfp(ichan,:),lfp(jchan,:),bins,tau);   
             P1x=sum(P2,2);           % distribution for x
             P1y=sum(P2,1);             % distribution for y
           %% compute the mutual information
              I1=[-sum((P1x(P1x~=0)).*log(P1x(P1x~=0))), -sum((P1y(P1y~=0)).*log(P1y(P1y~=0)))];                      % entropies of Px and Py
              I2=-sum(P2(P2~=0).*log(P2(P2~=0)));                                                                    % entropy of joint distribution Pxy
              I2_syserr=(length(P1x(P1x~=0))+length(P1y(P1y~=0))-length(P2(P2~=0).*log(P2(P2~=0)))-1)/(2*ntime); % standard error for estimation of entropy
              BMITD2(jchan,ichan,tau+1)=I1(1)+I1(2)-I2+I2_syserr;
              BMITD1(jchan,ichan,tau+1)=I1(1)+I1(2)-I2;
              %% different way to calculate the mutual information
              %P1x1y=P1x*P1y+eps.*ones(bins);
              %MI2=sum(sum(P2.*logw0(P2./P1x1y)));
         end
    end
end
Mat.BMITD2=max(BMITD2,[],3)/log(bins);
Mat.BMITD1=max(BMITD1,[],3)/log(bins);
Mat.BMITU=max(Mat.BMITD1,Mat.BMITD1');%% updated Huifang Dec, 13, 2012
Mat.PMITD2=mln_Dir2Partial(Mat.BMITD2);
Mat.PMITD1=mln_Dir2Partial(Mat.BMITD1);
Mat.PMITU=mln_Dir2Partial(Mat.BMITU);

%% subfunction
function pxy=hist2xy(x,y,nbin,tau)
% normalise the value range to [0 1)
x1 = (x - min(x)) / max(x - min(x)) - eps;
y1 = (y - min(y)) / max(y - min(y)) - eps;

% this is the smart trick from CRP Toolbox:mi; main trick: put the first data to values [1:1:nbin] and the second data to [nbin:nbin:nbin^2]
temp = fix(x1(1:(end-tau)) * nbin) + (fix(y1((tau+1):end) * nbin)) * nbin;

% call Matlab histc function (faster than hist)
p=histc(temp,0:(nbin^2-1))';
pxy=reshape(p,nbin,nbin)/length(x);
% function y=logw0(x)
% y=x;
% nx=size(x,1);
% for i=1:nx
%     for j=1:nx
% if x(i,j)==0
%     y(i,j)=0;
% else
%     y(i,j)=log(x(i,j));
% end
%     end
% end
