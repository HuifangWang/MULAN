function Mat=icalcMatTimeBasic(lfp,modelOrder)

%% calculate the correlation coefficient with delay
%% Huifang Wang, 12, June, 12
%% Huifang Wang 04, June, 13 update the method name

nchannel=size(lfp,1);
Mat.BCorrU=zeros(nchannel);
Mat.BCorrD=zeros(nchannel);
for i=1:nchannel
    for j=i:nchannel
     ijxcorr=xcov(lfp(i,:),lfp(j,:),modelOrder,'coeff');
     [~,Imax]=max(abs(ijxcorr));
     %Mat.DCorrSym(i,j)=C;
     Mat.BCorrU(i,j)=ijxcorr(Imax);
     Mat.BCorrU(j,i)=Mat.BCorrU(i,j);
     Cij=ijxcorr((0:modelOrder)+modelOrder+1);
     [Dij,ImaxDij]=max(abs(Cij));
     Cji=ijxcorr((-modelOrder:0)+modelOrder+1);
     [Dji,ImaxDji]=max(abs(Cji));
%      if Dij>Dji
%          Mat.DCorrE(j,i)=0;
%          Mat.DCorrE(i,j)=Cij(ImaxDij);
%      else
%          Mat.DCorrE(i,j)=0;
%          Mat.DCorrE(j,i)=Cji(ImaxDji);
%          
%      end
%      if abs(Dij-Dji)<=0.001
%          Mat.DCorrE(j,i)=Cji(ImaxDji);
%          Mat.DCorrE(i,j)=Cij(ImaxDij);
%          
%      end
 Mat.BCorrD(j,i)=Dji;%% updated Dec. 13
Mat.BCorrD(i,j)=Dij;
    end

end

Mat.PCorrD=mln_Dir2Partial(Mat.BCorrD);
Mat.PCorrU=mln_Dir2Partial(Mat.BCorrU);

