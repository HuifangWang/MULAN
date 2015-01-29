function mln_plotTime4Analysis(g)

figure('name',g.Methlog);
Net=g.Net;
fs=g.fs;

Nchan=size(Net,1);
NT=size(Net,3);
if length(size(Net))>3
iwNet=squeeze(Net(:,:,:,iw));
else
    iwNet=Net;
end
ymax=max(max(max(iwNet)));
ymin=min(min(min(iwNet)));
T=(1:NT)/fs;
meanC=mean(Net,3);
for i=1:Nchan
    for j=1:Nchan
        subplot(Nchan,Nchan,(i-1)*Nchan+j);
        mCij=meanC(i,j)*ones(size(T));
        plot(T,squeeze(Net(i,j,:)),'b--',T,mCij,'m-','Linewidth',2);
        set(gca,'YLim',[ymin,ymax]);
    end
end
