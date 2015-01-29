function istimeM=istimeM(Methlog)
%% this function is used to tell issymetricM whether Methlog can obtain a
%% symetric results or not: issymetricM=1 if Methlog can get symtric matrices 
istimeM=0;
timeMs={'BCorrD','BCorrU','PCorrD','PCorrU','GC','PGC','CondGC',...
    'BH2D','PH2U','PH2D','BH2U','BSynchroS','BSynchroH','BSynchroN',...
    'PSynchroS','PSynchroH','PSynchroN','BMITD1','BMITD2',...
    'PMITD1','PMITD2','BMITU', 'PMITU', 'DPSPLVH',...
    'DPSENTH','BTED','BTEU','PTED','PTEU'};
%Nonsymetric={'Af','PDC','PDCF','DTF'};

NMlog=length(Methlog);
if ~isempty(find(strncmpi(timeMs,Methlog,NMlog)==1,1))
    istimeM=1;
end