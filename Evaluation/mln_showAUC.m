%% show the results
% show the AUC array for varying the number of windows
% Huifang Wang Feb 7, 2014, Demo for demonstrate the AUC array and Boxplot in the paper

function mln_showAUC
load('ExAUCnmmN5L5.mat','AUCall','Informa')
colormapnowall=colormap(lines);
cs=Informa.cs;
is=Informa.is;
model=Informa.model;
dcs=60;
struct='N5L5';
dirname=['/Volumes/HWMac1/MULANpre/',struct,'S/',model];
prenom=[model,struct];


shownMethods={'BCohF','PCohF','BCohW','PCohW',...
    'BCorrU','PCorrU','BCorrD','PCorrD', 'BH2U','PH2U','BH2D','PH2D','BMITU','PMITU','BMITD1','PMITD1','BMITD2','PMITD2'...
                         'BTEU','PTEU','BTED','PTED',...,
                         'GC','PGC','CondGC','MVAR','AS','Af','PDC','oPDCF','GPDC','DC1','DTF','GGC','ffDTF','dDTF','COH1','pCOH1','COH2','pCOH2','Smvar','hmvar'};

Nis=length(is);
Nmethods=42;
Ncs=length(cs);



Meths.Methodnames=Informa.Methodnames;


AUCm=mean(AUCall,3);
neworderMethod=mln_xorder_cell(Meths.Methodnames,shownMethods);
AUCm=AUCm(neworderMethod,:,:)';

screensize=min(get(0,'ScreenSize'),[1,1,1440,900]);

cutedge=10;
hf=figure('name',[dirname,', AUC'],'color','w','position',[cutedge,cutedge,screensize(3)-cutedge,screensize(4)-cutedge,]);
ha=subplot(2,1,1);
imagesc(squeeze(AUCm));

colormap(jet)
set(ha,'XTick',1:Nmethods,'XTickLabel',shownMethods);
xticklabel_rotate;
set(ha,'YTick',1:Ncs,'YTickLabel',num2cell(cs/100),'YDir','normal');
set(ha,'CLim',[0.7,1]);
title(['AUC average values cross over all poissible structure:',Informa.model],'Fontsize',15)

set(ha,'Fontsize',12);


%return;

colormapnow=colormapnowall([1:7],:);

%hf=figure('color','w');
ha=subplot(2,1,2);
hold on
%MULANics=squeeze(MLN_AUCM(cs==dcs,:));
%boxplot(MULANics,'color','g');

AUCMics=squeeze(AUCall(:,cs==dcs,:));
AUCMics=AUCMics(neworderMethod,:);
%AUCMics=[AUCMics;MULANics];
%boxplot(AUCMics','plotstyle','compact','notch','on');

xTicklabel=shownMethods;
%xTicklabel{39}='MULAN'

boxplot(AUCMics','notch','on','medianstyle','target','labels',xTicklabel,'labelorientation','inline')
%set(ha,'XTickLabel',xTicklabel,'labelorientation','inline')
numbers=[4 4 4 6 4 3 17];
for inumbers=1:length(numbers)
    istart=sum(numbers([1:inumbers-1]))+1;
    ifini=sum(numbers([1:inumbers]));
    colorgroup(istart:ifini,:)=repmat(colormapnow(inumbers,:),numbers(inumbers),1);
end
colorgroup=colorgroup(end:-1:1,:);
hobj = findobj(gca,'Tag','Box');
 for j=1:length(hobj)
    patch(get(hobj(j),'XData'),get(hobj(j),'YData'),colorgroup(j,:),'FaceAlpha',.5);
 end

 set(gca,'YLim',[0.3,1])
 title(['Boxplot on 154 different structures: connection strength=',num2str(dcs/100)],'Fontsize',15);



