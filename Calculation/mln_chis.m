function chis=mln_chis(Mat,x)

%% chis is the c hist of bootstrapping of Mat

nboot=1000;
nbins=100;

    
    [Nnode,~,Nwin]=size(Mat);
    isizeboot=Nnode*(Nnode-1);
    
    MatBoot=NaN( isizeboot*nboot,1);
    
    iMat=mean(abs(Mat),3);
    iMat(1:size(iMat,1)+1:end) = NaN;
    a=reshape(iMat,Nnode*Nnode,1);
    MatBoot(1:isizeboot,1)=a(~isnan(a));
    
    for iboot=2:nboot
        iBoot_ind=randi(Nwin,[1,Nwin]);
        iBoot_Mat=Mat(:,:,iBoot_ind);
        iMat=mean(abs(iBoot_Mat),3);
        iMat(1:size(iMat,1)+1:end) = NaN;
        a=reshape(iMat,Nnode*Nnode,1);
        MatBoot((iboot-1)*isizeboot+1:iboot*isizeboot,1)=a(~isnan(a));
    end
    xi=linspace(min(MatBoot),max(MatBoot),nbins);
    n_elements = histc(MatBoot,xi);
    c_elements = cumsum(n_elements);
    c_elements=c_elements./max(c_elements);
    %% the means for all windows
        chis=c_elements(find(xi>=x,1));
   