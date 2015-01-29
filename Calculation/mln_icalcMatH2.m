function Mat=icalcMatH2(lfp,modelOrder,bins)

%% calculate the correlation coefficient with delay
nchannel=size(lfp,1);
Mat.BH2D=zeros(nchannel);
ijh2=zeros(modelOrder,1);
for i=1:nchannel
    for j=1:nchannel
        for tou=0:modelOrder
     ijh2(tou+1)=mln_h2pair(lfp(i,:),lfp(j,:),tou,bins);
        end
        [~,Iij]=max(abs(ijh2));
        Mat.BH2D(j,i)=ijh2(Iij);
    end
end
Mat.BH2U=max(Mat.BH2D,Mat.BH2D');
%Mat.DH2E=updateEC(Mat.DH2E);
Mat.PH2U=mln_Dir2Partial(Mat.BH2U);
Mat.PH2D=mln_Dir2Partial(Mat.BH2D);

% %% updated effective connectivity function
% function M1=updateEC(M)
% M1=M;
% [Ni,Nj]=size(M);
% for i=1:Ni
%     for j=i:Nj
%         if M(i,j)>M(j,i)
%             M1(j,i)=0;
%             M1(i,j)=M(i,j);
%         else
%             M1(i,j)=0;
%             M1(j,i)=M(j,i);
%         end
%         if abs(M(i,j)-M(j,i))<=0.001
%             M1(j,i)=M(j,i);
%             M1(j,i)=M(j,i);
%             
%         end
%     end
% end